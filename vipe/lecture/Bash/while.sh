#!/bin/sh

A=1
while expr $A \<= 100 > /dev/null ; do
	echo $A
	A=`expr $A + 1`
done
