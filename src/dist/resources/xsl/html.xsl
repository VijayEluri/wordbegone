<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output indent="yes" method="xml" />

    <xsl:template match="/">
        <xsl:apply-templates select="//chapter"/>
    </xsl:template>
    
    <!--xsl:template match="chapter">
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
    </xsl:template-->

    <xsl:template match="section">
        <h2><xsl:value-of select="@title"/></h2>
        <xsl:apply-templates select="child::*"/>        
    </xsl:template>
    
    <xsl:template match="subsection">
        <h3><xsl:value-of select="@title"/></h3>
        <xsl:apply-templates select="child::*"/>        
    </xsl:template>
        
    <xsl:template match="subsubsection">
        <h4><xsl:value-of select="@title"/></h4>        
        <xsl:apply-templates select="child::*"/>
    </xsl:template>
            
    <xsl:template match="chapter">
        <xsl:text disable-output-escaping="yes">&#xA;<![CDATA[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml11.dtd">]]>&#xA;</xsl:text>
        <html>
            <head>
                <title>
                    <xsl:value-of select="@title"/>
                </title>
                <link rel="stylesheet" type="text/css" href="css/html.css"/>
            </head>
            <body>
                <h1><xsl:value-of select="@title"/></h1>
                <xsl:apply-templates select="child::*"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="paragraph">
        <p><xsl:apply-templates select="text() | child::*"/></p>
    </xsl:template>
    
    <xsl:template match="bold">
        <b><xsl:apply-templates select="text() | child::*"/></b>
    </xsl:template>
        
    <xsl:template match="italic">
        <i><xsl:apply-templates select="text() | child::*"/></i>
    </xsl:template>
    
    <xsl:template match="underline">
        <u><xsl:apply-templates select="text() | child::*"/></u>
    </xsl:template>    
            
    <xsl:template match="superscript">
        <sup><xsl:apply-templates select="text() | child::*"/></sup>
    </xsl:template>   
    
    <xsl:template match="subscript">
        <sub><xsl:apply-templates select="text() | child::*"/></sub>
    </xsl:template> 
    
    <xsl:template match="list[@kind = 'ol']">
        <ol><xsl:apply-templates select="text() | child::*"/></ol>
    </xsl:template> 
          
    <xsl:template match="list[@kind = 'ul']">
        <ul><xsl:apply-templates select="text() | child::*"/></ul>
    </xsl:template> 
              
    <xsl:template match="item">
        <li><xsl:apply-templates select="text() | child::*"/></li>
    </xsl:template> 
    
    <xsl:template match="essential">
        <span class="essential"><xsl:apply-templates select="text() | child::*"/></span>
    </xsl:template>     
                        
    <xsl:template match="image">
        <xsl:element name="img">
            <xsl:attribute name="src">images/html_<xsl:value-of select="@src"/></xsl:attribute>
            <xsl:attribute name="width"><xsl:value-of select="@with"/></xsl:attribute>            
        </xsl:element>
    </xsl:template>    

    <xsl:template match="footnotes">
        <div>
            <ol>
            <xsl:apply-templates select="text() | child::*"/>
            </ol>            
        </div>
    </xsl:template> 
    
    <xsl:template match="footnote">
        <li>
            <xsl:element name="a">
                <xsl:attribute name="name">ftn_<xsl:value-of select="@id"/></xsl:attribute>
                <xsl:apply-templates select="text() | child::*"/>
            </xsl:element>
        </li>
    </xsl:template> 

    <xsl:template match="verse">
        <xsl:apply-templates select="*"/>
    </xsl:template> 
        
    <xsl:template match="stanza">
        <div><xsl:text></xsl:text><xsl:apply-templates select="text() | child::line"/></div>
    </xsl:template> 
    
    <xsl:template match="line">        
        <xsl:apply-templates select="text() | child::*"/><br/>
    </xsl:template>         
            
    <xsl:template match="text()">
        <xsl:analyze-string select="." regex="\[(\d+)\]">
            <xsl:matching-substring>
                <xsl:element name="a">
                    <xsl:attribute name="href">#ftn_<xsl:value-of select="regex-group(1)"/></xsl:attribute>
                    <sup><xsl:value-of select="regex-group(1)"/></sup>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring><xsl:copy-of select="."/></xsl:non-matching-substring>
        </xsl:analyze-string>        
    </xsl:template>
</xsl:stylesheet>
