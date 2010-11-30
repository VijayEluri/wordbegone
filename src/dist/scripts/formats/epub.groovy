/*
 * Copyright © 2010 Leanne Northrop
 *
 * This file is part of Publisher Pipeline System.
 *
 * Samye Content Management System is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * Samye Content Management System is distributed in the hope that it will be
 * useful,but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Samye Content Management System.
 * If not, see <http://www.gnu.org/licenses/>.
 *
 * BT plc, hereby disclaims all copyright interest in the program
 * “Publisher Pipeline System” written by Leanne Northrop.
 */
 
 /**
 * Script to produce plain text document.
 *
 * @author Leanne Northrop
 * @since 29th November 2010, 21:38
 */
import javax.xml.transform.TransformerFactory
import javax.xml.transform.stream.StreamResult
import javax.xml.transform.stream.StreamSource
import org.apache.tools.ant.*
import groovy.xml.MarkupBuilder
import groovy.xml.StreamingMarkupBuilder
import groovy.util.XmlNodePrinter
import groovy.util.slurpersupport.NodeChild

def logMsgPrefix = "EPUB Formatting: "
def dir = "${home}"
def outDir = "${dir}/output/epub"

// Helper Functions
def transform(xsltFile,input) {
    def factory = TransformerFactory.newInstance()
    def transformer = factory.newTransformer(new StreamSource(new FileReader(xsltFile)))
    def w = new StringWriter() 
    transformer.transform(new StreamSource(new StringReader(input)), new StreamResult(w))
    w.toString()
}

def writeXMLFile(file,str,directive=true) {
    if (directive) {
        file.withWriter('utf8'){ w->
            w << '<?xml version="1.0" encoding="UTF-8"?>\n'
            w << str 
        }
    } else {
        file.withWriter('utf8'){ w->
            w << str 
        }
    }
}

def doMimetype() {
    new File("${home}/output/epub/mimetype").withWriter('US-ASCII'){ w->
        w << 'application/epub+zip'
    }    
}

def doManifest() {
    def xmlWriter = new StringWriter()
    def builder = new groovy.xml.MarkupBuilder(xmlWriter)

    builder.container(version:"1.0",xmlns:"urn:oasis:names:tc:opendocument:xmlns:container") {
        rootfiles {
            rootfile('full-path':"OEBPS/content.opf", 'media-type':"application/oebps-package+xml") 
        }
    }

    def ant = new AntBuilder()
    ant.mkdir(dir:"${home}/output/epub/META-INF")
    writeXMLFile(new File("${home}/output/epub/META-INF/container.xml"),xmlWriter.toString())
}

def doCoverPage() {
    def title = "unknown"
    def result = transform("${home}/input/xsl/epub_cover.xsl", "<book><title>${title}</title></book>")
    writeXMLFile(new File("${home}/output/epub/OEBPS/cover.xhtml"),result,false)
}

def doPageTemplate() {
    def result = transform("${home}/input/xsl/epub_template.xsl", "<book></book>")
    writeXMLFile(new File("${home}/output/epub/OEBPS/page-template.xpgt"),result,false)   
}

def doToc(xmlStr) {
    def result = transform("${home}/input/xsl/epub_toc.xsl", xmlStr)
    writeXMLFile(new File("${home}/output/epub/OEBPS/toc.ncx"),result,false)   
}

def doContentOpf(xmlStr) {
    def result = transform("${home}/input/xsl/epub_content_opf.xsl", xmlStr)
    writeXMLFile(new File("${home}/output/epub/OEBPS/content.opf"),result,false)   
}

def getContentsXML(files) {
    def xmlWriter = new StringWriter()   
    
    def builder = new groovy.xml.MarkupBuilder(xmlWriter)
    builder.book(author: 'me', title:'hi',publisher:'me') {
        files.each{file,filename ->
            
            def chpContents = new XmlSlurper().parseText(file.getText("utf8"))             
            chapter(index:chpContents.chapter[0].@index,
                    title: chpContents.chapter[0].@title,
                    file: filename) {
                chpContents.chapter[0].section.each {
                    section(index: it.@index, title: it.@title)
                }
            }
            images {
                def count = 0
                new File("${home}/output/epub/OEBPS/images").listFiles().toList().each { imageFile ->
                    image(id: count++, file: imageFile.name, mimetype:(imageFile.name.endsWith('png') ? 'image/png' : 'image/jpeg'))
                }
            }            
        }        
    }
    
    xmlWriter.toString() 
}

def ant = new AntBuilder()
ant.echo "${logMsgPrefix} Start"
ant.mkdir(dir:"${home}/output")
ant.mkdir(dir:outDir)
ant.mkdir(dir:"${outDir}/OEBPS")
if (isdebug) {
    ant.mkdir(dir:"${home}/output/debug")    
}
ant.echo "${logMsgPrefix} Copying HTML image files to ${dir}/input/img"
['png','jpg','jpeg'].each { ext ->
    ant.copy(todir:"${dir}/input/img") {
        mapper(type:"package", from: "*.${ext}", to:"html_*.${ext}")
        fileset(dir:"${dir}/input/html") {
            include(name:"**/*.${ext}")
        }
    }       
}

def files = [:]
def index = 0
new File("${dir}/input/xml/").listFiles(
    {d, file-> file ==~ /.*?\.xml/ && file != 'book.xml'} as FilenameFilter
  ).toList().each { inFile ->
    ant.echo "${logMsgPrefix} Processing ${inFile.name}"
    
    def outName = "f_${index}.html"
    def result = inFile.getText("utf8")    
    files.put(inFile, "f_${index}.html")
        
    ['epub_html'].each {
        result = transform("${dir}/input/xsl/${it}.xsl", result)
        if (isdebug && it != 'epub_html') {
            outFile = new File("${home}/output/debug/${inFile.name.replaceAll('.htm(l)*','')}_${it}.txt")
            outFile.withWriter('utf8'){ w->
                w << result
            }       
        }     
    }
    outFile = new File("${outDir}/OEBPS/${outName}")
    outFile.withWriter('utf8'){ w->
        w << result
    } 
    index++
}

ant.echo "${logMsgPrefix} Copying EPUB resource files"
['css':'css','img':'images'].each { epubdir,destdir ->
    ant.mkdir(dir:"${outDir}/OEBPS/${destdir}")
    ant.copy(todir:"${outDir}/OEBPS/${destdir}") {
        fileset(dir:"${dir}/input/${epubdir}") {
            include(name:"**/*")
        }
    }       
}

doMimetype()
doManifest()
doCoverPage()
doPageTemplate()
def contentXml = getContentsXML(files)
println contentXml
doToc(contentXml)
doContentOpf(contentXml)

ant.echo "${logMsgPrefix} Tidying up"
ant.delete {
    fileset(dir:"${dir}/input/img",includes:"html_*.*")
    fileset(dir:"${outDir}",includes:"**/*.epub")
}

ant.zip(destfile:"${outDir}/Book.epub"){
    fileset dir:"${outDir}", includes:"mimetype"
    fileset dir:"${outDir}", excludes:"mimetype" 
}

ant.echo "${logMsgPrefix} Complete"
