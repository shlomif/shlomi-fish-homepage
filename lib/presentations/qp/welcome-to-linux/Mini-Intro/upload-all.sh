#!/bin/bash
quadp render -a -hd
quadp upload
ARC="Mini-Intro.tar.gz"
tar -czvf "$ARC" hard-disk-html
rsync -r -v --progress "$ARC" $HOMEPAGE_SSH_PATH/lecture/W2L/Mini-Intro/
