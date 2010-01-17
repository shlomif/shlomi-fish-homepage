#!/bin/bash
quadp render -a -hd
quadp upload
ARC="Blitz-lecture.tar.gz"
tar -czvf "$ARC" hard-disk-html
rsync -r -v --progress "$ARC" $HOMEPAGE_SSH_PATH/lecture/W2L/Blitz/
