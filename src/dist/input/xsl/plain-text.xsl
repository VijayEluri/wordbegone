<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>
<!--
    todo: tables
    todo: pictures
    todo: glossary
    todo: quotations
    todo: tidy footnotes
    todo: bookpage
    todo: chapterpage
    todo: table contents
    todo: fix verses
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:latex="http://www.leanne.northrop.org/xslt"
                xmlns:t="java:org.northrop.leanne.utils.Textile"
                exclude-result-prefixes="xs latex">

    <xsl:output method="text"/>

    <xsl:variable name="apos">&apos;</xsl:variable>

    <xsl:variable name="indexNodes">
        <xsl:apply-templates select="//paragraph" mode="index"/>
        <xsl:apply-templates select="//verse/@title" mode="index"/>
    </xsl:variable>

    <xsl:variable name="footnoteNodes">
        <xsl:apply-templates select="//paragraph" mode="footnote"/>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="//chapter"/>
        <xsl:apply-templates select="//appendix"/>
    </xsl:template>

    <xsl:template match="chapter">
Chapter <xsl:value-of select="@index"/>.<xsl:text>&nbsp;</xsl:text><xsl:value-of select="@title"/>
-----------------------------------------------------------------------------
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="appendix">
Appendix <xsl:value-of select="@index"/>.<xsl:text>&nbsp;</xsl:text><xsl:value-of select="@title"/>
-----------------------------------------------------------------------------        
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="section">
<xsl:text>&#xA;</xsl:text>        
Section <xsl:value-of select="parent::chapter/@index"/>.<xsl:value-of select="@index"/><xsl:text>&nbsp;</xsl:text><xsl:value-of select="@title"/>
<xsl:text>&#xA;</xsl:text>
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="subsection">
<xsl:text>&#xA;</xsl:text>         
<xsl:text>&#xA;</xsl:text>        
<xsl:value-of select="ancestor::chapter/@index"/>.<xsl:value-of select="parent::section/@index"/>.<xsl:value-of select="position()"/><xsl:text>&nbsp;</xsl:text><xsl:value-of select="@title"/>
<xsl:text>&#xA;</xsl:text>        
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="subsubsection">
<xsl:text>&#xA;</xsl:text>         
<xsl:text>&#xA;</xsl:text>        
<xsl:value-of select="@title"/>
<xsl:text>&#xA;</xsl:text>        
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::section[position() eq 1 and @index eq '1']]">
<xsl:text>  </xsl:text><xsl:value-of select="t:toPlainText(.)"/>        
    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::section[position() eq 1 and @index gt '1']]">
<xsl:value-of select="t:toPlainText(.)"/>
    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::subsection[position() eq 1]]">
<xsl:value-of select="t:toPlainText(.)"/>
    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::subsubsection[position() eq 1]]">
<xsl:value-of select="t:toPlainText(.)"/>
    </xsl:template>

    <xsl:template match="paragraph[position() gt 1 or (position() eq 1 and (parent::appendix or parent::chapter))]">
<xsl:value-of select="t:toPlainText(.)"/>
    </xsl:template>

    <xsl:template match="subparagraph">
<xsl:value-of select="t:toPlainText(.)"/>
    </xsl:template>

    <xsl:template match="image">
    </xsl:template>

    <xsl:template match="table">
    </xsl:template>

    <xsl:template match="tr">
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="td">
        <xsl:variable name="v" select="t:toPlainText(.)"/>
        <xsl:value-of select="$v"/>
    </xsl:template>

    <xsl:template match="th">
        <xsl:variable name="v" select="t:toPlainText(.)"/>
        <xsl:value-of select="$v"/>
    </xsl:template>

    <xsl:template match="paragraph" mode="index">
<xsl:value-of select="t:toPlainText(.)"/>
    </xsl:template>

    <xsl:template match="paragraph" mode="footnote">
<xsl:value-of select="t:toPlainText(.)"/>
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:choose>
            <xsl:when test="@kind eq 'label'">
                <xsl:apply-templates select="child::*"/>
            </xsl:when>
            <xsl:when test="@kind eq 'ul'">
                <xsl:apply-templates select="child::*"/>
            </xsl:when>            
            <xsl:otherwise>
                <xsl:apply-templates select="child::*"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="item">
<xsl:value-of select="t:toPlainText(.)"/>
    </xsl:template>

    <xsl:template match="verse">
        <xsl:apply-templates select="stanza" mode="verse"/>
<xsl:if test="@author"><xsl:value-of select="@author"/></xsl:if>
    </xsl:template>

    <xsl:template match="stanza">
        <xsl:apply-templates select="." mode="verse"/>
<xsl:if test="@author"><xsl:value-of select="@author"/></xsl:if>
    </xsl:template>

    <xsl:template match="stanza" mode="verse">
        <xsl:variable name="stanzaindex" select="@index"/>
        <xsl:for-each select="line">
            <xsl:choose>
                <xsl:when test="($stanzaindex cast as xs:integer eq 1) and (position() eq 1)">
                    <xsl:variable name="initial" select="substring(., 1, 1)"/>
                    <xsl:variable name="remaining" select="substring(., 2)"/>
    <xsl:value-of select="$initial"/><xsl:value-of select="$remaining"/>
                </xsl:when>
                <xsl:otherwise>
    <xsl:value-of select="t:toPlainText(.)"/>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="not(position()=last())">
<xsl:text>&#xA;</xsl:text>
            </xsl:if>
            <xsl:if test="position()=last()">
<xsl:text>&#xA;&#xA;</xsl:text>            
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
