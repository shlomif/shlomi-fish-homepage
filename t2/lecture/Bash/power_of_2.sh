#!/bin/sh

# power_of_2 in pure Bourne
power_of_2()
{
    # Localize the current variables
    local exp result
    exp="$1"
    result=1
    # test a -gt b makes sure a is greater than b
    while test $exp -gt 0 ; do
        result=`expr $result \* 2`
        exp=`expr $exp - 1`
    done
    echo $result
}
