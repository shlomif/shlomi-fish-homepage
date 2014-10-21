#!/bin/bash

RSYNC="rsync --progress --verbose --rsh=ssh"

$RSYNC -r dest/ $HOMEPAGE_SSH_PATH/lecture/WebMetaLecture/rendered/bolding/

