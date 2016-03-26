#!/bin/bash

# My current date - e.g: bash Fiction-Git-Tag-Me.bash "$(date +%Y-%m-%d)"
my_cur="$1"
shift

# git tag -m "Tagging as updated on $my_start" updated-"$my_start" "$rev"
git tag -m "Tagging as updated on $my_cur" updated-"$my_cur"
