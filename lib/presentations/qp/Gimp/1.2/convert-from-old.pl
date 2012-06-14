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
    open I, "<$filename";
    open O, ">$filename.wml";

    print O "#include 'template.wml'\n\n";
    my $text = join("", <I>);

    $text =~ s/<!--+ *& *begin_footer *-->.*?<!--+ *& *end_footer *--+>//s;
    $text =~ s/<!--+ *& *begin_header *-->.*?<!--+ *& *end_header *--+>//s;
    $text =~ s/<!--+ *& *begin_contents *-->.*?<!--+ *& *end_contents *--+>/<qpcontents \/>/gs;
    $text =~ s/<!--+ *& *begin_menupath *-->(.*?)<!--+ *& *end_menupath *--+>/<menupath>$1<\/menupath>/gs;

    print O $text;
    close(I);
    close(O);

}
