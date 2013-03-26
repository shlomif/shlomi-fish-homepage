#!/bin/sh

# cssClasses -- create a list of all available css classes.
# If you do not have a Unix environment available, please look
# at cssClasses.txt for a (possibly outdated) list.

perl -p -e 's/class\=\"([a-zA-Z]*)\"\>/\nXXXX $1\n/mg' ../xsl/format/html.xsl | grep XXXX | sort | uniq | awk '{print $2}'
