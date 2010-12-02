<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns="http://www.idpf.org/2007/opf"
                version="2.0">
    <xsl:output indent="yes" method="xml"/>
    
    <xsl:template match="/">           
        <xsl:apply-templates select="book"/>
    </xsl:template>
    
    <xsl:template match="book">       
<package version="2.0" unique-identifier="PragmaticBook">
  <metadata xmlns:opf="http://www.idpf.org/2007/opf" xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:language>en</dc:language>
    <dc:title><xsl:value-of select="@title"/></dc:title>
    <dc:creator xmlns:dc="http://www.w3.org/1999/xhtml" opf:role="aut"><xsl:value-of select="@author"/></dc:creator>
    <dc:publisher>Northrop</dc:publisher>
    <dc:rights>Copyright © 2010 <xsl:value-of select="@author"/></dc:rights>
    <dc:identifier id="Northrop" opf:scheme="BookId">urn:uuid:hi</dc:identifier>
    <meta name="cover" content="cover-image"/>
  </metadata>
  <manifest>
    <item id="bookshelf-css" href="css/bookshelf.css" media-type="text/css"/>
    <item id="book_local-css" href="css/book_local.css" media-type="text/css"/>
    <item id="pt" href="page-template.xpgt" media-type="application/vnd.adobe-page-template+xml"/>
    <item id="cover" href="cover.xhtml" media-type="application/xhtml+xml"/>
    <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>      
    <xsl:apply-templates select="images/image"/>
    <xsl:apply-templates select="chapter"/>
  </manifest>
  <spine toc="ncx">
      <xsl:apply-templates select="chapter" mode="spine"/>
  </spine>
  <guide>
    <reference type="cover" title="Cover" href="cover.xhtml"/>
  </guide>    
</package>      
    </xsl:template>

    <xsl:template match="image">
        <xsl:variable name="imagefilename">images/<xsl:value-of select="@file"/></xsl:variable>
        <xsl:variable name="id">image<xsl:value-of select="@id"/></xsl:variable>        
    <item id="{$id}" href="{$imagefilename}" media-type="{@mimetype}"/>      
    </xsl:template>
    
    <xsl:template match="chapter">
        <xsl:variable name="id"><xsl:value-of select="replace(@file,'.html','')"/></xsl:variable>
        <item id="{$id}" href="{@file}" media-type="application/xhtml+xml" />
    </xsl:template>    
    
    <xsl:template match="chapter" mode="spine">
        <xsl:variable name="id"><xsl:value-of select="replace(@file,'.html','')"/></xsl:variable>
        <itemref idref="{$id}" />
    </xsl:template>     
</xsl:stylesheet>
