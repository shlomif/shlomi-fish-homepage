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
    $s =~ s{([\[\]])}{\\$1}g;

    return $s;
}

sub wrap_as_desc
{
    my $s = shift;
    return "\n\n[\n\n" . prefix_lines($s) . "\n\n]\n\n";
}

sub calc_new_para
{
    my $para = shift;

    if ($para !~ m{:} or $para =~ m{:\n?\z})
    {
        return wrap_as_desc($para);
    }
    else
    {
        return $para;
    }
}

sub process_scene
{
    my $s = shift;

    $s =~ s{^ +}{}gms;
    $s =~ tr/()/[]/;

    $s =~ s{^(\w[^\n]+\n)+}{calc_new_para($1)}egms;

    return $s;
}

my $END = '* * *      T  h  e      E  n  d      * * *';
$text =~ s{\A(.*?)^(SCENE 1:)}{wrap_as_desc($1) . $2}ems;
$text =~ 
s{^((?:SCENE (\d+)|EPILOGUE):[^\n]*\n(?: +[^\n]*\n)*)(.*?)(?=^(?:(?:SCENE|EPILOGUE)|(?:\s*\Q$END\E)))}
{
    # print "Foo <D1 = $1> <D2 = $2> <D3 = $3>"; 
    my $id = defined($2) ? $2 : "EPILOGUE"; 
    qq{\n\n<s id="scene_$id" title="Scene $id">\n\n}
    . wrap_as_desc($1) . "\n\n" . process_scene($3) .
    "\n\n</s>\n\n"
}egms;

$text =~ s{^(\s*\Q$END\E.*)\z}{
    qq{\n\n<s id="end" title="End">\n\n}
    . wrap_as_desc($1)
    . qq{\n\n</s>\n\n}
}ems;

io->file(
    'lib/screenplay-xml/txt/hitchhikers-guide-to-star-trek-tng.txt'
)->print(qq{<s id="top" title="The Hitchiker's Guide to Star Trek - The Next Generations">\n\n$text\n\n</s>});
