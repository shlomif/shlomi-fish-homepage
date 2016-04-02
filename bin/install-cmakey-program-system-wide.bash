#!/bin/bash

set -x

a="$1"
shift
v="$1"
shift
baseurl="$1"
shift
b="$a-$v"
arc="$b.tar.xz"
( wget "$baseurl/$arc" && tar -xvf "$arc" && cd "$b" && mkdir b && cd b && cmake .. && make && sudo make install ) || exit -1
# Cleanup to avoid trailing space problems.
rm -f "$arc"
rm -fr "$b"
