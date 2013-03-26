#!/usr/bin/perl

use strict;
use warnings;

sub create_bank_account
{
    my $name = shift;
    my $total = 0;

    my $deposit = sub {
        my $how_much = shift;

        $total += $how_much;
    };

    my $print = sub {
        my $title = shift;

        print "$name has $total NIS.\n";
    };

    my $can_extract = sub {
        my $how_much = shift;

        if ($how_much <= 0)
        {
            return;
        }

        if ($total >= $how_much)
        {
            print "$name can afford to pay it!\n";
        }
        else
        {
            print "$name cannot afford to pay it!\n";
        }
    };

    my %ops =
        (
            "deposit" => $deposit,
            "print" => $print,
            "can_extract" => $can_extract,
        );

    my $dispatch = sub {
        my $op = shift;

        # Call the matching operation with the rest of the arguments.
        $ops{$op}->(@_);
    };

    return $dispatch;
}

# Create ten bank accounts
my @accounts = (map { create_bank_account("Person #".$_) } (0 .. 9));

while (my $line = <>)
{
    chomp($line);
    my @components = split(/\s+/, $line);
    my $account_index = shift(@components);
    my $op = shift(@components);

    $accounts[$account_index]->($op, @components);
}

# Usage:
# [Account Number] [Operation] [Parameters]
