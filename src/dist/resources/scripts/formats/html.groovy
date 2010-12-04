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

def logMsgPrefix = "HTML Formatting: "
def homeDir = home
def resourcesDir = "${home}/resources"  
def outDir = "${outputDir}/html"


// Helper Functions
def transform(xsltFile,input) {
    def factory = TransformerFactory.newInstance()
    def transformer = factory.newTransformer(new StreamSource(new FileReader(xsltFile)))
    def w = new StringWriter() 
    transformer.transform(new StreamSource(new StringReader(input)), new StreamResult(w))
    w.toString()
}

def ant = new AntBuilder()
ant.echo "${logMsgPrefix} Start"
ant.mkdir(dir:outputDir)
ant.mkdir(dir:outDir)
if (isdebug) {
    ant.mkdir(dir:"${outputDir}/debug")    
}

new File("${resourcesDir}/xml/").listFiles(
    {d, file-> file ==~ /.*?\.xml/ && file != 'book.xml'} as FilenameFilter
  ).toList().each { inFile ->
    ant.echo "${logMsgPrefix} Processing ${inFile.name}"

    def result = inFile.getText("utf8")
    ['html'].each {
        result = transform("${resourcesDir}/xsl/${it}.xsl", result)
        if (isdebug && it != 'html') {
            outFile = new File("${outDir}/${inFile.name.replaceAll('.htm(l)*','')}_${it}.txt")
            outFile.withWriter('utf8'){ w->
                w << result
            }        
        }
    }

    outFile = new File("${outDir}/${inFile.name.replaceAll('.xml','')}.html")
    outFile.withWriter('utf8'){ w->
      w << result 
    }
}
ant.echo "${logMsgPrefix} Copying HTML image files to ${resourcesDir}/img"
['png','jpg','jpeg'].each { ext ->
    ant.copy(todir:"${resourcesDir}/img") {
        mapper(type:"package", from: "*.${ext}", to:"html_*.${ext}")
        fileset(dir:"${inputDir}/html") {
            include(name:"**/*.${ext}")
        }
    }       
}

ant.echo "${logMsgPrefix} Copying HTML resource files"
['style/html/css':'css','img':'images'].each { epubdir,destdir ->
    ant.mkdir(dir:"${outDir}/${destdir}")
    ant.copy(todir:"${outDir}/${destdir}") {
        fileset(dir:"${resourcesDir}/${epubdir}") {
            include(name:"**/*")
        }
    }       
}

ant.echo "${logMsgPrefix} Tidying up"
ant.delete {
    fileset(dir:"${resourcesDir}/img",includes:"html_*.*")
}