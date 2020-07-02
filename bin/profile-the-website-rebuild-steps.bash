#!/usr/bin/env bash

# Copyright 2020 Shlomi Fish ( https://www.shlomifish.org/ )
# Author: Shlomi Fish ( https://www.shlomifish.org/ )
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

(
    set -e -x
    git clean -dfqx .
    (
        LATEMP_STOP_GEN=1 ./gen-helpers
    )
    (
        unset DISPLAY
        LATEMP_PROFILE=1 perl -d:NYTProf bin/gen-sect-nav-menus.pl
    )
    nytprofhtml --no-flame
    sky -x up-r nytprof/
)
notifier notify --msg "nytprof for website has finished"
