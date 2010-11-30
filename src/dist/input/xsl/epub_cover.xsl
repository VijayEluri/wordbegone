<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns="http://www.w3.org/1999/xhtml" 
                version="2.0">
                
    <xsl:output indent="yes" method="xml"/>
    
    <xsl:template match="/">           
        <xsl:text disable-output-escaping="yes">&#xA;<![CDATA[<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
	  "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">]]>&#xA;</xsl:text>
        <html>
            <head>
                <title>Title Page</title>
                    <link rel="stylesheet" href="css/bookshelf.css" type="text/css" />
                    <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8" />
            </head>
            <body>
                <xsl:apply-templates select="book"/>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="book">       
        <div>
        <xsl:apply-templates select="*"/>
        </div>        
    </xsl:template>

    <xsl:template match="title">
        <h1><xsl:value-of select="."/></h1>
    </xsl:template>
    
</xsl:stylesheet>
