<?xml version="1.0" encoding="iso-8859-15"?>

<!--
es.xsl
Parameters for Spanish resumes.

Copyright (c) 2002 Miguel Coca <mcoca@users.sourceforge.net>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the
   distribution.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

$Id: es.xsl,v 1.3 2002/11/18 23:05:03 brandondoyle Exp $
-->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="resume.word">Curriculum Vitae</xsl:param>
  <xsl:param name="page.word">p&aacute;gina</xsl:param>
  <xsl:param name="contact.word">Informaci�n de contacto</xsl:param>
  <xsl:param name="objective.word">Objetivo</xsl:param>
  <xsl:param name="history.word">Experiencia</xsl:param>
  <xsl:param name="academics.word">Formaci�n</xsl:param>
  <xsl:param name="publications.word">Publicaciones</xsl:param>
  <xsl:param name="miscellany.word">Otros</xsl:param>
  <xsl:param name="in.word">en</xsl:param>
  <xsl:param name="copyright.word">Copyright &#169;</xsl:param>
  <xsl:param name="by.word">por</xsl:param>
  <xsl:param name="present.word">Actualidad</xsl:param>

  <xsl:param name="phone.word">Tel&eacute;fono</xsl:param>
  <xsl:param name="fax.word">Fax</xsl:param>
  <xsl:param name="phone.home.phrase"><xsl:value-of select="$phone.word"/></xsl:param>
  <xsl:param name="phone.work.phrase"><xsl:value-of select="$phone.word"/> del Trabajo</xsl:param>
  <xsl:param name="phone.mobile.phrase"><xsl:value-of select="$phone.word"/> M&oacute;vil</xsl:param>
  <xsl:param name="fax.home.phrase"><xsl:value-of select="$fax.word"/></xsl:param>
  <xsl:param name="fax.work.phrase"><xsl:value-of select="$fax.word"/> del Trabajo</xsl:param>

  <xsl:param name="email.word">Email</xsl:param>
  <xsl:param name="url.word">URL</xsl:param>
  <xsl:param name="achievements.word">Logros:</xsl:param>
  <xsl:param name="projects.word">Proyectos:</xsl:param>

  <!-- default to European address formatting -->
  <xsl:param name="address.format">european</xsl:param>

  <xsl:param name="and.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="awards.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.aim.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.icq.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.irc.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.jabber.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.msn.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="im.yahoo.service">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="interests.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="last-modified.phrase">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="major-gpa.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="minor.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="minors.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="out-of.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="overall-gpa.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="pager.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="referees.hidden.phrase">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="referees.word">TRANSLATION NEEDED</xsl:param>
  <xsl:param name="security-clearances.word">TRANSLATION NEEDED</xsl:param>
</xsl:stylesheet>

