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

    <xsl:template match="node()[xhtml:a/@id]">
        <xsl:copy>
            <xsl:copy-of select="xhtml:a/@id"/>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="xhtml:h3[@class='author']">
        <xsl:element name="h2">
            <xsl:copy-of select="xhtml:a/@id"/>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="xhtml:table/@summary">
    </xsl:template>

    <xsl:template match="xhtml:a/@id"/>

    <xsl:template match="xhtml:a[not(@href)]"/>

    <xsl:template match="h:div[@class='titlepage' and count(*)=1][h:div[count(@*)=0 and h:div[count(@*)=0 and *[@id and @class='title']]]]">
        <header class="{@class}">
            <xsl:apply-templates select="./*/*/*"/>
        </header>
    </xsl:template>

    <!--
    <xsl:template match="h:section[@class='section']/h:div[@class='titlepage']">
            <xsl:apply-templates select="./*"/>
    </xsl:template>
    -->

</xsl:stylesheet>
