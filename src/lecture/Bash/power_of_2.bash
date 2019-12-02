#!/bin/bash

power_of_2()
{
    # Localize the current variables
    local exp result
    exp="$1"
    result=1
    # test a -gt b makes sure a is greater than b
    while test $exp -gt 0 ; do
        let result=result*2
        let exp--
    done
    echo $result
}
