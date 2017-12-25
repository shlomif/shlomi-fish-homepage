#!/bin/sh
mode="$1"        # $n are the command line parameters
dir="$2"
dir_mode=`echo $mode | tr 46 57`  # tr substitutes byte for byte
find "$dir" -type d | xargs chmod $dir_mode
find "$dir" -not -type d | xargs chmod $mode
