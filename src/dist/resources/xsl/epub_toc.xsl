<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:opf="http://www.idpf.org/2007/opf" 
                xmlns:dc="http://purl.org/dc/elements/1.1/" 
                xmlns="http://www.daisy.org/z3986/2005/ncx/"
                version="2.0">
                
    <xsl:output indent="yes" method="xml"/>
    
    <xsl:template match="/">           
        <xsl:apply-templates select="book"/>
    </xsl:template>
    
    <xsl:template match="book">       
<ncx version="2005-1">
  <head>
    <meta name="dtb:uid" content="urn:uuid:hi"/>
    <meta name="dtb:depth" content="1"/>
    <meta name="dtb:totalPageCount" content="0"/>
    <meta name="dtb:maxPageNumber" content="0"/>
  </head>
  <docTitle>
    <text><xsl:value-of select="@title"/></text>
  </docTitle>
  <navMap><xsl:apply-templates select="*"/></navMap>
</ncx>      
    </xsl:template>

    <xsl:template match="chapter">
        <xsl:variable name="idNumber"><xsl:value-of select="@index"/></xsl:variable>
        <xsl:variable name="idValue">navPoint-<xsl:value-of select="@index"/></xsl:variable>        
    <navPoint id="{$idValue}" playOrder="{$idNumber}">
       <navLabel>
          <text><xsl:value-of select="@index"/>. <xsl:value-of select="@title"/></text>
       </navLabel>
       <content src="{@file}"/>
    </navPoint>        
    </xsl:template>
    
    <xsl:template match="*"></xsl:template>
</xsl:stylesheet>