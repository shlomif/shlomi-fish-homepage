<xsl:stylesheet
    exclude-result-prefixes="d"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:d="http://docbook.org/ns/docbook"
    version='1.0'
    >
    <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/xhtml/docbook.xsl" />
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
    <!--
    <xsl:param name="docmake.revhistory.remove">0</xsl:param>
    -->
    <!-- Enable fop extensions - see:
    http://www.sagehill.net/docbookxsl/InstallingAnFO.html
    http://www.mail-archive.com/fop-users%40xmlgraphics.apache.org/msg06170.html
    -->
    <xsl:param name="fop1.extensions">1</xsl:param>

<!-- Insert some adsense ads -->
<xsl:template name="user.header.navigation">
</xsl:template>

<xsl:template name="user.header.content">
    <xsl:call-template name="user.header.navigation"/>
</xsl:template>

<!-- Disable the title="" attribute in sections. -->
<xsl:template name="generate.html.title">
</xsl:template>

<xsl:template match="d:revhistory" mode="titlepage.mode">
    <xsl:if test="$docmake.revhistory.remove != 1">
  <xsl:variable name="numcols">
    <xsl:choose>
    
        g<xsl:when test=".//d:authorinitials|.//d:author">3</xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <xsl:variable name="title">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key">RevHistory</xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="contents">
    <div>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
      <table border="1" width="100%" summary="Revision history">
        <tr>
          <th align="{$direction.align.start}" valign="top" colspan="{$numcols}">
            
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'RevHistory'"/>
              </xsl:call-template>
            
          </th>
        </tr>
        <xsl:apply-templates mode="titlepage.mode">
          <xsl:with-param name="numcols" select="$numcols"/>
        </xsl:apply-templates>
      </table>
    </div>
  </xsl:variable>
  
  <xsl:choose>
    <xsl:when test="$generate.revhistory.link != 0">
      
      <!-- Compute name of revhistory file -->
      <xsl:variable name="file">
	<xsl:call-template name="ln.or.rh.filename">
	  <xsl:with-param name="is.ln" select="false()"/>
	</xsl:call-template>
      </xsl:variable>

      <xsl:variable name="filename">
        <xsl:call-template name="make-relative-filename">
          <xsl:with-param name="base.dir" select="$base.dir"/>
          <xsl:with-param name="base.name" select="$file"/>
        </xsl:call-template>
      </xsl:variable>

      <a href="{$file}">
        <xsl:copy-of select="$title"/>
      </a>

      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:with-param name="quiet" select="$chunk.quietly"/>
        <xsl:with-param name="content">
        <xsl:call-template name="user.preroot"/>
          <html>
            <head>
              <xsl:call-template name="system.head.content"/>
              <xsl:call-template name="head.content">
                <xsl:with-param name="title">
                    <xsl:value-of select="$title"/>
                    <xsl:if test="../../d:title">
                        <xsl:value-of select="concat(' (', ../../d:title, ')')"/>
                    </xsl:if>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="user.head.content"/>
            </head>
            <body>
              <xsl:call-template name="body.attributes"/>
              <xsl:copy-of select="$contents"/>
            </body>
          </html>
          <xsl:text>
</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$contents"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:if>
</xsl:template>

</xsl:stylesheet>
