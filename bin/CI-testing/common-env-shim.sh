#! /bin/sh
#
# common-env-shim.sh
# Copyright (C) 2021 Shlomi Fish < https://www.shlomifish.org/ >
#
# Distributed under the terms of the MIT license.
#
local_lib_shim() { eval "$(perl -Mlocal::lib=$HOME/perl_modules)"; PATH="$PATH:$GOBIN:$GOPATH/bin:$HOME/go/bin"; } ; local_lib_shim ;
