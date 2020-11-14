#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Path::Tiny qw/ path /;

my $text =
    path('t2/humour/by-others/hitchhiker-guide-to-star-trek-tng.txt')
    ->slurp_utf8;

sub prefix_lines
{
    my $s = shift;

    $s =~ s{^\s+}{}gms;
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

    if ( $para !~ m{:} or $para =~ m{:\n?\z} )
    {
        return wrap_as_desc($para);
    }
    else
    {
        $para =~ tr/()/[]/;
        return $para;
    }
}

sub process_scene
{
    my $s = shift;

    $s =~ s{^ +}{}gms;

    $s =~ s{(^\n)((?:[\w\*\"][^\n]+\n)+)}{$1.calc_new_para($2)}egms;

    return $s;
}

my $END = '* * *      T  h  e      E  n  d      * * *';
$text =~ s{\A(.*?)^(SCENE 1:)}{wrap_as_desc($1) . $2}ems;
$text =~
s{^(?<start_line>(?:SCENE (?<id>\d+)|EPILOGUE):[^\n]*\n(?: +[^\n]*\n)*)(?<body>.*?)(?=^(?:(?:SCENE|EPILOGUE)|(?:\s*\Q$END\E)))}
[
    my ($start_line, $id, $body) = @+{qw(start_line id body)};

    my $s_line =
        defined($id)
        ? qq{\n\n<s id="scene_$id" title="Scene $id">\n\n}
        : qq{\n\n<s id="epilogue" title="Epilogue">\n\n}
        ;

    $s_line
    . wrap_as_desc($start_line) . "\n\n" . process_scene($body)
    . "\n\n</s>\n\n"
]egms;

$text =~ s{^(\s*\Q$END\E.*)\z}{
    my $text = $1;
    $text =~ tr/[]/()/;
    qq{\n\n<s id="end" title="End">\n\n}
    . wrap_as_desc($text)
    . qq{\n\n</s>\n\n}
}ems;

path('lib/screenplay-xml/txt/hitchhikers-guide-to-star-trek-tng.txt')
    ->spew_utf8(
qq{<s id="top" title="The Hitchhiker's Guide to Star Trek - The Next Generation">\n\n$text\n\n</s>}
    );
