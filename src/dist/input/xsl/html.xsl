<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:t="java:org.northrop.leanne.utils.Textile">

    <xsl:output indent="yes" method="html" />

    <xsl:template match="/">
        <xsl:apply-templates select="//chapter"/>
    </xsl:template>

    <xsl:template match="chapter">
        <xsl:for-each select="//section">
            <xsl:variable name="filename" select="concat(@index,'.html')"/>
            <xsl:value-of select="$filename"/>
            <xsl:result-document href="{$filename}">
                <xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                ]]></xsl:text>
                <html>
                <head>
                  <title><xsl:value-of select="@title"/></title>
                </head>
                <body>
                    <xsl:apply-templates select="child::*"/>
                </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="paragraph">
            <xsl:variable name="v" select="."/>
            <xsl:variable name="t" select="t:toHtml($v)"/>
            <xsl:value-of select="$t" disable-output-escaping="yes"/>
    </xsl:template>

    <xsl:template match="table">
        <table>
            <caption><xsl:value-of select="@caption"/></caption>
            <xsl:apply-templates select="descendant::*"/>
        </table>
    </xsl:template>

    <xsl:template match="tr">
        <tr><xsl:apply-templates select="child::*"/></tr>
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
