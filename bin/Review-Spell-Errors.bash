#!/bin/bash
make -j8
./bin/spell-checker-iface | perl -pE 's/«/[/g ; s/»/]/g;' > foo.txt
