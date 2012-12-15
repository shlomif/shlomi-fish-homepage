#!/bin/bash
rsync -a -v --progress --rsh=ssh 2011-05-27.html \
    "$__HOMEPAGE_REMOTE_PATH"/enough-with-sec/
