#!/bin/sh

find . -name '*.c' |
(while read T ; do
	cp $T $T.bak ;
 done)
