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

import org.eclipse.mylyn.wikitext.core.parser.builder.HtmlDocumentBuilder;
import org.eclipse.mylyn.wikitext.core.parser.MarkupParser;
import org.eclipse.mylyn.wikitext.textile.core.TextileLanguage;

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

        MarkupParser parser = new MarkupParser(new TextileLanguage());
        parser.setBuilder(builder);

        parser.parse(str);
        System.out.println("*" + sw.toString());
        return sw.toString();
    }

}