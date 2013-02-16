# Makefile
#
# Makefile for resumes
#
# Copyright (c) 2002 Bruce Christensen
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

#------------------------------------------------------------------------------
# To create example.html, example.txt, example.fo, and example.pdf from
# example.xml, with Italian localization and a4 paper size, use this command:
#
# 	gmake resume=example country=it papersize=a4
#
# To generate just the html version of cv.xml with UK localization, use this
# command:
#
# 	gmake html resume=cv country=uk
#
# To remove all generated files, run:
#
# 	gmake clean
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Basename (filename minus .xml extension) of resume to process
# For example, put "myresume" here to process "myresume.xml".
#------------------------------------------------------------------------------
resume = resume

#------------------------------------------------------------------------------
# Stylesheets
#------------------------------------------------------------------------------
# Options: br de fr it nl uk us es
country = us
# Options: letter for country=us, a4 for others
papersize = letter

xsl_base = http://xmlresume.sourceforge.net/xsl
#xsl_base = ../xsl
#xsl_base = ../src/www/xsl

html_style = $(xsl_base)/output/$(country)-html.xsl
text_style = $(xsl_base)/output/$(country)-text.xsl
fo_style = $(xsl_base)/output/$(country)-$(papersize).xsl
upgrade_13x_140_style = $(xsl_base)/misc/13x-140.xsl

#------------------------------------------------------------------------------
# Processing software
#------------------------------------------------------------------------------
make = gmake

xsl_proc = java org.apache.xalan.xslt.Process $(xsl_flags) -in $(in) -xsl $(xsl) -out $(out)
#xsl_proc = java com.icl.saxon.StyleSheet $(xsl_flags) -o $(out) $(in) $(xsl) $(xsl_params)

pdf_proc = java org.apache.fop.apps.Fop -fo $(fo_flags) $(in) -pdf $(out)
#pdf_proc = ~/bin/xep/run.sh $(fo_flags) $(in) $(out)

# RTF generation currently requires you download a separate, closed source jar
# file and add it to your java classpath:
# http://www.xmlmind.com/foconverter/downloadperso.shtml
rtf_proc = java com.xmlmind.fo.converter.Driver $(in) $(out)
#rtf_proc = java ch.codeconsult.jfor.main.CmdLineConverter $(in) $(out)

# Element filtering allows you to create targeted resumes.
# You can create your own targets; just specify them in your resume.xml
# file with the "targets" attribute.  In this example, the foodservice
# AND carpentry elements will be included in the output, but not the
# elements targeted to other jobs.  Untargeted elements (those with no
# "targets" attribute) are always included.
# Take a look at example2.xml and try changing the filter targets to get a
# feel for how the filter works.
filter_targets = foodservice carpentry
filter_proc = java net.sourceforge.xmlresume.filter.Filter -in $(in) -out $(out) $(filter_targets)

#------------------------------------------------------------------------------
# End configurable parameters
#------------------------------------------------------------------------------

.PHONY: all html text fo pdf clean 13x-140

all: html text fo pdf
html: $(resume).html
text: $(resume).txt
fo: $(resume).fo
pdf: $(resume).pdf
13x-140: $(resume)-140.xml
rtf: $(resume).rtf
filter: $(resume)-filtered.xml

clean:
	rm -f $(resume).html
	rm -f $(resume).txt
	rm -f $(resume).fo
	rm -f $(resume).pdf
	rm -f $(resume).rtf
	rm -f $(resume)-filtered.xml
	rm -f $(resume)-filtered.html
	rm -f $(resume)-filtered.txt
	rm -f $(resume)-filtered.pdf
	rm -f $(resume)-filtered.fo
	rm -f $(resume)-filtered.rtf

$(resume).html: in = $(resume).xml
$(resume).html: out = $(resume).html
$(resume).html: xsl = $(html_style)
$(resume).html: $(resume).xml
	$(xsl_proc)

$(resume).txt: in = $(resume).xml
$(resume).txt: out = $(resume).txt
$(resume).txt: xsl = $(text_style)
$(resume).txt: $(resume).xml
	$(xsl_proc)

$(resume).fo: in = $(resume).xml
$(resume).fo: out = $(resume).fo
$(resume).fo: xsl = $(fo_style)
$(resume).fo: $(resume).xml
	$(xsl_proc)

$(resume).pdf: in = $(resume).fo
$(resume).pdf: out = $(resume).pdf
$(resume).pdf: $(resume).fo
	$(pdf_proc)

$(resume).rtf: in = $(resume).fo
$(resume).rtf: out = $(resume).rtf
$(resume).rtf: $(resume).fo
	$(rtf_proc)

$(resume)-140.xml: in = $(resume).xml
$(resume)-140.xml: out = $(resume)-140.xml
$(resume)-140.xml: xsl = $(upgrade_13x_140_style)
$(resume)-140.xml: $(resume).xml
	$(xsl_proc)

$(resume)-filtered.xml: in = $(resume).xml
$(resume)-filtered.xml: out = $(resume)-filtered.xml
$(resume)-filtered.xml: $(resume).xml
	$(filter_proc)
	$(make) all resume=$(resume)-filtered
