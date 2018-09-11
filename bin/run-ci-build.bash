#! /bin/bash
#
# run-ci-build.bash
# Copyright (C) 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.
#
set -e
set -x
touch t2/philosophy/SummerNSA/Letter-to-SGlau-2014-10/*.{xhtml,pdf}
bash -x bin/travis-ci-script.bash
