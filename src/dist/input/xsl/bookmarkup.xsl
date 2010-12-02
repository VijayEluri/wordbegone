<?xml version="1.0" encoding="MacRoman"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<!--
    Document   : html2book.xsl
    Created on : November 25, 2010, 12:07 PM
    Author     : Leanne Northrop
    Description: Transform Word doc exported to html and tidied with groovy
                 script to book xsl with textile marked up content.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <xsl:output method="xml"/>

    <xsl:template match="/">
        <xsl:variable name="content">
            <xsl:apply-templates select="*"/>
        </xsl:variable>
        <xsl:variable name="content2">
            <xsl:apply-templates select="$content" mode="clean"/>
        </xsl:variable>        
        <xsl:copy-of select="$content2"/>
    </xsl:template>

    <xsl:template match="h1|h2|h3|h4|h5|h6|h7">
        <xsl:if test="child::* or string-length(normalize-space(.)) &gt; 0">
            <xsl:copy>
                <xsl:for-each select="@*">
                    <xsl:copy/>
                </xsl:for-each>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="b|u|i|sup|sub">
        <xsl:apply-templates mode="book"/>
    </xsl:template>

    
    <xsl:template match="p[contains(@style,'background')]">
        <xsl:choose>
            <xsl:when test="child::img">
                <xsl:apply-templates mode="book"/>
            </xsl:when>             
            <xsl:when test="contains(@class, 'Verse')">
                <xsl:variable name="me" select="."/>
                <xsl:for-each-group select="parent::*/p" group-adjacent="boolean(self::p[contains(@class, 'Verse')])">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <xsl:if test="current-group()[1] = $me">
                                <xsl:element name="ol">
                                    <xsl:attribute name="class" select="'stanza essential'"/>
                                    <xsl:for-each select="current-group()">
                                        <li><xsl:apply-templates mode="book"/></li>                                
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each-group>            
            </xsl:when>            
            <xsl:when test="child::* or string-length(normalize-space(.)) &gt; 0">
                <p><essential><xsl:apply-templates mode="book"/></essential></p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
        
    <xsl:template match="p[not(contains(@style,'background'))]">
        <xsl:choose>
            <xsl:when test="child::img">
                <xsl:apply-templates mode="book"/>
            </xsl:when>              
            <xsl:when test="contains(@class, 'Verse')">
                <xsl:variable name="me" select="."/>
                <xsl:for-each-group select="parent::*/p" group-adjacent="boolean(self::p[contains(@class, 'Verse')])">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <xsl:if test="current-group()[1] = $me">
                                <xsl:element name="ol">
                                    <xsl:attribute name="class" select="'stanza'"/>
                                    <xsl:for-each select="current-group()">
                                        <li><xsl:apply-templates mode="book"/></li>                                
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:when>            
            <xsl:when test="child::* or string-length(normalize-space(.)) &gt; 0">
                <p><xsl:apply-templates mode="book"/></p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="p[contains(@style,'background')]" mode="fn">
        <xsl:if test="child::* or string-length(normalize-space(.)) &gt; 0"><essential><xsl:apply-templates mode="fn"/></essential></xsl:if>
    </xsl:template>

    <xsl:template match="p[not(contains(@style,'background'))]" mode="fn">
        <xsl:apply-templates mode="fn"/>
    </xsl:template>    
        
    <xsl:template match="p|td">
        <xsl:if test="child::* or string-length(normalize-space(.)) &gt; 0">
            <xsl:copy>
                <xsl:for-each select="@*">
                    <xsl:copy/>
                </xsl:for-each>
                <xsl:apply-templates mode="book"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="img|a" mode="book">
        <xsl:text> </xsl:text>        
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:copy/>
            </xsl:for-each>
            <xsl:apply-templates mode="book"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="img|a" mode="clean">
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:copy/>
            </xsl:for-each>
            <xsl:apply-templates mode="clean"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="a" mode="fn">        
    </xsl:template>
    
    <xsl:template match="ul|ol">
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:copy/>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="li[contains(@style,'background')]">
        <li><essential><xsl:apply-templates mode="book"/></essential></li>
    </xsl:template>

    <xsl:template match="li[not(contains(@style,'background'))]">
        <li><xsl:apply-templates mode="book"/></li>
    </xsl:template>

    <xsl:template match="td[contains(@style,'background')]">
        <td><essential><xsl:apply-templates mode="book"/></essential></td>
    </xsl:template>

    <xsl:template match="td[not(contains(@style,'background'))]">
        <td><xsl:apply-templates mode="book"/></td>
    </xsl:template>

    <xsl:template match="b" mode="book"><xsl:if test="child::* or string-length(normalize-space(.)) &gt; 0"><xsl:text> </xsl:text><bold><xsl:apply-templates mode="book"/></bold><xsl:text> </xsl:text></xsl:if></xsl:template>

    <xsl:template match="i" mode="book"><xsl:if test="child::* or string-length(normalize-space(.)) &gt; 0"><xsl:text> </xsl:text><italic><xsl:apply-templates mode="book"/></italic><xsl:text> </xsl:text></xsl:if></xsl:template>

    <xsl:template match="u" mode="book"><xsl:if test="child::* or string-length(normalize-space(.)) &gt; 0"><xsl:text> </xsl:text><underline><xsl:apply-templates mode="book"/></underline><xsl:text> </xsl:text></xsl:if></xsl:template>

    <xsl:template match="sup" mode="book"><xsl:text> </xsl:text><superscript><xsl:apply-templates mode="book"/></superscript><xsl:text> </xsl:text></xsl:template>

    <xsl:template match="sub" mode="book"><xsl:text> </xsl:text><subscript><xsl:apply-templates mode="book"/></subscript><xsl:text> </xsl:text></xsl:template>

    <xsl:template match="div[contains(@id,'ftn')]">
        <xsl:element name="p">
            <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
            <xsl:apply-templates select="*" mode="fn"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:copy/>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:call-template name="normalize-text">
            <xsl:with-param name="str" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="text()" mode="book">
        <xsl:call-template name="normalize-text">
            <xsl:with-param name="str" select="replace(.,'[*_+~^]','')"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="text()" mode="fn">
        <xsl:call-template name="normalize-text">
            <xsl:with-param name="str" select="replace(.,'[*_+~^]','')"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="text()" mode="clean">
        <xsl:variable name="c1" select="replace(., '\s+:', ':')"/>
        <xsl:copy-of select="$c1"/>
    </xsl:template>

    <xsl:template name="normalize-text">
        <xsl:param name="str"/>
        <xsl:variable name="q"><xsl:text>'</xsl:text></xsl:variable>
        <xsl:variable name="v1" select="replace(., '(&#x2018;|&#x2019;|&#x201A;|&#x201B;|&#xC2B4;|&#xCACB;|&#xCABB;|&#xCABC;|&#xCABD;|`)', $q)"/>
        <xsl:variable name="v2" select="replace($v1, '(&#x201C;|&#x2EE;|&#x201D;|&#x201E;|&#x201F;)', '&#x22;')"/>
        <xsl:variable name="v5" select="replace($v2, '(&#x2011;|&#x2012;|&#x2013;|&#x2014;)', '&#8212;')"/>
        <xsl:variable name="v6" select="replace($v5, '&#x00A0;', '')"/>     
        <xsl:variable name="v7" select="replace($v6, '--', '&#8212;')"/>             
        <xsl:copy-of select="normalize-space($v7)"/>
    </xsl:template>

    <xsl:template match="*" mode="clean">
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:copy/>
            </xsl:for-each>
            <xsl:apply-templates mode="clean"/>
        </xsl:copy>
    </xsl:template>

    
</xsl:stylesheet>
