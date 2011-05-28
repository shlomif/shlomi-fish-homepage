<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version='1.0'
    xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns="http://docbook.org/ns/docbook"
    xmlns:db="http://docbook.org/ns/docbook">

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/db:article/db:info">
        <info xml:lang="en-UK">
            <xsl:apply-templates/>
            <authorgroup>
                <author>
                    <personname>
                        <firstname>Shlomi</firstname>
                        <surname>Fish</surname>
                    </personname>
                    <affiliation>
                        <address>
                            <email>shlomif@shlomifish.org</email>
                            <uri type="homepage" xlink:href="http://www.shlomifish.org/">Shlomi Fish’s Homepage</uri>
                        </address>
                    </affiliation>
                </author>
            </authorgroup>
            <copyright>
                <year>2004</year>
                <holder>Shlomi Fish</holder>
            </copyright>
            <legalnotice>
                <para>
                    This document is copyrighted by Shlomi Fish
                    under the 
                    <link xlink:href="http://creativecommons.org/licenses/by-sa/3.0/">Creative
                        Commons Attribution Share-Alike Unported License version 3.0</link> 
                    (or at your option a greater version). Please see
                    <link xlink:href="http://www.shlomifish.org/meta/copyrights/">Shlomi 
                        Fish's copyright terms</link> for how to comply with the
                    licence.
                </para>
            </legalnotice>
        </info>
    </xsl:template>

</xsl:stylesheet>
