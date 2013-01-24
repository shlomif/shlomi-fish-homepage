# Makefile
#
# Makefile for resumes
#
# Copyright (c) 2000-2001 Sean Kelly
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the
#    distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#------------------------------------------------------------------------
# Replace this with the basename (no .xml extension) of your resume
# source file.  In this example, my resume is in "example.xml", so I
# put "example" here.
# This can also be passed on the command line: "make RESUME=canada".
#
RESUME = usa
#
#------------------------------------------------------------------------

# uncomment these lines - and set STYLEDIR appropriately - to use a local
# installation.
#STYLEDIR=file:/usr/local/cvs/resume/src/www/xsl
#HTML_STYLE = $(STYLEDIR)/us-html.xsl
#FO_STYLE = $(STYLEDIR)/us-letter.xsl
#TXT_STYLE = $(STYLEDIR)/us-text.xsl

# otherwise, use the published versions over the net.
HTML_STYLE = http://xmlresume.sourceforge.net/xsl/html.xsl
FO_STYLE = http://xmlresume.sourceforge.net/xsl/fo.xsl
TXT_STYLE = http://xmlresume.sourceforge.net/xsl/text.xsl

# The Java virtual machine.  If it's in your $PATH, you only need
# the first version; if it isn't you'll need to specify the full path.
JAVACMD=java
#JAVACMD=/usr/jdk1.3.0_02/bin/java

# You may need to uncomment this and have it point to your Fop installation.
#CLASSPATH = /usr/local/Fop/lib/xalan-2.0.0.jar:/usr/local/Fop/xerces-1.2.3.jar:/usr/local/Fop/fop.jar

# End of configurable parameters.

.PHONY: all clean
.SUFFIXES: .html .fo .pdf .xml .xsl .txt


HDRFMT=-param header.format standard

RESUMES=usa canada italy norway

# Define the address format.  Need one of these lines for each
# .xml source file.
brazil_format = european
canada_format = standard
ireland_format = standard
italy_format = italian
norway_format = european
nz_format = standard
uk_format = standard
untagged_format = standard
usa_format = standard

all:	$(RESUME).html $(RESUME).pdf $(RESUME).txt 

clean:
	-rm -f $(RESUME).html $(RESUME).pdf $(RESUME).fo $(RESUME).txt *~


%.html: %.xml
	$(JAVACMD) -cp $(CLASSPATH) org.apache.xalan.xslt.Process -in $< -xsl $(HTML_STYLE) -out $@ $(HDRFMT) -param address.format $($*_format)

%.txt: %.xml
	$(JAVACMD) -cp $(CLASSPATH) org.apache.xalan.xslt.Process -in $< -xsl $(TXT_STYLE) -out $@ $(HDRFMT) -param address.format $($*_format)

%.fo: %.xml
	$(JAVACMD) -cp $(CLASSPATH) org.apache.xalan.xslt.Process -in $< -xsl $(FO_STYLE) -out $@ $(HDRFMT) -param address.format $($*_format)

%.pdf: %.fo
	$(JAVACMD) -cp $(CLASSPATH) org.apache.fop.apps.Fop $< $@

