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
 
package org.northrop.leanne.utils;

import org.eclipse.mylyn.wikitext.core.parser.builder.*;
import org.eclipse.mylyn.wikitext.core.parser.MarkupParser;
import org.eclipse.mylyn.wikitext.textile.core.TextileLanguage;
import org.northrop.leanne.publisher.textile.*;

import java.util.*;
import java.io.*;

/**
 * Provides static wrapper function to be used as an XSLT extended function
 *
 * @author Leanne Northrop
 * @since June 2009
 */
public class Textile {

    /**
     * Converts a string containing Textile markup to HTML
     *
     * @param str String containing Textile markup.
     * @returns HTML
     */
    public static String toHtml(String str) {
        StringWriter sw = new StringWriter();

        HtmlDocumentBuilder builder = new HtmlDocumentBuilder(sw);
        builder.setEmitAsDocument(false);
        builder.setUseInlineStyles(false);
        builder.setSuppressBuiltInStyles(true);
        builder.setXhtmlStrict(true);
        
        MarkupParser parser = new MarkupParser(new BookTextileLanguage());
        parser.setBuilder(builder);

        parser.parse(str,false);

		parser.setBuilder(null);
		
        return sw.toString();
    }
    
    /**
	 * parse the given markup content and produce the result as an DITA document.
	 * 
	 * @param markupContent
	 *            the content to parse
	 * 
	 * @return the DITA document text.
	 */
	public static String toDita(String markupContent) {
		StringWriter out = new StringWriter();

        MarkupParser parser = new MarkupParser(new TextileLanguage());
        DitaBookMapDocumentBuilder builder = new DitaBookMapDocumentBuilder(out);
		parser.setBuilder(builder);
		try { builder.close(); } catch(Exception ignore){}

		parser.parse(markupContent,false);

		parser.setBuilder(null);

		return out.toString();
	}
	
	/**
	 * parse the given markup content and produce the result as an DocBook document.
	 * 
	 * @param markupContent
	 *            the content to parse
	 * 
	 * @return the DocBook document text.
	 */
	public static String toDocBook(String markupContent) {
		StringWriter out = new StringWriter();

        MarkupParser parser = new MarkupParser(new TextileLanguage());
        DocBookDocumentBuilder builder = new DocBookDocumentBuilder(out);
		parser.setBuilder(builder);

		parser.parse(markupContent,false);

		parser.setBuilder(null);

		return out.toString();
	}
	
	/**
	 * parse the given markup content and produce the result as an DocBook document.
	 * 
	 * @param markupContent
	 *            the content to parse
	 * 
	 * @return the DocBook document text.
	 */
	public static String toPlainText(String markupContent) {
		StringWriter out = new StringWriter();

        TextileLanguage l = new PlainTextileLanguage();

        MarkupParser parser = new MarkupParser(l);
        PlainTextBuilder builder = new PlainTextBuilder(out);
		parser.setBuilder(builder);
        l.setBlocksOnly(false);
		parser.parse(markupContent,false);

		//parser.setBuilder(null);

		return out.toString();
	}	

}