#!/bin/bash
rsync -v --progress -r ./rendered/* --rsh=ssh "${HOMEPAGE_SSH_PATH}/lecture/Perl/Newbies/lecture1/"

