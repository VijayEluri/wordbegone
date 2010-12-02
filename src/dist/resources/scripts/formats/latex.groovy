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
 * Script to produce latex document.
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

def logMsgPrefix = "Latex Formatting: "
def dir = "${home}"
def ant = new AntBuilder()
ant.mkdir(dir:"${home}/output")
if (isdebug) {
    ant.mkdir(dir:"${home}/output/debug")    
}

// Helper Functions
def transform(xsltFile,input) {
    def factory = TransformerFactory.newInstance()
    def transformer = factory.newTransformer(new StreamSource(new FileReader(xsltFile)))
    def w = new StringWriter() 
    transformer.transform(new StreamSource(new StringReader(input)), new StreamResult(w))
    w.toString()
}

ant.echo "${logMsgPrefix} Start"
ant.echo "${logMsgPrefix} Copying HTML image files to ${dir}/input/img"
['png','jpg','jpeg'].each { ext ->
    ant.copy(todir:"${dir}/input/img") {
        mapper(type:"package", from: "*.${ext}", to:"*.${ext}")
        fileset(dir:"${dir}/input/html") {
            include(name:"**/*.${ext}")
        }
    }       
}

def chaps = []
def append = []
def outDir = "${dir}/output/latex"
ant.mkdir(dir:outDir)
ant.echo "${logMsgPrefix} Generating latex files to ${outDir}..."
new File("${dir}/input/xml/").listFiles(
    {d, file-> file ==~ /.*?\.xml/ && file != 'book.xml'} as FilenameFilter
  ).toList().each { inFile ->
    ant.echo "${logMsgPrefix} Processing ${inFile.name}"

    def result = inFile.getText("utf8")
    ['latex2'].each {
        result = transform("${dir}/input/xsl/${it}.xsl", result)
        if (isdebug && it != 'latex2') {
            outFile = new File("${outDir}/${inFile.name.replaceAll('.htm(l)*','')}_${it}.html")
            outFile.withWriter('utf8'){ w->
                w << result
            }        
        }
    }

    outFile = new File("${outDir}/${inFile.name.replaceAll('.xml','')}.tex")
    outFile.withWriter('utf8'){ w->
      w << result 
    }
    
    if (inFile.name ==~ /appendix\d+.xml/) {
        append += inFile.name[0..-5]        
    } else {
        chaps += inFile.name[0..-5]
    }
}

def xmlWriter = new StringWriter()
def builder = new groovy.xml.MarkupBuilder(xmlWriter)

builder.book {
    chapters {
        chaps.each { li(it) }
    }
    appendices {
        append.each { li(it) }
    }
}

def bookXMLStr = xmlWriter.toString()

if (isdebug) {
    ant.echo "${logMsgPrefix} Generating debug files to ${dir}/output/debug/book.xml"
    new File("${dir}/output/debug/book.xml").withWriter('utf8'){ w->
      w << bookXMLStr 
  }    
}

def result = transform("${dir}/input/xsl/latex.xsl", bookXMLStr)
new File("${outDir}/book.tex").withWriter('utf8'){ w->
      w << result 
}

ant.echo "${logMsgPrefix} Copying latex resource files"
['xtra','img','sty'].each { latexdir ->
    ant.copy(todir:"${outDir}") {
        fileset(dir:"${dir}/input/${latexdir}") {
            include(name:"**/*")
        }
    }       
}

ant.echo "${logMsgPrefix} Tidying up"
ant.delete {
    fileset(dir:"${dir}/input/img",includes:"module*.*")
}

ant.echo "${logMsgPrefix} Complete"