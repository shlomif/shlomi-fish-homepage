#! /bin/sh
#
# common-env-shim.sh
# Copyright (C) 2021 Shlomi Fish < https://www.shlomifish.org/ >
#
# Distributed under the terms of the MIT license.
#
local_lib_shim() {
    eval "$(perl -Mlocal::lib=$HOME/perl_modules)";
    PATH="$PATH:$GOBIN:$GOPATH/bin:$HOME/go/bin";

    local trunk="`pwd`"
    local repo="$trunk/lib/repos/xslt10-stylesheets"
    _local_dbtoepub="$trunk/lib/repos/xslt10-stylesheets/xsl/epub/bin/dbtoepub"
    test -e "$_local_dbtoepub" || git submodule update --init --recursive
    if test -e "$_local_dbtoepub"
    then
        export DBTOEPUB="${DBTOEPUB:-/usr/bin/ruby $_local_dbtoepub}"
    fi
}
local_lib_shim ;
