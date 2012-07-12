#!/usr/bin/perl

use strict;
use warnings;

use File::Find;

my $dir = shift || ".";
find(\&wanted, $dir);

my (@files);
sub wanted
{
    if (/\.html$/)
    {
        push @files, $File::Find::name;
    }
}

sub _slurp
{
    my $filename = shift;

    open my $in, "<", $filename
        or die "Cannot open '$filename' for slurping - $!";

    local $/;
    my $contents = <$in>;

    close($in);

    return $contents;
}

foreach my $filename (@files)
{
    my $text = _slurp($filename);

    open my $out, ">", "$filename.wml"
        or die "Could not open '$filename.wml' - $!";

    print {$out} "#include 'template.wml'\n\n";

    $text =~ s/<!--+ *& *begin_footer *-->.*?<!--+ *& *end_footer *--+>//s;
    $text =~ s/<!--+ *& *begin_header *-->.*?<!--+ *& *end_header *--+>//s;
    $text =~ s/<!--+ *& *begin_contents *-->.*?<!--+ *& *end_contents *--+>/<qpcontents \/>/gs;
    $text =~ s/<!--+ *& *begin_menupath *-->(.*?)<!--+ *& *end_menupath *--+>/<menupath>$1<\/menupath>/gs;

    print {$out} $text;

    close($out);
}
