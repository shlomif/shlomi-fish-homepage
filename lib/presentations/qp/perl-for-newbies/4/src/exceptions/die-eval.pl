#!/usr/bin/perl

use strict;
use warnings;


sub read_text
{
    my $filename = "../hello/there.txt" ;
    open I, "<$filename"
        or die "Could not open $filename";
    my $text = join("",<I>);
    close(I);

    return $text;
}

sub write_text
{
    my $text = shift;
    my $filename = "../there/hello.txt";
    open O, ">$filename"
        or die "Could not open $filename for writing";
    print O $text;
    close(O);
}

sub read_and_write
{
    my $text = read_text();

    write_text($text);
}

sub perform_transaction
{
    eval {
    read_and_write();
    };
    if ($@)
    {
        print "Could not perform the transaction. Reason is:\n$@\n";
    }
}

perform_transaction();

