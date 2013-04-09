#!/bin/bash
rsync -a -v --progress --rsh=ssh 2013-04-09.html \
    "$__HOMEPAGE_REMOTE_PATH"/enough-with-sec/
