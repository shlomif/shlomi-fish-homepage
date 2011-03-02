#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my $text =
    io->file('t2/humour/by-others/hitchhiker-guide-to-star-trek-tng.txt')->slurp;

sub prefix_lines
{
    my $s = shift;

    $s =~ s{^}{\\#}ms;
    $s =~ s{$}{<br />}ms;

    return $s;
}

sub process_scene
{
    my $s = shift;

    $s =~ s{^ +}{};
    $s =~ tr/()/[]/;

    return $s;
}

my $END = '* * *      T  h  e      E  n  d      * * *';
$text =~ s{\A(.*?)^(SCENE 1:)}{[prefix_lines($1)]\n\n$2}ms;
$text =~ 
s{^((?:SCENE (\d+)|EPILOGUE):[^\n]*\n(?: +[^\n]*\n))(.*?)(?=^(?:(?:SCENE)|(?:\Q$END\E)))}
{my $id = defined($2) ? $2 : "EPILOGUE"; 
    qq{<scene id="scene_$id" title="Scene $id">\n\n}
    . "[\n" . prefix_lines($1)
    . "\n]\n\n" . process_scene($3)
    . "</scene>"
}egms;

print($text);
