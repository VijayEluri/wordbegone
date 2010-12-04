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

def logMsgPrefix = "Textile Formatting: "
def homeDir = home
def resourcesDir = "${home}/resources"  
def outDir = "${outputDir}/textile"

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
    ['textile'].each {
        result = transform("${resourcesDir}/xsl/${it}.xsl", result)
        if (isdebug && it != 'textile') {
            outFile = new File("${outDir}/${inFile.name.replaceAll('.htm(l)*','')}_${it}.txt")
            outFile.withWriter('utf8'){ w->
                w << result
            }        
        }
    }

    outFile = new File("${outDir}/${inFile.name.replaceAll('.xml','')}.txt")
    outFile.withWriter('utf8'){ w->
      w << result 
    }
}
