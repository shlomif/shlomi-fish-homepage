<?xml version="1.0" encoding="utf-8" ?>
<xsl:stylesheet version = '1.0'
    xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    xmlns="http://www.w3.org/1999/xhtml"
     >

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"
 doctype-public="-//W3C//DTD XHTML 1.1//EN"
 doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
/>

<xsl:param name="fortune.id"></xsl:param>

<!-- The purpose of this function is to recursively copy elements without a
namespace-->
<xsl:template mode="copy-html-ns" match="*">
    <xsl:element xmlns="http://www.w3.org/1999/xhtml" name="{local-name()}">
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates mode="copy-html-ns"/>
    </xsl:element>
</xsl:template>

<xsl:template name="copy_html_ns_by_name">
    <xsl:element xmlns="http://www.w3.org/1999/xhtml" name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:call-template name="copy_html_ns_by_name"/>
    </xsl:element>
</xsl:template>

<xsl:template match="/collection">
    <ul xml:lang="en">
        <xsl:apply-templates select="list/fortune"/>
    </ul>
</xsl:template>

<xsl:template match="fortune">
    <li><a href="#{@id}"><xsl:call-template name="get_header"/></a></li>
</xsl:template>

<xsl:template name="get_irc_default_header">
    <xsl:choose>
        <xsl:when test="info">
            <xsl:if test="info/tagline">
                <xsl:value-of select="info/tagline"/> on
            </xsl:if>
            <xsl:if test="info/network">
                <xsl:value-of select="info/network"/>'s
            </xsl:if>
            <xsl:value-of select="info/channel"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text>Unknown Subject</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="get_header">
    <xsl:choose>
        <xsl:when test="meta/title">
            <xsl:value-of select="meta/title"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="get_irc_default_header"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
