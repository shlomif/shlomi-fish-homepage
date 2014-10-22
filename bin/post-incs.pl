#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my ($fn) = @ARGV;

sub _f
{
    return io->file($fn)->utf8;
}

my $text = _f()->all;

# In case there's an error - fail and need to rebuild.
_f()->unlink();

$text =~ s#^\({5}include "([^"]+)"\){5}\n#io->file("lib/$1")->utf8->all#egms;
$text =~ s#\({5}chomp_inc='([^']+)'\){5}#io->file("lib/$1")->chomp->utf8->getline("\n")#egms;

if ($ENV{F})
{
    foreach my $class (qw(info irc-conversation))
    {
        my $table_from = qq{<table class="$class">};
        my $table_to = qq{<table class="$class" summary="">};

        eval qq{\$text =~ s#\\Q$table_from\\E#$table_to#g};
    }
}

$text =~ s#(</div>|</li>|</html>)\n\n#$1\n#g;

_f()->print($text);
