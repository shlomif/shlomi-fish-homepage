<xsl:stylesheet version = '1.0'
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    >

    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"
        doctype-public="-//W3C//DTD XHTML 1.1//EN"
        doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
        />



    <xsl:template match="*">
        <xsl:apply-templates mode="foo" />
    </xsl:template>

    <xsl:template mode="copy_html_ns" match="*">
        <xsl:element xmlns="http://www.w3.org/1999/xhtml" name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="foo" />
       </xsl:element>
    </xsl:template>

    <xsl:template match="*" mode="foo">
        <xsl:choose>
            <xsl:when test="a">
                <xsl:element xmlns="http://www.w3.org/1999/xhtml" name="foobar">
                    <!--
                    <xsl:attribute name="id">
                        <xsl:value-of select="a[@id]" />
                    </xsl:attribute>
                    -->
                    <xsl:copy-of select="@*" />
                    <xsl:apply-templates mode="foo" />
                </xsl:element>
            </xsl:when>
            <xsl:when test="local-name() = 'a' and @id">
            </xsl:when>
            <xsl:otherwise>
                <xsl:element xmlns="http://www.w3.org/1999/xhtml" name="{local-name()}">
                    <xsl:copy-of select="@*" />
                    <xsl:apply-templates mode="foo" />
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
