#!/usr/local/gnu/bin/bash
if [ -e draft1.rtf ] ; then
	mv -f draft1.rtf pope_draft1.rtf
fi
if [ -e draft1.htm ] ; then
	mv -f draft1.htm pope_draft1.html
fi
