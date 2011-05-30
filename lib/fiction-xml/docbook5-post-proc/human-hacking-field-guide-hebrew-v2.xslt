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
        <info xml:lang="he-IL">
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
                            <uri type="homepage" xlink:href="http://www.shlomifish.org/">דף הבית של שלומי פיש</uri>
                        </address>
                    </affiliation>
                </author>
            </authorgroup>
            <copyright>
                <year>2011</year>
                <holder>שלומי פיש</holder>
            </copyright>
            <legalnotice>

                <para>
                    זהו תרגום לעברית של סיפור מקורי ובדיוני מאת <link
                        xlink:href="http://www.shlomifish.org/">שלומי
                        פיש</link>.
                </para>

                <para>
                    התרגום, כמו הסיפור זמין תחת רשיון <link
                        xlink:href="http://creativecommons.org/licenses/by-sa/3.0/">רשיון
                        הייחוס-שיתוף-זהה 3.0 (Unported) של קריאטיב קומונס
                        (CC-by-sa)</link> או לשיקולכם כל גרסה מאוחרת יותר.
                </para>

                <para>
                    ראו את <link
                        xlink:href="http://www.shlomifish.org/meta/copyrights/">דף
                        תנאי זכויות היוצרים של שלומי פיש</link> על כיצד לעמוד
                    בתנאי רשיון זה.
                </para>

                <para>
                    הזכויות לסיפור שמורות לשלומי פיש, 2005.
                </para>

                <para>
                    הזכויות לתרגום שמורות לשלומי פיש, 2011.
                </para>

            </legalnotice>
        </info>
    </xsl:template>

</xsl:stylesheet>
