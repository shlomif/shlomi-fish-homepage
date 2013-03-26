#!/bin/bash
rsync -a -v --progress --rsh=ssh 2013-03-23.html \
    "$__HOMEPAGE_REMOTE_PATH"/enough-with-sec/
