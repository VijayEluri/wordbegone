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
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:latex="http://www.leanne.northrop.org/xslt"
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
        <xsl:apply-templates select="child::*"/>
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
        <xsl:apply-templates select="child::*"/>
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
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::section[position() eq 1 and @index eq '1']]">
        <xsl:variable name="firstSectionPara" select="latex:processText(.)"/>
        <xsl:variable name="lettrine" select="concat('\lettrine[lines=2]',$firstSectionPara)"/>
        <xsl:variable name="sectionNumber">$1\\strictpagecheck\\marginparmargin{outer}\\marginpar[  \\raggedleft\\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesection\\endcsname}]{  \\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesection\\endcsname}}</xsl:variable>
        <xsl:value-of select="replace($lettrine, '^(.*?\w\}\s)', $sectionNumber)"/>

    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::section[position() eq 1 and @index gt '1']]">
        <xsl:variable name="firstSectionPara" select="latex:processText(.)"/>
        <xsl:variable name="sectionNumber">$1\\strictpagecheck\\marginparmargin{outer}\\marginpar[  \\raggedleft\\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesection\\endcsname}]{  \\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesection\\endcsname}}</xsl:variable>
        <xsl:value-of select="replace($firstSectionPara, '^(.*?\w\}\s)', $sectionNumber)"/>

    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::subsection[position() eq 1]]">
        <xsl:variable name="firstSubSectionPara" select="latex:processText(.)"/>
        <xsl:variable name="subsectionNumber">$1\\strictpagecheck\\marginparmargin{outer}\\marginpar[  \\raggedleft\\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesubsection\\endcsname}]{  \\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesubsection\\endcsname}}</xsl:variable>
        <xsl:value-of select="replace($firstSubSectionPara, '^(.*?\w\s)', $subsectionNumber)"/>
    </xsl:template>

    <xsl:template match="paragraph[position() eq 1 and parent::subsubsection[position() eq 1]]">
        <xsl:variable name="firstSubSubSectionPara" select="latex:processText(.)"/>
        <xsl:variable name="subsubsectionNumber">$1\\strictpagecheck\\marginparmargin{outer}\\marginpar[  \\raggedleft\\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesubsubsection\\endcsname}]{  \\scriptsize\\normalfont\\sectionnumbersfont{\\csname thesubsubsection\\endcsname}}</xsl:variable>
        <xsl:text>\ornament{\XeTeXglyph1373}\rmfamily </xsl:text>
        <xsl:value-of select="replace($firstSubSubSectionPara, '^(.*?\w\s)', $subsubsectionNumber)"/>
    </xsl:template>

    <xsl:template match="paragraph[position() gt 1 or (position() eq 1 and (parent::appendix or parent::chapter))]">
<xsl:text>&#xA;&#xA;</xsl:text>
<xsl:value-of select="latex:processText(.)"/>
    </xsl:template>

    <xsl:template match="subparagraph">
<xsl:text>\subparagraph</xsl:text>
<xsl:value-of select="latex:processText(.)"/>
    </xsl:template>

    <xsl:template match="image[@orient]">
\begin{sidewaysfigure}
\centering
\includegraphics[width=<xsl:value-of select="@width"/>]{<xsl:value-of select="@src"/>}
\end{sidewaysfigure}
    </xsl:template>

    <xsl:template match="image">
        <xsl:variable name="float"><xsl:value-of select="if (@float eq 'left') then 'l' else 'r'"/></xsl:variable>
\begin{wrapfigure}{<xsl:value-of select="$float"/>}{<xsl:value-of select="@width"/>}
\centering
\includegraphics[width=<xsl:value-of select="@width"/>]{<xsl:value-of select="@src"/>}
    <xsl:if test="@caption">
\legend{<xsl:value-of select="@caption"/>} \label{<xsl:value-of select="@caption"/>}
    </xsl:if>
\end{wrapfigure}
    </xsl:template>

    <xsl:template match="table">
        <!--xsl:value-of select="@caption"/-->
        <!--xsl:apply-templates select="descendant::*"/-->
    </xsl:template>

    <xsl:template match="tr">
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="td">
        <xsl:variable name="v" select="."/>
        <xsl:value-of select="$v"/>
    </xsl:template>

    <xsl:template match="th">
        <xsl:variable name="v" select="."/>
        <xsl:value-of select="$v"/>
    </xsl:template>

    <xsl:template match="paragraph" mode="index">
        <xsl:analyze-string select="." regex="@\(([a-z]*):([a-zA-Z ,!]*)\)[a-zA-Z ]*@">
            <xsl:matching-substring>
                <xsl:element name="entry">
                    <xsl:attribute name="type"><xsl:value-of select="regex-group(1)"/></xsl:attribute>
                    <xsl:attribute name="label"><xsl:value-of select="regex-group(2)"/></xsl:attribute>
                </xsl:element>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template match="paragraph" mode="footnote">
        <xsl:variable name="indexedFN" select="latex:markupIndex(.)"/>
        <xsl:analyze-string select="$indexedFN" regex="^fn([0-9]{{1,}})\.\s(.*?)$" flags="sm">
            <xsl:matching-substring>
                <xsl:element name="footnote">
                    <xsl:attribute name="id"><xsl:value-of select="regex-group(1)"/></xsl:attribute>
                    <xsl:value-of select="latex:markupIndex(regex-group(2))"/>
                </xsl:element>
            </xsl:matching-substring>
        </xsl:analyze-string>
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
\item <xsl:value-of select="latex:processText(.)"/>
    </xsl:template>

    <xsl:template match="verse">
\renewcommand{\poemtoc}{subsection}
\renewcommand{\PoemTitlefont}{%
    \huge\centering}
\settowidth{\versewidth}{<xsl:value-of select="stanza/line[@line-length = 'yes']"/>}
\PlainPoemTitle
\PoemTitle{\poeticaTitle <xsl:value-of select="latex:markupVerseFonts(@title)"/>}
\begin{verse}[\versewidth]
\Large
\<xsl:value-of select="@font"/>{
<xsl:if test="@linenumberfrequency cast as xs:integer gt 0">
\linenumberfrequency{<xsl:value-of select="@lineumberfrequency"/>}
</xsl:if>
        <xsl:apply-templates select="stanza" mode="verse"/>
}
\end{verse}
<xsl:if test="@author">\attrib{<xsl:value-of select="latex:markupVerseFonts(@author)"/>}</xsl:if>
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
<xsl:if test="@author">\attrib{<xsl:value-of select="latex:markupVerseFonts(@author)"/>}</xsl:if>
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
\huge <xsl:value-of select="$initial"/>\Large <xsl:value-of select="latex:markupVerseFonts($remaining)"/>
    </xsl:when>
    <xsl:otherwise>
        <xsl:value-of select="latex:markupVerseFonts(.)"/>
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

    <xsl:function name="latex:processText" as="xs:string">
           <xsl:param name="str" as="xs:string"/>

           <xsl:variable name="indexed" select="latex:markupIndex($str)"/>
           <xsl:variable name="footnotes" select="latex:markupFootnotes($indexed)"/>
           <xsl:variable name="font" select="latex:markupFonts($footnotes)"/>
           <xsl:variable name="lists" select="latex:markupLists($font)"/>
           <xsl:variable name="formatted" select="latex:markupQuotes(latex:markupSpecialCharacters($lists))"/>

           <xsl:value-of select="$formatted" disable-output-escaping="yes"/>
       </xsl:function>

       <xsl:function name="latex:markupIndex" as="xs:string">
           <xsl:param name="str" as="xs:string"/>

           <xsl:variable name="cite" select="replace($str, '@\(cite:([a-z0-9-]*?)\)', '\\cite{$1}')"/>
           <xsl:variable name="person1" select="replace($cite, '@\(person\)([\w\d\s.]*?)@', '$1\\index{Notable Figures!$1}')"/>
           <xsl:variable name="person2" select="replace($person1, '@\(person:([\w\s\d,-]*?)\)([\w\d\s\p{P}]*?)@', '$2\\index{Notable Figures!$1}')"/>
           <xsl:variable name="v1" select="replace($person2, '@\(ref:([\w\s\d,-]*?)\)([\w\d\s\p{P}]*?)@', '$2\\index{Reference!$1}')"/>
           <xsl:variable name="sutra1" select="replace($v1, '@\(sutra:([\w\s\d,-]*?)\)([\w\d\s\p{P}]*?)@', '$2\\index{Sutras!$1}')"/>
           <xsl:variable name="sutra2" select="replace($sutra1, '@\(sutra\)([\w\d\s\p{P}]*?)@', '$2\\index{Sutras!$2}')"/>
           <xsl:variable name="place1" select="replace($sutra2, '@\(place\)([\w\d\s]*?)@', '$1\\index{Place!$1}')"/>
           <xsl:variable name="place2" select="replace($place1, '@\(place:([\w\s\d,-]*?)\)([\w\d\s\p{P}]*?)@', '$2\\index{Place!$1}')"/>
           <xsl:variable name="glossary" select="replace($place2, '@\(glossary:([\w\s\d,-]*?)\)([\w\d\s\p{P}]*?)@', '$2\\index{$2}')"/>
           <xsl:variable name="v2" select="replace($glossary, '@\([a-z]*:([\w\s\d,!-]*?)\)([\w\d\s\p{P}]*?)@', '$2\\index{$1}')"/>
           <xsl:variable name="vv" select="replace($v2, '@\(([\w\s\d,!-]*?)\)([\w\d\s\p{P}]*?)@', '$2\\index{$1}')"/>
           <xsl:value-of select="$vv"/>
       </xsl:function>

       <xsl:function name="latex:markupFonts" as="xs:string">
           <xsl:param name="str" as="xs:string"/>

           <xsl:variable name="essentialMarker">$1\\strictpagecheck\\marginparmargin{outer}\\marginpar[  \\raggedleft\\small\\ornament{\\XeTeXglyph1401}]{  \\small\\ornament{\\XeTeXglyph1402}}</xsl:variable>
           <xsl:variable name="essentialHighlightMarked" select="replace($str, '(\(eh\)\w*?\s)', $essentialMarker)"/>

           <xsl:variable name="essentialHighlighStart" select="replace($essentialHighlightMarked, '\(eh\)', '\\essentialHighlightFont ')"/>

           <xsl:variable name="essentialHighlighEnd" select="replace($essentialHighlighStart, '\(eeh\)', '\\normalfont   ')"/>

           <xsl:variable name="exerciseMarker">$1\\strictpagecheck\\marginparmargin{outer}\\marginpar[  \\raggedleft\\small\\ornament{\\XeTeXglyph1401}]{  \\small\\ornament{\\XeTeXglyph1402}}</xsl:variable>
           <xsl:variable name="exerciseHighlightMarked" select="replace($essentialHighlighEnd, '(\(wh\)\w*?\s)', $exerciseMarker)"/>

           <xsl:variable name="exerciseHighlighStart" select="replace($exerciseHighlightMarked, '\(wh\)', '\\exerciseHighlightFont ')"/>

           <xsl:variable name="exerciseHighlighEnd" select="replace($exerciseHighlighStart, '\(ewh\)', '\\normalfont ')"/>

           <xsl:variable name="contraversialMarker">$1\\strictpagecheck\\marginparmargin{outer}\\marginpar[  \\raggedleft\\small\\ornament{\\XeTeXglyph1401}]{  \\small\\ornament{\\XeTeXglyph1402}}</xsl:variable>
           <xsl:variable name="contraversialHighlightMarked" select="replace($exerciseHighlighEnd, '(\(ch\)\w*?\s)', $contraversialMarker)"/>

           <xsl:variable name="contraversialHighlighStart" select="replace($contraversialHighlightMarked, '\(ch\)', '\\contraversialHighlightFont ')"/>

           <xsl:variable name="contraversialHighlighEnd" select="replace($contraversialHighlighStart, '\(ech\)', '\\normalfont ')"/>

           <xsl:variable name="bolditalic" select="replace($contraversialHighlighEnd, '(_\*|\*_)(.*?)(\*_|_\*)', '\\emph{$2}')"/>
           <xsl:variable name="bold" select="replace($bolditalic, '\*([^\s].*?)\*', '\\textbf{$1}')"/>
           <xsl:variable name="italic" select="replace($bold, '_([^\s].*?)_', '\\textit{$1}')"/>
           <xsl:variable name="underline" select="replace($italic, '\+([^\s].*?)\+', '{\\scshape $1}')"/>

           <xsl:value-of select="$underline"/>
       </xsl:function>

       <xsl:function name="latex:markupVerseFonts" as="xs:string">
           <xsl:param name="str" as="xs:string"/>

           <xsl:variable name="bolditalic" select="replace($str, '_\*(.*?)\*_', '\\emph{$1}')"/>
           <xsl:variable name="bold" select="replace($bolditalic, '\*([^\s].*?)\*', '\\textbf{$1}')"/>
           <xsl:variable name="italic" select="replace($bold, '_([^\s].*?)_', '\\textit{$1}')"/>
           <xsl:variable name="underline" select="replace($italic, '\+([^\s].*?)\+', '{\\versesmallcapsfont $1}')"/>
           <xsl:variable name="swash" select="replace($underline, '%([^\s][a-zA-Z]*?)%', '{\\verseswashfont $1}', 'sm')"/>
           <xsl:variable name="newline" select="replace($swash, '&#xA;', '\\\\')"/>

           <xsl:value-of select="latex:markupIndex(latex:markupSpecialCharacters($newline))"/>
       </xsl:function>

       <xsl:function name="latex:markupLists" as="xs:string">
           <xsl:param name="str" as="xs:string"/>

           <xsl:variable name="v3" select="replace($str, '^[\n\r]+?(^#\s)', '\\firmlists&#xA;\\begin{enumerate}&#xA;$1','sm')"/>
           <xsl:variable name="v4" select="replace($v3, '^(#.*?$)^[^#]', '$1\\end{enumerate}&#xA;&#xA;','sm')"/>
           <xsl:variable name="v5" select="replace($v4, '^#', '\\item','sm')"/>

           <xsl:variable name="v6" select="replace($v5, '^[\n\r]+?(^\*\s)', '\\vskip\\onelineskip\\firmlists&#xA;&#xA;\\begin{itemize}[\\scriptsize\\ornament{\\XeTeXglyph1337}\\normalfont]&#xA;$1','sm')"/>
           <xsl:variable name="v7" select="replace($v6, '^(\*\s.*?$)^[^\*]', '$1\\end{itemize}\\vskip\\onelineskip','sm')"/>
           <xsl:variable name="v8" select="replace($v7, '^\*', '\\item','sm')"/>

           <xsl:variable name="va1" select="replace($v8, '^[\n\r]+?(^~\s)', '&#xA;\\begin{blockdescription}&#xA;$1','sm')"/>
           <xsl:variable name="va2" select="replace($va1, '^(~.*?$)^[^~]', '$1\\end{blockdescription}&#xA;&#xA;','sm')"/>
           <xsl:variable name="va3" select="replace($va2, '^~', '\\item','sm')"/>

           <xsl:value-of select="$va3"/>
       </xsl:function>

       <xsl:function name="latex:markupQuotes" as="xs:string">
           <xsl:param name="str" as="xs:string"/>

           <xsl:variable name="v9" select="replace($str, '^bq\.\s(.*?)$^$', '\\begin{quotation}&#xA;$1&#xA;\\end{quotation}&#xA;','sm')"/>
           <xsl:variable name="smallquote" select="replace($v9, '^q\.\s(.*?)$^$', '\\begin{quote}&#xA;$1&#xA;\\end{quote}&#xA;','sm')"/>
           <xsl:value-of select="$smallquote"/>
       </xsl:function>

       <xsl:function name="latex:markupSpecialCharacters" as="xs:string">
           <xsl:param name="str" as="xs:string"/>

           <xsl:variable name="superscript" select="replace($str, '\^([a-z]*?)\^', '\\textsuperscript{$1}')"/>
           <xsl:variable name="v10" select="replace($superscript, '\(c\)', '\\textcopyright')"/>
           <xsl:variable name="v11" select="replace($v10, '\(r\)', '\\textregistered')"/>
           <xsl:variable name="v12" select="replace($v11, '\(tm\)', '\\texttrademark')"/>
           <xsl:variable name="v13" select="replace($v12, '1/2', '\\textonehalf')"/>
           <xsl:variable name="v14" select="replace($v13, '1/4', '\\textonequarter')"/>
           <xsl:variable name="v15" select="replace($v14, '3/4', '\\textthreequarter')"/>
           <!--xsl:variable name="v16" select="replace($v15, 'No. ', '\\textnumero')"/-->
           <xsl:variable name="v16" select="$v15"/>
           <xsl:variable name="v17" select="replace($v16, '--{1}', '---')"/>
           <xsl:variable name="v18" select="replace($v17, 'etc\.', 'etc.\\')"/>
           <xsl:variable name="v19" select="replace($v18, 'e\.g\.', 'e.g.\\')"/>
           <xsl:variable name="v20" select="replace($v19, 'i\.e\.', 'i.e.\\')"/>
           <xsl:variable name="v21" select="replace($v20, '\s*\.\.\.', '\\ldots ')"/>
           <xsl:variable name="v22" select="replace($v21, '(\s*)&quot;(.*?)&quot;([\s.?!;:,]+)', '$1``$2&quot;$3')"/>
           <xsl:variable name="v23" select="concat('(\s*)',$apos, '([a-zA-Z0-9\s?!.,;:\-]*?)', $apos, '([\s.?!;:,S]+)')"/>
           <xsl:variable name="v24" select="concat('$1`$2', $apos, '$3')"/>
           <xsl:variable name="v25" select="replace($v22, $v23, $v24)"/>

           <xsl:value-of select="$v25"/>
       </xsl:function>


       <xsl:function name="latex:markupFootnotes" as="xs:string">
           <xsl:param name="str" as="xs:string"/>

           <xsl:variable name="v31">
               <xsl:analyze-string select="$str" regex="\[([0-9]{{1,}})\]">
                    <xsl:matching-substring>
                        <xsl:variable name="fnid"><xsl:value-of select="regex-group(1)"/></xsl:variable>
                        <xsl:for-each select="$footnoteNodes/child::*[@id=$fnid]">
                            <xsl:text>\footnote{</xsl:text><xsl:value-of select="."/><xsl:text>} </xsl:text>
                        </xsl:for-each>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring><xsl:value-of select="."/></xsl:non-matching-substring>
               </xsl:analyze-string>
           </xsl:variable>
           <xsl:variable name="v32" select="replace($v31, '^fn([0-9]{1,})\.\s(.*?)$', '', 'sm')"/>

           <xsl:value-of select="$v32"/>
       </xsl:function>

</xsl:stylesheet>
