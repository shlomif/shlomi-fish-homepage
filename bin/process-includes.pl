#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

s#^\({5}include "([^"]+)"\){5}\n#io->file("lib/$1")->utf8->all#egms;

s#</div>\n\n#</div>\n#g;
