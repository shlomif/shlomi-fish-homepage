#!/bin/bash

# Example use is:
#
# bash bin/diff-fiction-xml-and-screenplay-xml.bash 2013-04-09 2013-04-26

start_date="$1"
shift
end_date="$1"
shift

function _get_date()
{
    local d="$1"
    shift
    local empty=4b825dc642cb6eb9a060e54bf8d69288fbee4904
    local sha1="$(git rev-list --max-parents=0 --since="$d" HEAD | tail -1)"
    echo "${sha1:-$empty}"
}

ls -d lib/fiction-xml/from-vcs/* lib/screenplay-xml/from-vcs/* |
    grep -v PLACE |
    (while read repo ; do
        (
            echo "==== Diff for $repo ===="
            cd "$repo"
            # git diff updated-"$start_date"..updated-"$end_date" 2>&1 | cat
            # git diff master@'{'"$start_date"\ 03:00:00'}'..master@'{'"$end_date"\ 03:00:00'}' 2>&1 | cat
            git diff "$(_get_date "$start_date")".."$(_get_date "$end_date")" 2>&1 | cat
        )
    done
    )
