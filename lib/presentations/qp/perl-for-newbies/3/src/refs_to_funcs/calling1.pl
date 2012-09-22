#!/usr/bin/perl

use strict;
use warnings;

# This is a value that can be input or output by the
# mini-interpreter.
my $a_value;

sub do_print
{
    if (!defined($a_value))
    {
        print STDERR "Error! The value was not set yet.\n";
        return;
    }

    print "\$a_value is " . $a_value . "\n";
}

sub do_input
{
    print "Please enter the new value:\n";
    my $line = <>;
    chomp($line);
    $a_value = $line;
}

my $quit_program = 0;

sub do_exit
{
    $quit_program = 1;
}

my %operations =
    (
        'print' => \&do_print,
        'input' => \&do_input,
        'exit' => \&do_exit,
    );

sub get_operation
{
    my $op = "";
    my $line;
    while (1)
    {
        print "Please enter the operation (print, input, exit):\n";
        $line = <>;
        chomp($line);
        if (exists($operations{$line}))
        {
            last;
        }
        else
        {
            print "Unknown operation!\n\n";
        }
    }

    return $line;
}

while (! $quit_program)
{
    my $op = get_operation();

    my $operation_ref = $operations{$op};

    $operation_ref->();
}
