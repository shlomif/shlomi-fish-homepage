#!/usr/bin/perl

use strict;
use warnings;
use autodie;

use XML::LibXML;
use XML::LibXML::XPathContext;
use Getopt::Long;
use IO::All;

my $out_fn;

GetOptions(
    "output|o=s" => \$out_fn,
);

# Input the filename
my $filename = shift(@ARGV)
    or die "Give me a filename as a command argument: myscript FILENAME";

sub _slurp
{
    my $filename = shift;

    open my $in, "<", $filename
        or die "Cannot open '$filename' for slurping - $!";

    binmode $in, ":encoding(utf-8)";

    local $/;
    my $contents = <$in>;

    close($in);

    return $contents;
}

{
    my $s = _slurp($filename);

    $s =~ s{\A.*?<body[^>]*>}{}sm;
    $s =~ s{</body>.*\z}{}ms;

    # It's a kludge
    $s =~ s{ lang="en"}{}g;
    $s =~ s{ xml:lang="en"}{}g;
    $s =~ s{ type="(?:1|disc)"}{}g;
    $s =~ s{<hr[^/]*/>}{<hr />}g;
    $s =~ s{ target="_top"}{}g;

    # Fixed in Perl 6...
    $s =~ s{<(/?)h(\d)}{"<".$1."h".($2+2)}ge;

    $s =~ s/[ \t]+$//gms;
    open my $out, ">", $out_fn;
    binmode $out, ":utf8";
    print {$out} $s;
    close($out);
}

