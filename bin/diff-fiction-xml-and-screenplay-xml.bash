#!/bin/bash

# Example use is:
#
# bash bin/diff-fiction-xml-and-screenplay-xml.bash 2013-04-09 2013-04-26

start_date="$1"
shift
end_date="$1"
shift

ls -d lib/fiction-xml/from-vcs/* lib/screenplay-xml/from-vcs/* |
    grep -v PLACE |
    (while read repo ; do
        (
            echo "==== Diff for $repo ===="
            cd "$repo"
            # git diff updated-"$start_date"..updated-"$end_date" 2>&1 | cat
            git diff master@'{'"$start_date"\ 03:00:00'}'..master@'{'"$end_date"\ 03:00:00'}' 2>&1 | cat
        )
    done
    )
