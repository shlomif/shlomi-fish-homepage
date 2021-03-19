<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet
    exclude-result-prefixes="d #default"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version='1.0'
    >
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//article">
        <article>
            <xsl:if test="not(@xml:id)">
                <xsl:attribute name="xml:id">index</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node() | @*"/>
        </article>
    </xsl:template>
    <xsl:template match="//info/author[not(./affiliation)]">
        <author>
            <xsl:apply-templates select="node() | @*"/>
            <affiliation>
                <address>
                    <uri type="homepage" xlink:href="https://www.shlomifish.org/">Shlomi Fish’s Homepage</uri>
                </address>
            </affiliation>
        </author>
    </xsl:template>
</xsl:stylesheet>
