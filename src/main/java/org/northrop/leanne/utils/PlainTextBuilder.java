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

import java.util.*;
import java.io.Writer;
import java.io.IOException;

import org.eclipse.mylyn.wikitext.core.parser.Attributes;
import org.eclipse.mylyn.wikitext.core.parser.DocumentBuilder;
import org.eclipse.mylyn.wikitext.core.util.*;
import org.apache.commons.lang.StringEscapeUtils;

/**
 * Provides plain text output from marked-up input.
 *
 * @author Leanne Northrop
 * @since 1st December 2010, 18:59
 */
public class PlainTextBuilder extends DocumentBuilder {
	private int blockDepth = 0;
    private Writer writer;
    
    public PlainTextBuilder(Writer writer){
        this.writer = writer;
    }
    
    public void charactersUnescaped(String str) {}
   
	@Override
	public void acronym(String text, String definition) {
//		writer("ACRONYM:" + text + "," + definition);
	}

	@Override
	public void imageLink(Attributes linkAttributes, Attributes imageAttributes, String href, String imageUrl) {
	}
	
	@Override
	public void link(Attributes attributes, String hrefOrHashName, String text) {
//		write(text);
	}	
	
	@Override
	public void image(Attributes attributes, String url) {
	}	

	@Override
	public void beginBlock(BlockType type, Attributes attributes) {
		++blockDepth;
		write("\n");
		write("\n");		
        if (type == BlockType.TABLE) {
		} else if (type == BlockType.TABLE_ROW) {
		} else if (type == BlockType.TABLE_CELL_HEADER || type == BlockType.TABLE_CELL_NORMAL) {
		} else if (type == BlockType.BULLETED_LIST || type == BlockType.NUMERIC_LIST) { 
		} else if (type == BlockType.QUOTE) {
		} else {
			// create the titled panel effect if a title is specified
			if (attributes.getTitle() != null) {
				write(attributes.getTitle());
			}
		}		
	}

	@Override
	public void beginDocument() {
	}

	@Override
	public void beginHeading(int level, Attributes attributes) {
	}

	@Override
	public void beginSpan(SpanType type, Attributes attributes) {
	}

    @Override
    public void characters(String text) {
        write(text);
    }
    
	@Override
	public void endBlock() {
		--blockDepth;	
		write("\n");		
	}

	@Override
	public void endDocument() {
	}

	@Override
	public void endHeading() {
	}

	@Override
	public void endSpan() {
	}

	@Override
	public void entityReference(String entity) {
        try {
            if (entity.length() > 0) {
                if (entity.equals("dash")) {
                    write("-");
                } else {
                    String result = StringEscapeUtils.unescapeHtml("&" + entity + ";");
                    if (!result.equals("&;")) {
                        write(result);
                    }
                }
            }
        } catch (Exception e) {
            
        }
	}

	@Override
	public void lineBreak() {
		write(" ");
	}

	private void write(String str) {
	    try {
	        writer.append(str);
        } catch (IOException error) {
        }
	}
}