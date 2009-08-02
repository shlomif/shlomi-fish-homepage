#!/bin/bash

cd rendered && rsync -r -v --progress --rsh=ssh * \
    $HOMEPAGE_SSH_PATH/lecture/Perl/Newbies/lecture4/
