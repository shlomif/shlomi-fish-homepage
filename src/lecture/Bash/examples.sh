#!/bin/bash

for I in * ; do
    cp "$I" "$I.bak"
done

# And the opposite
for I in *.bak ; do
    cp -f "$I" "${I%.bak}"
done

# ${paramter%word} is a Bash extension that removes the suffix from the
# parameter. For more information consult the bash man page or
# http://www.tldp.org/LDP/abs/html/parameter-substitution.html
#
# Let's define a tag <bashguide "page"/> ==>
# http://www.tldp.org/LDP/abs/html/page.html
# <bashguide "parameter-substitution"/>

# Or in pure Bourne Shell
for I in *.bak ; do
    cp -f "$I" "`echo "$I" | sed 's/\.bak$//'`"
done



# A pipeline
ls -l | grep '^d' | wc -l

# If filenames contain newlines followed by d characters this snippet may not
# work. A correct one is:

count=0
for I in * ; do
    if [ -d "$I" ] ; then
       let count++
    fi
done

# if is a conditional
# [ is equivalent to the traditional test and evaluates several expressions
# let does arithmetics

# Or in pure Bourne
count=0
for I in * ; do
    if test -d "$I" ; then
        count=`expr $count + 1`
    fi
done

# expr is a command line integral calculator


#!/bin/sh
mode="$1"        # $n are the command line parameters
dir="$2"
dir_mode=`echo $mode | tr 46 57`  # tr substitutes byte for byte
# find traverses a directory tree and performs a test for entry
#
# -type d -print tells it to echo the name if the file is a directory
#
# xargs is a GNU extension that collects the standard input and passes
# it to a command on the command line
find "$dir" -type d -print | xargs chmod $dir_mode
# -not -type d -print will echo the filename if the file
# is not a directory
find "$dir" -not -type d -print | xargs chmod $mode

#<------------------->

# File : qp_render.sh

# This script searches the current directory and subsequent directores
# above it for an excutable named Render_all_contents.pl. If it
# find it it stops and executed it.

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

#<---------------------->

# Functions:

# A function is a built-in command that is evaluated in the same
# process space where it is called.
#
# It is useful to set environment variables and other internal settings
# of the shell.

switch_cvs()
{
    which="$1"
    if [ "$which" == "fcs" ] ; then
        export CVS_RSH=ssh
        export CVSROOT=":pserver:shlomif@cvs.fc-solve.berlios.de:/cvsroot/fc-solve";
    # elif is an else if construct
    elif [ "$which" == "localhost" ] ; then
        unset CVS_RSH
        export CVSROOT=":pserver:shlomi@localhost:/var/cvsroot"
    elif [ "$which" == "ip-noise" ] ; then
        export CVS_RSH=ssh
        export CVSROOT=":pserver:shlomif@cvs.ip-noise.berlios.de:/cvsroot/ip-noise"
    elif [ "$which" == "sct" ] ; then
        export CVS_RSH=ssh
        export CVSROOT=":ext:shlomif@cvs.syscalltrack.sourceforge.net:/cvsroot/syscalltrack"
    elif [ "$which" == "seminars" ] ; then
        export CVS_RSH=ssh
        export CVSROOT=":pserver:shlomif@cvs.semiman.berlios.de:/cvsroot/semiman"
    elif [ "$which" == "humanity" ] ; then
        export CVS_RSH=ssh
        export CVSROOT=":pserver:shlomif@cvs.humanity.berlios.de:/cvsroot/humanity"
    else
        echo "Unknown CVS profile \"$which\"!"
    fi
}

#<-------------------------------->

# A case statement.
# A case statement matches a string against several possible patterns until
# the first one is matched. then it executes the commands relevant to that
# pattern.
#
# Here is the previous function implemented with a case statement:

switch_cvs_case()
{
    which="$1"
    case "$which" in
        fcs)

        export CVS_RSH=ssh
        export CVSROOT=":pserver:shlomif@cvs.fc-solve.berlios.de:/cvsroot/fc-solve"
        ;; # Two semicolons terminate a pattern block

    # elif is an else if construct
        localhost)
        unset CVS_RSH
        export CVSROOT=":pserver:shlomi@localhost:/var/cvsroot"
        ;;

        ip-noise)

        export CVS_RSH=ssh
        export CVSROOT=":pserver:shlomif@cvs.ip-noise.berlios.de:/cvsroot/ip-noise"
        ;;

        sct)
        export CVS_RSH=ssh
        export CVSROOT=":ext:shlomif@cvs.syscalltrack.sourceforge.net:/cvsroot/syscalltrack"
        ;;

        seminars)
        export CVS_RSH=ssh
        export CVSROOT=":pserver:shlomif@cvs.semiman.berlios.de:/cvsroot/semiman"
        ;;
        humanity)
        export CVS_RSH=ssh
        export CVSROOT=":pserver:shlomif@cvs.humanity.berlios.de:/cvsroot/humanity"
        ;;

        *) # * matches anything
        echo "Unknown CVS profile \"$which\""'!' # ! has to be escaped with single quotes
        ;;
    esac # esac (the reverse of case) ends a case statement
}

#<------------------------>

# while read:

find . -name '*.c' -print |
    (while read T ; do
        cp "$T" "$T.bak"
     done)

#<----------------------->

# power of 2 demo

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

#<---------------->

# power of a base and an exponent

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
