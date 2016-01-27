#!/bin/bash
./bin/find-files-to-spell | xargs perl bin/html-check-spelling-xmlp.pl
exit 0
