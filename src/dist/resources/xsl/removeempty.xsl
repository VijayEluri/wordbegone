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
    <xsl:output method="xml" encoding="utf8"/>

    <xsl:template match="/">
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:choose>
            <xsl:when test="local-name() = 'image'">
                <xsl:copy-of select="."/>
            </xsl:when>                           
            <xsl:when test="string-length(.) = 0 and not(child::*)">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:for-each select="@*">
                        <xsl:copy/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- override rule: copy any text node beneath description -->
    <xsl:template match="text()">
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
