#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

s#^\({5}include "([^"]+)"\){5}\n#io->file("lib/$1")->utf8->all#egms;
s#\({5}chomp_inc='([^']+)'\){5}#io->file("lib/$1")->chomp->utf8->getline("\n")#egms;

if ($ENV{F})
{
    foreach my $class (qw(info irc-conversation))
    {
        my $table_from = qq{<table class="$class">};
        my $table_to = qq{<table class="$class" summary="">};

        eval qq{s#\\Q$table_from\\E#$table_to#g};
    }
}

s#(</div>|</li>|</html>)\n\n#$1\n#g;
