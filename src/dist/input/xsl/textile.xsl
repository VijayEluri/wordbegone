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

    <xsl:template match="img|a" mode="textile">
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:copy/>
            </xsl:for-each>
            <xsl:apply-templates mode="textile"/>
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
        <xsl:apply-templates mode="textile"/>
    </xsl:template>

    <xsl:template match="p[contains(@style,'background')]">
        <p>(eh)<xsl:apply-templates mode="textile"/>(eeh)</p>
    </xsl:template>

    <xsl:template match="p[not(contains(@style,'background'))]">
        <p><xsl:apply-templates mode="textile"/></p>
    </xsl:template>

    <xsl:template match="li[contains(@style,'background')]">
        <li>(eh)<xsl:apply-templates mode="textile"/>(eeh)</li>
    </xsl:template>

    <xsl:template match="li[not(contains(@style,'background'))]">
        <li><xsl:apply-templates mode="textile"/></li>
    </xsl:template>

    <xsl:template match="td[contains(@style,'background')]">
        <td>(eh)<xsl:apply-templates mode="textile"/>(eeh)</td>
    </xsl:template>

    <xsl:template match="td[not(contains(@style,'background'))]">
        <td><xsl:apply-templates mode="textile"/></td>
    </xsl:template>

    <xsl:template match="p|li|td">
        <xsl:if test="child::* or string-length(normalize-space(.)) &gt; 0">
            <xsl:copy>
                <xsl:for-each select="@*">
                    <xsl:copy/>
                </xsl:for-each>
                <xsl:apply-templates mode="textile"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="b" mode="textile"><xsl:if test="child::* or string-length(normalize-space(.)) &gt; 0">*<xsl:apply-templates mode="textile"/>*</xsl:if></xsl:template>

    <xsl:template match="i" mode="textile"><xsl:if test="child::* or string-length(normalize-space(.)) &gt; 0">_<xsl:apply-templates mode="textile"/>_</xsl:if></xsl:template>

    <xsl:template match="u" mode="textile"><xsl:if test="child::* or string-length(normalize-space(.)) &gt; 0">+<xsl:apply-templates mode="textile"/>+</xsl:if></xsl:template>

    <xsl:template match="sup" mode="textile">^<xsl:apply-templates mode="textile"/>^</xsl:template>

    <xsl:template match="sub" mode="textile">~<xsl:apply-templates mode="textile"/>~</xsl:template>

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

    <xsl:template match="text()" mode="textile">
        <xsl:call-template name="normalize-text">
            <xsl:with-param name="str" select="replace(.,'[*_+~^]','')"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="text()" mode="clean">
        <xsl:variable name="c0" select="replace(., '(\p{L})_+(&#xAF;|&#x2C9;|&#x0304;)_+(\p{L})', '$1$2$3')"/>
        <xsl:variable name="c1" select="replace($c0, '(\p{L})([_*]+)(\p{L})', '$1$3')"/>
        <xsl:variable name="c2" select="replace($c1, '__', '_ _')"/>
        <xsl:variable name="c3" select="replace($c2, '_(\p{P})_', '$1')"/>
        <xsl:variable name="c4" select="replace($c3, '\*_([\p{L}\s]*?)\*', '*_$1_*')"/>
        <xsl:variable name="c5" select="replace($c4, '\s+:', ':')"/>
        <xsl:variable name="c6" select="replace($c5, ':_', ':')"/>
        <xsl:variable name="c7" select="replace($c6, '\(eh\)\(eeh\)', '')"/>
        <xsl:variable name="c8" select="replace($c7, '\*\[(\d+)\]\*', '[$1]')"/>
        <xsl:variable name="c9" select="replace($c8, '&quot;_([\p{L}\s]*?)&quot;_', '&quot;_$1_&quot;')"/>
        <xsl:copy-of select="$c9"/>
    </xsl:template>

    <xsl:template name="normalize-text">
        <xsl:param name="str"/>
        <xsl:variable name="q"><xsl:text>'</xsl:text></xsl:variable>
        <xsl:variable name="v1" select="replace(., '(&#x2018;|&#x2019;|&#x201A;|&#x201B;|&#xC2B4;|&#xCACB;|&#xCABB;|&#xCABC;|&#xCABD;|`)', $q)"/>
        <xsl:variable name="v2" select="replace($v1, '(&#x201C;|&#x2EE;|&#x201D;|&#x201E;|&#x201F;)', '&#x22;')"/>
        <xsl:variable name="v5" select="replace($v2, '(&#x2011;|&#x2012;|&#x2013;|&#x2014;)', '--')"/>
        <xsl:copy-of select="$v5"/>
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
