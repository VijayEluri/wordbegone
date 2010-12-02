<?xml version="1.0" encoding="UTF-8" ?>

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
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

    <xsl:output method="text"/>

    <xsl:variable name="apos">&apos;</xsl:variable>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//chapter"/>
        <xsl:apply-templates select="//appendix"/>
        <!--doc>
            <text>
                <xsl:apply-templates select="//chapter"/>
            </text>
            <index>
                <xsl:for-each select="$indexNodes">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </index>
            <footnotes>
                <xsl:for-each select="$footnoteNodes">
                    <xsl:copy-of select="."/>
                </xsl:for-each>
            </footnotes>
        </doc-->
    </xsl:template>

    <xsl:template match="chapter">
        <xsl:choose>
            <xsl:when test="@title and @pagetitle and @tocentry">
\chapter[<xsl:value-of select="replace(@tocentry, '&amp;', '\\&amp;')"/>][<xsl:value-of select="replace(@pagetitle, '&amp;', '\\&amp;')"/>]{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:when>
            <xsl:when test="@title and @pagetitle">
\chapter[][<xsl:value-of select="replace(@pagetitle, '&amp;', '\\&amp;')"/>]{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:when>
            <xsl:when test="@title and @tocentry">
\chapter[<xsl:value-of select="replace(@tocentry, '&amp;', '\\&amp;')"/>][]{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:when>
            <xsl:otherwise>
\chapter{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:otherwise>
        </xsl:choose>
\cleartorecto
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="appendix">
\chapter{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
\label{app:<xsl:value-of select="@index"/>}
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="section">
        <xsl:choose>
            <xsl:when test="@title and @pagetitle and @tocentry">
\section[<xsl:value-of select="replace(@tocentry, '&amp;', '\\&amp;')"/>][<xsl:value-of select="replace(@pagetitle, '&amp;', '\\&amp;')"/>]{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:when>
            <xsl:when test="@title and @pagetitle">
\section[][<xsl:value-of select="replace(@pagetitle, '&amp;', '\\&amp;')"/>]{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:when>
            <xsl:when test="@title and @tocentry">
\section[<xsl:value-of select="replace(@tocentry, '&amp;', '\\&amp;')"/>][]{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:when>
            <xsl:otherwise>
\section{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="subsection">
        <xsl:if test="@newpage">
\clearpage
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@title and @pagetitle and @tocentry">
\subsection[<xsl:value-of select="replace(@tocentry, '&amp;', '\\&amp;')"/>][<xsl:value-of select="replace(@pagetitle, '&amp;', '\\&amp;')"/>]{<xsl:value-of select="replace(upper-case(replace(@title, '&amp;', '\\&amp;')), 'NEWLINE', 'newline')"/>}
            </xsl:when>
            <xsl:when test="@title and @pagetitle">
\subsection[][<xsl:value-of select="replace(@pagetitle, '&amp;', '\\&amp;')"/>]{<xsl:value-of select="replace(upper-case(replace(@title, '&amp;', '\\&amp;')), 'NEWLINE', 'newline')"/>}
            </xsl:when>
            <xsl:when test="@title and @tocentry">
\subsection[<xsl:value-of select="replace(@tocentry, '&amp;', '\\&amp;')"/>][]{<xsl:value-of select="replace(upper-case(replace(@title, '&amp;', '\\&amp;')), 'NEWLINE', 'newline')"/>}
            </xsl:when>
            <xsl:otherwise>
\subsection{<xsl:value-of select="replace(upper-case(replace(@title, '&amp;', '\\&amp;')), 'NEWLINE', 'newline')"/>}
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="subsubsection">
        <xsl:choose>
            <xsl:when test="@title and @pagetitle and @tocentry">
\subsubsection[<xsl:value-of select="replace(@tocentry, '&amp;', '\\&amp;')"/>][<xsl:value-of select="replace(@pagetitle, '&amp;', '\\&amp;')"/>]{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:when>
            <xsl:when test="@title and @pagetitle">
\subsubsection[][<xsl:value-of select="replace(@pagetitle, '&amp;', '\\&amp;')"/>]{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:when>
            <xsl:when test="@title and @tocentry">
\subsubsection[<xsl:value-of select="replace(@tocentry, '&amp;', '\\&amp;')"/>][]{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:when>
            <xsl:otherwise>
\subsubsection{<xsl:value-of select="replace(@title, '&amp;', '\\&amp;')"/>}
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="*"/>
    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::section[position() eq 1 and @index eq '1']]">
        <xsl:variable name="firstSectionPara">
            <xsl:apply-templates select="text() | *"/>
        </xsl:variable>
        <xsl:variable name="lettrine" select="concat('\lettrine[lines=2]',$firstSectionPara)"/>
        <xsl:variable name="sectionNumber">$1\\strictpagecheck\\marginparmargin{outer}\\marginpar[  \\raggedleft\\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesection\\endcsname}]{  \\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesection\\endcsname}}</xsl:variable>
        <xsl:value-of select="replace($lettrine, '^(.*?\w\}\s)', $sectionNumber)"/>

    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::section[position() eq 1 and @index gt '1']]">
        <xsl:variable name="firstSectionPara">
            <xsl:apply-templates select="text() | *"/>
        </xsl:variable>
        <xsl:variable name="sectionNumber">$1\\strictpagecheck\\marginparmargin{outer}\\marginpar[  \\raggedleft\\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesection\\endcsname}]{  \\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesection\\endcsname}}</xsl:variable>
        <xsl:value-of select="replace($firstSectionPara, '^(.*?\w\}\s)', $sectionNumber)"/>

    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::subsection[position() eq 1]]">
        <xsl:variable name="firstSubSectionPara">
            <xsl:apply-templates select="text() | *"/>
        </xsl:variable>        
        <xsl:variable name="subsectionNumber">$1\\strictpagecheck\\marginparmargin{outer}\\marginpar[  \\raggedleft\\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesubsection\\endcsname}]{  \\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesubsection\\endcsname}}</xsl:variable>
        <xsl:value-of select="replace($firstSubSectionPara, '^(.*?\w\s)', $subsectionNumber)"/>
    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::subsubsection[position() eq 1]]">
        <xsl:variable name="firstSubSubSectionPara">
            <xsl:apply-templates select="text() | *"/>
        </xsl:variable>    
        <xsl:variable name="subsubsectionNumber">$1\\strictpagecheck\\marginparmargin{outer}\\marginpar[  \\raggedleft\\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesubsubsection\\endcsname}]{  \\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesubsubsection\\endcsname}}</xsl:variable>
        <xsl:text>\ornament{\XeTeXglyph1373}\rmfamily </xsl:text>
        <xsl:value-of select="replace($firstSubSubSectionPara, '^(.*?\w\s)', $subsubsectionNumber)"/>
    </xsl:template>

    <xsl:template match="paragraph[position() gt 1 or (position() eq 1 and (parent::appendix or parent::chapter))]">
<xsl:text>&#xA;&#xA;</xsl:text>
            <xsl:apply-templates select="text() | *"/>
    </xsl:template>

    <xsl:template match="a[contains(@href,'ftn')]">
        <xsl:variable name="footnoteId" select="replace(@href, '[^\d]', '')"/>
        <xsl:text>\footnote{</xsl:text><xsl:value-of select="//footnote[@id=$footnoteId]"/><xsl:text>} </xsl:text>
    </xsl:template>
    
    <xsl:template match="subparagraph">
<xsl:text>\subparagraph</xsl:text>
<xsl:apply-templates select="text() | *"/>
    </xsl:template>

    <xsl:template match="image[@orient]">
\begin{sidewaysfigure}
\centering
\includegraphics[width=<xsl:value-of select="@width"/>pt]{<xsl:value-of select="@src"/>}
\end{sidewaysfigure}
    </xsl:template>

    <xsl:template match="image">
        <xsl:variable name="float"><xsl:value-of select="if (@float eq 'left') then 'l' else 'r'"/></xsl:variable>
\begin{wrapfigure}{<xsl:value-of select="$float"/>}{<xsl:value-of select="@width"/>pt}
\centering
\includegraphics[width=<xsl:value-of select="@width"/>pt]{<xsl:value-of select="@src"/>}
    <xsl:if test="@caption">
\legend{<xsl:value-of select="@caption"/>} \label{<xsl:value-of select="@caption"/>}
    </xsl:if>
\end{wrapfigure}
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:choose>
            <xsl:when test="@kind eq 'label'">
\begin{labelled}{sclabel}
    <xsl:apply-templates select="child::*"/>
\end{labelled}
            </xsl:when>
            <xsl:when test="@kind eq 'ul'">
\vskip\onelineskip\firmlists
\begin{itemize}[\scriptsize\ornament{\XeTeXglyph1337}\normalfont]

    <xsl:apply-templates select="child::*"/>
\end{itemize}
\vskip\onelineskip
            </xsl:when>            
            <xsl:otherwise>
\begin{enumerate}
    <xsl:apply-templates select="child::*"/>
\end{enumerate}
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="item">
\item <xsl:apply-templates select="text() | *"/>
    </xsl:template>

    <xsl:template match="verse">
\renewcommand{\poemtoc}{subsection}
\renewcommand{\PoemTitlefont}{%
    \huge\centering}
\settowidth{\versewidth}{<xsl:value-of select="stanza/line[@line-length = 'yes']"/>}
\PlainPoemTitle
\PoemTitle{\poeticaTitle <xsl:value-of select="@title"/>}
\begin{verse}[\versewidth]
\Large
\<xsl:value-of select="@font"/>{
<xsl:if test="@linenumberfrequency cast as xs:integer gt 0">
\linenumberfrequency{<xsl:value-of select="@lineumberfrequency"/>}
</xsl:if>
        <xsl:apply-templates select="stanza" mode="verse"/>
}
\end{verse}
<xsl:if test="@author">\attrib{<xsl:value-of select="@author"/>}</xsl:if>
    </xsl:template>

    <xsl:template match="stanza">
\noindent
\setlength{\leftmargini}{0pt}
\settowidth{\versewidth}{<xsl:value-of select="line[@line-length = 'yes']"/>}
\begin{verse}[\versewidth]
\Large
\<xsl:value-of select="@font"/>{
<xsl:if test="@linenumberfrequency cast as xs:integer gt 0">
\linenumberfrequency{<xsl:value-of select="@lineumberfrequency"/>}
</xsl:if>
        <xsl:apply-templates select="." mode="verse"/>
}
\end{verse}
\setlength{\leftmargini}{\verseindent}
<xsl:if test="@author">\attrib{<xsl:value-of select="@author"/>}</xsl:if>
\vskip\onelineskip
    </xsl:template>

    <xsl:template match="stanza" mode="verse">
\begin{patverse}
\indentpattern{<xsl:value-of select="line/@indent" separator=""/>}
<xsl:variable name="stanzaindex" select="@index"/>
<xsl:for-each select="line">

<xsl:choose>
    <xsl:when test="($stanzaindex cast as xs:integer eq 1) and (position() eq 1)">
        <xsl:variable name="initial" select="substring(., 1, 1)"/>
        <xsl:variable name="remaining" select="substring(., 2)"/>
\huge <xsl:value-of select="$initial"/>\Large <xsl:value-of select="$remaining"/>
    </xsl:when>
    <xsl:otherwise>
        <xsl:value-of select="."/>
    </xsl:otherwise>
</xsl:choose>

<xsl:if test="not(position()=last())">
<xsl:text>\\&#xA;</xsl:text>
</xsl:if>
<xsl:if test="position()=last()">
<xsl:text>\strictpagecheck\marginparmargin{outer}\marginpar[\raggedleft\scriptsize </xsl:text><xsl:value-of select="parent::*/@flagtext"/><xsl:text>]{ \scriptsize </xsl:text><xsl:value-of select="parent::*/@flagtext"/><xsl:text>}</xsl:text><xsl:text>\\!</xsl:text>
</xsl:if>
</xsl:for-each>
\end{patverse}
<xsl:if test="position() = last()">
\linenumberfrequency{0}
</xsl:if>
    </xsl:template>
    
    <xsl:template match="bold">
           <xsl:choose>
               <xsl:when test="child::italic">
\emph{<xsl:apply-templates select="text() | child::*" mode="bolditalic"/>}                   
               </xsl:when>
               <xsl:otherwise>
\textbf{<xsl:apply-templates select="text() | child::*"/>}
               </xsl:otherwise>
           </xsl:choose>                  
    </xsl:template>
        
    <xsl:template match="italic">
\textit{<xsl:apply-templates select="text() | child::*"/>}
    </xsl:template>
    
    <xsl:template match="underline">
{\scshape <xsl:apply-templates select="text() | child::*"/>}
    </xsl:template>    
            
    <xsl:template match="superscript">
\textsuperscript{<xsl:apply-templates select="text() | child::*"/>}
    </xsl:template>   
    
    <xsl:template match="subscript">
\textsubscript{<xsl:apply-templates select="text() | child::*"/>}
    </xsl:template> 
    
    <xsl:template match="essential">
<!--\essentialHighlightFont <xsl:apply-templates select="text() | child::*"/> \strictpagecheck\marginparmargin{outer}\marginpar[  \raggedleft\small\ornament{\XeTeXglyph1401}]{  \small\ornament{\XeTeXglyph1402}} 
\normalfont -->
\essentialHighlightFont <xsl:apply-templates select="text() | child::*"/> \normalfont
    </xsl:template> 
    
    <xsl:template match="text()">
       <xsl:variable name="v10" select="replace(., '\(c\)', '\\textcopyright')"/>
       <xsl:variable name="v11" select="replace($v10, '\(r\)', '\\textregistered')"/>
       <xsl:variable name="v12" select="replace($v11, '\(tm\)', '\\texttrademark')"/>
       <xsl:variable name="v13" select="replace($v12, '1/2', '\\textonehalf')"/>
       <xsl:variable name="v14" select="replace($v13, '1/4', '\\textonequarter')"/>
       <xsl:variable name="v15" select="replace($v14, '3/4', '\\textthreequarter')"/>
       <!--xsl:variable name="v16" select="replace($v15, 'No. ', '\\textnumero')"/-->
       <xsl:variable name="v16" select="replace($v15, '\s+(\p{P})', '$1')"/>       
       <xsl:variable name="v17" select="replace($v15, '--{1}', '---')"/>
       <xsl:variable name="v18" select="replace($v17, 'etc\.', 'etc.\\')"/>
       <xsl:variable name="v19" select="replace($v18, 'e\.g\.', 'e.g.\\')"/>
       <xsl:variable name="v20" select="replace($v19, 'i\.e\.', 'i.e.\\')"/>
       <xsl:variable name="v21" select="replace($v20, '\s*\.\.{2,}', '\\ldots ')"/>
       <xsl:variable name="v22" select="replace($v21, '(\s*)&quot;(.*?)&quot;([\s.?!;:,]+)', '$1``$2&quot;$3')"/>
       <xsl:variable name="v23" select="concat('(\s*)',$apos, '([\p{L}\s\p{P}]*?)', $apos, '([\s.?!;:,S]+|$)')"/>
       <xsl:variable name="v24" select="concat('$1`$2', $apos, '$3')"/>
       <xsl:variable name="v25" select="replace($v22, $v23, $v24)"/>        
        <xsl:value-of select="normalize-space($v25)"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="bolditalic">
        <xsl:value-of select="."/>
    </xsl:template>          
</xsl:stylesheet>
