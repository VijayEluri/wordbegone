<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output encoding="UTF-8" method="text" />

    <xsl:template match="/">%!TEX TS-program = xelatex
%!TEX encoding = UTF-8 Unicode
\documentclass[10pt,extrafontsizes,twoside,onecolumn,openright,final,showtrims]{memoir}
\usepackage{layout}
\makeindex

\title{The\\Kagyu Samye Ling\\ Dharma StudyProgramme\\Volume One}
\author{Ken Holmes\thanks{Supported by Kagyu Samye Ling}\\ Eskdalemuir, Scotland}
\date{1 October 2009\thanks{First drafted on 29 February 1992}}

%%% BEGIN DOCUMENT
\begin{document}
\nocite{*}
\jurabibsetup{super,citefull=first,ibidem,lookat}
\frontmatter
\pagestyle{empty}
\book{The\\Kagyu Samye Ling\\ Dharma Study Programme}
\part{Volume One}
\tableofcontents* % the asterisk means that the contents itself isn't put into the ToC
\cleartorecto
\listoffigures
\cleartorecto
\listoftables
\cleartorecto
\pagestyle{leanne}
\mainmatter
        <xsl:apply-templates select="book/chapters"/>

\backmatter
\appendixpage
\appendix
        <xsl:apply-templates select="book/appendices"/>
\pagestyle{empty}
\cleartorecto
\bibliography{references}
\bibliographystyle{jurabib}
\cleartorecto
\printindex
\bookpageend
\end{document}
    </xsl:template>

    <xsl:template match="chapters|appendices"><xsl:apply-templates select="li"/></xsl:template>

    <xsl:template match="li">
\include{<xsl:value-of select="."/>}
    </xsl:template>

</xsl:stylesheet>
