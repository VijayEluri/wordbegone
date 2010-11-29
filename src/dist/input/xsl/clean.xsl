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
        <xsl:variable name="content">
            <xsl:apply-templates select="*"/>
        </xsl:variable>
        <xsl:copy-of select="$content"/>
    </xsl:template>

    <xsl:template match="span">
        <xsl:choose>
            <xsl:when test=". = '&nbsp;'">
            </xsl:when>
            <xsl:when test="matches(@style,'background:')">
                <xsl:apply-templates select="text()[normalize-space(.)] | *"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="text()[normalize-space(.)] | *"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*">
        <xsl:choose>
            <xsl:when test="local-name() = 'img' or child::* or string-length(normalize-space(.)) &gt; 0">
                <xsl:copy>
                    <xsl:for-each select="@style">
                        <xsl:if test="contains(.,'background')">
                            <xsl:copy/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="@href|@class|@id|@width|@src|@align">
                        <xsl:copy/>
                    </xsl:for-each>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- default rule: ignore any of following -->
    <xsl:template match="meta|style|link" />

    <!-- override rule: copy any text node beneath description -->
    <xsl:template match="text()">
        <xsl:choose>
            <xsl:when test=". = '&nbsp;'">
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="isEmpty">
      <xsl:param name="nodes"/>
        <xsl:variable name="r">
          <xsl:call-template name="emptyCheck">
            <xsl:with-param name="nodes"
              select="$nodes"/>
            <xsl:with-param name="result"
              select="0"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$r &lt;= 0">
                <!--xsl:message>
                    *********<xsl:copy-of select="$nodes"/>
                </xsl:message-->
                <xsl:value-of select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="emptyCheck">
      <xsl:param name="nodes"/>
      <xsl:param name="result" select="0"/>

      <xsl:choose>
        <xsl:when test="$nodes">
          <xsl:variable name="length">
                <xsl:choose>
                    <xsl:when test="matches(., '^&nbsp;$')">
                        <xsl:value-of select="0"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="string-length(normalize-space(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
          </xsl:variable>
          <xsl:call-template name="emptyCheck">
            <xsl:with-param name="nodes"
              select="$nodes[position() > 1]"/>
            <xsl:with-param name="result"
              select="$result + $length"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="$result"/></xsl:otherwise>
      </xsl:choose>
    </xsl:template>


</xsl:stylesheet>
