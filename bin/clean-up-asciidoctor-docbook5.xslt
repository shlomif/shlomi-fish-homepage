<?xml version='1.0' encoding='UTF-8'?>
<xsl:stylesheet
    exclude-result-prefixes="d"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    version='1.0'
    >
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"
        />

    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="//d:article">
        <d:article>
            <xsl:if test="not(@xml:id)">
                <xsl:attribute name="xml:id">index</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node() | @*"/>
        </d:article>
    </xsl:template>
</xsl:stylesheet>
