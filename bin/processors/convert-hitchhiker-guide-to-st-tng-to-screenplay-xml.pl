#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use IO::All;

my $text =
    io->file('t2/humour/by-others/hitchhiker-guide-to-star-trek-tng.txt')->slurp;

sub prefix_lines
{
    my $s = shift;

    $s =~ s{^}{// }gms;
    $s =~ s{$}{<br />}gms;

    return $s;
}

sub wrap_as_desc
{
    my $s = shift;
    return '[' . prefix_lines($s) . "]\n\n";
}

sub process_scene
{
    my $s = shift;

    $s =~ s{^ +}{}gms;
    $s =~ tr/()/[]/;

    return $s;
}

my $END = '* * *      T  h  e      E  n  d      * * *';
$text =~ s{\A(.*?)^(SCENE 1:)}{wrap_as_desc($1) . $2}ems;
$text =~ 
s{^((?:SCENE (\d+)|EPILOGUE):[^\n]*\n(?: +[^\n]*\n)*)(.*?)(?=^(?:(?:SCENE|EPILOGUE)|(?:\s*\Q$END\E)))}
{
    # print "Foo <D1 = $1> <D2 = $2> <D3 = $3>"; 
    my $id = defined($2) ? $2 : "EPILOGUE"; 
    qq{\n\n<scene id="scene_$id" title="Scene $id">\n\n}
    . "[\n" . prefix_lines($1)
    . "\n]\n\n" . process_scene($3) .
    "\n\n</scene>\n\n"
}egms;

$text =~ s{^(\s*\Q$END\E.*)\z}{wrap_as_desc($1)}ems;

print($text);
