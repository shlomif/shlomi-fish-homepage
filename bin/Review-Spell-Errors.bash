#!/bin/bash
make -j8
bash bin/spell-checker-iface.sh | perl -pE 's/«/[/g ; s/»/]/g; ' > foo.txt
