#!/bin/bash

# while loops until the condition is false
# -x means the script is an executable
# != is string comparison
# -a is a logical and operation
# ! is a logical not operation
#
# The variable $PWD holds the current directory
while [ ! -x Render_all_contents.pl -a "$PWD" != "/" ] ; do
    cd ..
done
if [ -x Render_all_contents.pl ] ; then
    ./Render_all_contents.pl
fi
