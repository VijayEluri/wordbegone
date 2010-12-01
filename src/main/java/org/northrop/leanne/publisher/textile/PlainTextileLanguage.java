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

package org.northrop.leanne.publisher.textile;

import org.eclipse.mylyn.wikitext.textile.core.TextileLanguage;
import java.util.*;
import org.eclipse.mylyn.wikitext.core.parser.markup.token.EntityReferenceReplacementToken;

/**
 * Site specific textile markup language. Supports marking up internal
 * links, video embedding and more.
 *
 * @author Leanne Northrop
 * @since 1st December 2010, 21:32
 */
public class PlainTextileLanguage extends TextileLanguage {

    public PlainTextileLanguage() {
    }

    @Override
    protected void addStandardTokens(PatternBasedSyntax tokenSyntax) {
        tokenSyntax.add(new EntityReferenceReplacementToken("(eh)", ""));
        tokenSyntax.add(new EntityReferenceReplacementToken("(eeh)", ""));        
        tokenSyntax.add(new EntityReferenceReplacementToken("*", ""));                
        tokenSyntax.add(new EntityReferenceReplacementToken("_", ""));                        
        tokenSyntax.add(new EntityReferenceReplacementToken("+", ""));            
        tokenSyntax.add(new EntityReferenceReplacementToken("^", ""));                    
        tokenSyntax.add(new EntityReferenceReplacementToken("~", "")); 
        tokenSyntax.add(new EntityReferenceReplacementToken("--", "dash"));                                    
        super.addStandardTokens(tokenSyntax);
    }
}
