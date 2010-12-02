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
 * Script to pre-process each input HTML document present in the input/html
 * directory to produce intermediate XML file into input/xml directory.
 *
 * @author Leanne Northrop
 * @since 25th November 2010, 21:38
 */
 
import groovy.xml.MarkupBuilder
import groovy.xml.StreamingMarkupBuilder
import groovy.util.XmlNodePrinter
import groovy.util.slurpersupport.NodeChild
import javax.xml.transform.TransformerFactory
import javax.xml.transform.stream.StreamResult
import javax.xml.transform.stream.StreamSource
import org.apache.tools.ant.*

def dir = "${home}/input"

// Helper Functions
def transform(xsltFile,input) {
    def factory = TransformerFactory.newInstance()
    def transformer = factory.newTransformer(new StreamSource(new FileReader(xsltFile)))
    def w = new StringWriter() 
    transformer.transform(new StreamSource(new StringReader(input)), new StreamResult(w))
    w.toString()
}

def parser() {
    def parser=new org.cyberneko.html.parsers.SAXParser()
    parser.setFeature("http://cyberneko.org/html/features/balance-tags/document-fragment",true)
    parser.setFeature('http://xml.org/sax/features/namespaces', false)
    parser.setFeature('http://cyberneko.org/html/features/scanner/normalize-attrs',true)
    parser.setProperty('http://cyberneko.org/html/properties/names/elems','lower')
    parser.setFeature('http://cyberneko.org/html/features/scanner/fix-mswindows-refs',false)
    parser
}

def ant = new AntBuilder()
ant.mkdir(dir:"${home}/output")
if (isdebug) {
    ant.mkdir(dir:"${home}/output/debug")    
}

new File("${dir}/html/").listFiles(
    {d, file-> file ==~ /.*?\.htm/ } as FilenameFilter
  ).toList().each { inFile ->
    ant.echo "Processing ${inFile.name}"
    // Get Word HTML (exported in utf8 with Display only ticked)
    def text=inFile.getText("utf8")

    // Get Index Words
    def indexXML=new File("${dir}/xtra/index-entries.xml").getText("utf8")
    def xml=new XmlSlurper().parseText(indexXML)          
    def list = xml.depthFirst().grep{ it.name() == 'indexentry' }.collect{ it.text() }.unique()
    def indexPattern = '\\b(' + list.join('|') + ')\\b'

    // Beautify the HTML
    def parser=parser()
    def html=new XmlSlurper(parser).parseText(text)          
    def writer = new StringWriter()
    writer << new StreamingMarkupBuilder().bind {
            mkp.yield html
    }

    // Process HTML into Textile Marked up Content
    def prettyHtml = new XmlParser().parseText(writer.toString())
    def outDir = "${home}/output"
    def outFile = new File("${dir}/newxml/${inFile.name.replaceAll('.htm(l)*','')}.xml")

    def result = writer.toString()
    ['clean', 'bookmarkup','html2book','removeempty'].each {
        result = transform("${dir}/xsl/${it}.xsl", result)
        if (isdebug && it != 'removeempty') {
            outFile = new File("${outDir}/debug/${inFile.name.replaceAll('.htm(l)*','')}_${it}.xml")
            outFile.withWriter('utf8'){ w->
                w << result
            }        
        }
    }

    outFile = new File("${dir}/xml/${inFile.name.replaceAll('.htm(l)*','')}.xml")
    outFile.withWriter('utf8'){ w->
      w << result
    }
}
