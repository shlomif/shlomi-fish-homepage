#!/bin/bash

power()
{
    local exp result base
    base="$1"
    shift  # Shift shifts the $n numbers making $1 $2, $2 $3, etc.
    exp="$1"
    result=1
    while test $exp -gt 0 ; do
        # (( ... )) is a different notation for let
        ((result *= base))
        ((exp--))
    done
    echo $result
}
