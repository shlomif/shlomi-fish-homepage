#!/bin/bash
file="make_helpers/include.mak"
rm -f "$file"

newline()
{
    echo;
}

(
for host in t2 vipe ; do
    upper_host=`echo -n $host | tr a-z A-Z`
    
    echo -n "${upper_host}_DOCS = " ; ./find-wmls.sh "$host" ; echo
    newline
    echo "${upper_host}_DIRS = " $(find $host -type d | grep -v '/\.svn' | grep -v '^\.svn' | tail +2)
    newline
    echo "${upper_host}_IMAGES = " $(find $host -type f -not -name '*.wml' -not -name '.*' | grep -v '/\.svn' | grep -v '~$')
    newline
done;

echo "COMMON_IMAGES = " $(find common -type f -not -name '*.wml' -not -name '.*' | grep -v '/\.svn' | grep -v '~$')
newline
echo "COMMON_DIRS = " $(find common -type d | grep -v '/\.svn' | grep -v '^\.svn' | tail +2)

) >> "$file"

