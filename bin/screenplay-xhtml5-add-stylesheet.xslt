<xsl:stylesheet version = '1.0'
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    >

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:template>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//xhtml:head">
        <xsl:apply-templates select="*"/>
        <link rel="stylesheet" href="https://www.shlomifish.org/screenplay.css" media="screen" title="Normal"/>
    </xsl:template>

    <!--
        <link rel="stylesheet" href="https://www.shlomifish.org/style.css" media="screen" title="Normal"/>
    <xsl:template match="h:section[@class='section']/h:div[@class='titlepage']">
            <xsl:apply-templates select="./*"/>
    </xsl:template>
    -->

</xsl:stylesheet>
