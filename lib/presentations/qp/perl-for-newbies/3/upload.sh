#!/bin/bash

cd rendered && rsync -r -v --progress --rsh=ssh * \
    $HOMEPAGE_SSH_PATH/Vipe/lecture/Perl/Newbies/lecture3/
