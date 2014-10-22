#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

s#^\({5}include "([^"]+)"\){5}\n#io->file("lib/$1")->utf8->all#egms;

s#(</div>|</li>|</html>)\n\n#$1\n#g;
