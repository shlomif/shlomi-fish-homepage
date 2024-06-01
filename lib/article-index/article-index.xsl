<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <xsl:apply-templates select="node()|@*"/>
    </xsl:template>

<xsl:key name="impl" match="/comparison/meta/implementations/impl" use="@id"/>

<xsl:template match="/index">
<html xmlns="http://www.w3.org/1999/xhtml">
    <body>
<xsl:apply-templates select="contents" mode="toc"/>
</body>
</html>
</xsl:template>

<xsl:template match="contents">
</xsl:template>

<xsl:template match="contents" mode="toc">
    <nav>
    <ol>
        <xsl:apply-templates select="section" mode="toc"/>
    </ol>
    </nav>
    <xsl:apply-templates select="section"/>
</xsl:template>

<xsl:template match="section" mode="toc">
    <li>
        <a href="#{@id}"><xsl:value-of select="@title"/></a><br/>
        <ol>
            <xsl:apply-templates select="section|entry" mode="toc"/>
        </ol>
    </li>
</xsl:template>

<xsl:template match="entry" mode="toc">
    <li>
        <a href="#{@id}"><xsl:value-of select="@title"/></a>
    </li>
</xsl:template>

<xsl:template match="section">
    <xsl:if test="count(ancestor-or-self::section) = 1">
        <xsl:element name="h{count(ancestor-or-self::section)}">
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:value-of select="@title"/>
        </xsl:element>
        <xsl:apply-templates select="section|entry"/>
    </xsl:if>
    <xsl:if test="count(ancestor-or-self::section) &gt; 1">
        <section>
            <header>
                <xsl:element name="h{count(ancestor-or-self::section)}">
                    <xsl:attribute name="id">
                        <xsl:value-of select="@id"/>
                    </xsl:attribute>
                    <xsl:value-of select="@title"/>
                </xsl:element>
            </header>
            <xsl:apply-templates select="section|entry"/>
        </section>
    </xsl:if>
</xsl:template>

<xsl:template match="entry">
    <section>
        <header>
            <xsl:element name="h{count(ancestor-or-self::section)+count(ancestor-or-self::entry)}">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="@url"/>
                    </xsl:attribute>
                    <xsl:value-of select="@title"/>
                </xsl:element>
            </xsl:element>
        </header>
        <xsl:apply-templates/>
    </section>
</xsl:template>

<xsl:template match="p">
    <p>
        <xsl:apply-templates/>
    </p>
</xsl:template>

<xsl:template match="a">
    <a href="{@href}"><xsl:apply-templates/></a>
</xsl:template>

</xsl:stylesheet>
