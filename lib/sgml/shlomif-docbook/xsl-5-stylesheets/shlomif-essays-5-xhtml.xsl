<xsl:stylesheet
    exclude-result-prefixes="d"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:d="http://docbook.org/ns/docbook"
    version='1.0'
    >
    <xsl:import href="xhtml/docbook.xsl"/>
    <xsl:param name="use.id.as.filename">1</xsl:param>
    <xsl:param name="html.stylesheet">style.css</xsl:param>
    <xsl:param name="itemizedlist.propagates.style">1</xsl:param>
    <xsl:param name="chunker.output.doctype-public">-//W3C//DTD XHTML 1.0 Transitional//EN</xsl:param>
    <xsl:param name="chunker.output.doctype-system">http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd</xsl:param>
    <!-- Parameters for Generating Strict Output. See:
    http://www.sagehill.net/docbookxsl/OtherOutputForms.html#StrictXhtmlValid
    -->
    <xsl:param name="css.decoration">0</xsl:param>
    <xsl:param name="ulink.target"></xsl:param>
    <xsl:param name="use.viewport">0</xsl:param>
    <!-- End of Strict Params -->    
    <xsl:param name="toc.section.depth">10</xsl:param> 
    <xsl:param name="generate.section.toc.level">10</xsl:param>
    <!-- Enable fop extensions - see:
    http://www.sagehill.net/docbookxsl/InstallingAnFO.html
    http://www.mail-archive.com/fop-users%40xmlgraphics.apache.org/msg06170.html
    -->
    <xsl:param name="fop1.extensions">1</xsl:param>

<!-- Insert some AdSense Ads -->
<xsl:template name="user.header.navigation">
    <div class="center ads_top">
    <script type="text/javascript">
google_ad_client = "pub-2480595666283917";
google_ad_width = 468;
google_ad_height = 60;
google_ad_format = "468x60_as";
google_ad_type = "text";
google_ad_channel ="";
google_color_border = "336699";
google_color_text = "000000";
google_color_bg = "FFFFFF";
google_color_link = "0000FF";
google_color_url = "008000";
</script>
<script type="text/javascript"
  src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
    </div>
</xsl:template>

<xsl:template name="user.header.content">
    <xsl:call-template name="user.header.navigation"/>
</xsl:template>
</xsl:stylesheet>
