#!/bin/bash

RSYNC="rsync --progress --verbose --rsh=ssh"

$RSYNC index.html answers.html $HOMEPAGE_SSH_PATH/lecture/WebMetaLecture/rendered/faq-l/

