<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:t="java:org.northrop.leanne.utils.Textile"
                xmlns="http://www.w3.org/1999/xhtml"
                version="2.0">
                
    <xsl:output indent="yes" method="xml"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//chapter"/>
    </xsl:template>
    
    <xsl:template match="chapter">
        <xsl:text disable-output-escaping="yes">&#xA;<![CDATA[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml11.dtd">]]>&#xA;</xsl:text>
        <html>
            <head>
                <title>
                    <xsl:value-of select="@title"/>
                </title>
                <link rel="stylesheet" type="text/css" href="css/bookshelf.css"/>
                <link rel="stylesheet" type="text/css" href="css/book_local.css"/>
                <link rel="stylesheet" type="application/vnd.adobe-page-template+xml" href="page-template.xpgt"/>
            </head>
            <body>
                <xsl:apply-templates select="child::*"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="paragraph">
        <xsl:variable name="v" select="."/>
        <xsl:variable name="t" select="t:toHtml($v)"/>
        <xsl:value-of select="$t" disable-output-escaping="yes"/>
    </xsl:template>
    
    <xsl:template match="table">
        <table>
            <caption>
                <xsl:value-of select="@caption"/>
            </caption>
            <xsl:apply-templates select="descendant::*"/>
        </table>
    </xsl:template>
    
    <xsl:template match="tr">
        <tr>
            <xsl:apply-templates select="child::*"/>
        </tr>
    </xsl:template>
    
    <xsl:template match="td">
        <td>
            <xsl:variable name="v" select="."/>
            <xsl:value-of select="t:toHtml($v)"/>
        </td>
    </xsl:template>
    
    <xsl:template match="th">
        <th>
            <xsl:variable name="v" select="."/>
            <xsl:value-of select="t:toHtml($v)"/>
        </th>
    </xsl:template>
</xsl:stylesheet>
