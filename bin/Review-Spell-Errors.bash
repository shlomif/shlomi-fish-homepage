#!/bin/bash
gmake -j8
./bin/spell-checker-iface | perl -pE 's/«/[/g ; s/»/]/g;' > foo.txt
