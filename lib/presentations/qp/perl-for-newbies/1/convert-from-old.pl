#!/usr/bin/perl -w

use strict;

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

foreach my $filename (@files)
{
    open my $in, "<", $filename
        or die "Cannot open input file - $filename - $!";
    open my $out, ">", "$filename.wml"
        or die "Cannot open output file - $filename - $!";

    print {$out} "#include 'template.wml'\n\n";
    my $text = join("", <$in>);

    $text =~ s/<!--+ *& *begin_footer *-->.*?<!--+ *& *end_footer *--+>//s;
    $text =~ s/<!--+ *& *begin_header *-->.*?<!--+ *& *end_header *--+>//s;
    $text =~ s/<!--+ *& *begin_contents *-->.*?<!--+ *& *end_contents *--+>/<qpcontents \/>/gs;
    $text =~ s/<!--+ *& *begin_menupath *-->(.*?)<!--+ *& *end_menupath *--+>/<menupath>$1<\/menupath>/gs;

    print {$out} $text;
    close($in);
    close($out);

}
