<?xml version="1.0" encoding="MacRoman"?>

<!--
    Document   : html2book.xsl
    Created on : November 25, 2010, 12:07 PM
    Author     : Leanne Northrop
    Description: Transform Word doc exported to html and tidied with groovy
                 script to book xsl with textile marked up content.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:book="http://www.leanne.northrop.org/2010/Book"
                xmlns:bfn="http://www.leanne.northrop.org/2010/BookFunctions"
                exclude-result-prefixes="xs bfn"
                version="2.0">
    <xsl:output method="xml" indent="yes" encoding="utf8"/>

    <xsl:template match="/">
        <book>
            <xsl:apply-templates select="*"/>
        </book>
    </xsl:template>

    <xsl:template match="body">
        <xsl:variable name="title" select="bfn:getTitle(//html/head/title)"/>
        <xsl:variable name="index" select="number(replace($title,'[^\d]',''))"/>
        <xsl:variable name="longtitle" select="//html/body/div[1]/h1[1]"/>
        <xsl:element name="chapter">
            <xsl:attribute name="index" select="$index"/>
            <xsl:attribute name="title" select="$longtitle"/>
            <xsl:attribute name="pagetitle" select="$title"/>
            <xsl:attribute name="tocentry" select="$longtitle"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="div[contains(@class,'Section')]">
        <xsl:element name="section">
            <xsl:attribute name="index" select="number(replace(@class,'[^\d]',''))"/>
            <xsl:attribute name="title" select="h2[1]"/>
            <xsl:attribute name="pagetitle" select="h2[1]"/>
            <xsl:attribute name="tocentry" select="h2[1]"/>
                
            <xsl:for-each-group select="*" group-starting-with="h3">
                <xsl:variable name="title" select="bfn:getTitle(current-group()[1])"/>
                <xsl:choose>
                    <xsl:when test="string-length($title) &gt; 0">
                        <xsl:element name="subsection">
                            <xsl:attribute name="title" select="$title"/>
                            <xsl:attribute name="pagetitle" select="$title"/>
                            <xsl:attribute name="tocentry" select="$title"/>
                            <xsl:for-each-group select="current-group()" group-starting-with="h4">
                                <xsl:variable name="stitle" select="bfn:getTitle(current-group()[1])"/>
                                <xsl:choose>
                                    <xsl:when test="($title != $stitle) and string-length($stitle) &gt; 0">
                                        <xsl:element name="subsubsection">
                                            <xsl:attribute name="title" select="$stitle"/>
                                            <xsl:attribute name="pagetitle" select="$stitle"/>
                                            <xsl:attribute name="tocentry" select="$stitle"/>
                                            <xsl:apply-templates select="current-group()" mode="copy"/>
                                        </xsl:element>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="current-group()" mode="copy"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each-group>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each-group select="current-group()" group-starting-with="h4">
                            <xsl:variable name="stitle" select="bfn:getTitle(current-group()[1])"/>
                            <xsl:choose>
                                <xsl:when test="($title != $stitle) and string-length($stitle) &gt; 0">
                                    <xsl:element name="subsubsection">
                                        <xsl:attribute name="title" select="$stitle"/>
                                        <xsl:attribute name="pagetitle" select="$stitle"/>
                                        <xsl:attribute name="tocentry" select="$stitle"/>
                                        <xsl:apply-templates select="current-group()" mode="copy"/>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="current-group()" mode="copy"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each-group>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*">
         <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="head">
         <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()">
    </xsl:template>

    <xsl:template match="p" mode="copy">
        <xsl:choose>
            <xsl:when test="string-length(.) &gt; 0 ">
                <paragraph>
                    <xsl:copy-of select="text() | *"/>
                </paragraph>
            </xsl:when>
            <xsl:when test="img">
                <xsl:apply-templates select="img" mode="copy"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="img" mode="copy">
            <xsl:element name="image">
                <xsl:attribute name="width" select="@width"/>
                <xsl:attribute name="src" select="replace(@src, '/', '.')"/>                
                <xsl:attribute name="align" select="@align"/>                                
            </xsl:element>
    </xsl:template>

    <xsl:template match="ul|ol" mode="copy">
        <xsl:if test="string-length(.) &gt; 0 ">
            <xsl:element name="list">
                <xsl:attribute name="kind" select="local-name()"/>
                <xsl:apply-templates select="*" mode="copy"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="li|table" mode="copy">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="h1|h2|h3" mode="copy">
        <xsl:copy-of select="*"/>
    </xsl:template>

    <xsl:template match="text()" mode="copy">
    </xsl:template>

    <xsl:function name="bfn:getTitle" as="xs:string">
        <xsl:param name="str" as="xs:string"/>
        <xsl:value-of select="normalize-space(replace($str,'&#xA;','\\'))"/>
    </xsl:function>

</xsl:stylesheet>
