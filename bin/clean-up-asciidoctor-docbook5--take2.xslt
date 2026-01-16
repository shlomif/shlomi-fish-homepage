<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
xmlns:d="http://docbook.org/ns/docbook"
xmlns:xlink="http://www.w3.org/1999/xlink"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:myNS="http://devedge.netscape.com/2002/de">

<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="d:title">

<d:info>
<!--
<xsl:value-of select="d:title" />
-->
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</d:info>

</xsl:template>

<xsl:template match="d:Body">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>

<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
</xsl:stylesheet>
