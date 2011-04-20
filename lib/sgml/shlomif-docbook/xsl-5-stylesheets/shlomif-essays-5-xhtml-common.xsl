<xsl:stylesheet
    exclude-result-prefixes="d"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:d="http://docbook.org/ns/docbook"
    version='1.0'
    >

    <!--
         Commented out because it does not work properly.
    <xsl:template name="anchor">
        <xsl:param name="node" select="."/>
        <xsl:param name="conditional" select="1"/>
        <xsl:variable name="id">
            <xsl:call-template name="object.id">
                <xsl:with-param name="object" select="$node"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:attribute name="id">
            <xsl:value-of select="$id" />
        </xsl:attribute>

    </xsl:template>
    -->
</xsl:stylesheet>
