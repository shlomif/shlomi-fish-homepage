#!/bin/sh

#### Backends: 
#
# Each Back-End is implemented as a function that receives 
# a processed and easier to analyze list of arguments.
#
# Note that the format used by the backends is internal and verbose
# and should not be exported

fetchweb_backend_wget()
{
    url="$1"
    shift
    wget_args=""
    LOOP=true
    while $LOOP ; do
        arg="$1"
        shift || break;        
        case $arg in
            --output-to-file)
            param="$1"
            shift
            # We already escaped $param
            wget_args="$wget_args -o $param"
            ;;
        esac
    done
    wget $wget_args    
}


# This function is used to make sure all the meta-characters in
# a variable that is passed to it are escaped.
#
# Security matters
escape_arg()
{
    arg="$1"
    echo "$arg" | sed 's/\([][\()'\''"`${}%@!*^&|:;,.? ]\)/\\\1/g'
}

parse_args()
{
    echo '$*=' $* 1>&2
    # LOOP is the condition for looping.
    # Once the URL is encountered it is set to false.
    # A poor man's break statement
    LOOP=true
    
    url_specified=true
    while $LOOP ; do
        echo "In LOOP" 1>&2
        if expr $# == 0 ; then
            echo "In Here3" 1>&2
            break
        fi        
        arg="$1"
        shift ;
        case "$arg" in

            -o)
            echo "In Here2" 1>&2
            param="$1"
            shift
            # %-)
            list="$list --output-to \"`escape_arg \"$param\"`\""
            ;;
            
            -*)
            echo "Unknown Param" 1>&2
            exit -1
            ;;
            
            *)
            # Put the URL first
            echo "In Here" 1>&2
            url_specified=false
            list="`escape_arg \"$arg\"` $list"
            LOOP=false
            ;;
            
        esac
    done
    if $url_specified ; then 
        (echo "No URL Specified!" ; echo "Panic!") 1>&2 ; 
        exit -1 
    fi
    echo "list=$list" 1>&2
    echo $list
}

backends="fetchweb_backend_wget"
processed_args="`parse_args $*`"
if test ! $? ; then
    echo OPOPOP 1>&2 
    exit
fi
echo "proc_args=$processed_args"
success="true"
# Now let's try all backends
for I in $backends ; do
    echo "I=$I"
    if $I $processed_args ; then
        success="false"
        break
    fi
done
$success

