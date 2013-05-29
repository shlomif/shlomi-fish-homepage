#!/bin/sh

echo "Please enter a number:"
read A

if expr $A \> 1000 > /dev/null ; then
	echo "$A is greater than one thousand"
elif expr $A \> 100 > /dev/null ; then
	echo "$A is greater than one hundred"
else
	echo "$A is lesser or equal to one hundred"
fi

