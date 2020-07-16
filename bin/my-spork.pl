#! /usr/bin/env perl
#
# Run spork - my way
#
# Author Shlomi Fish <shlomif@cpan.org>
# Version 0.0.1
#
use strict;
use warnings;
use 5.014;
use autodie;

use Spork::Shlomify ();

local $SIG{__WARN__} = sub {
    my $w = shift;
    warn $w if $w !~ m{\A(?:Creating slides|Slideshow created!)};
    return;
};

Spork::Shlomify->new->load_hub->command->process(@ARGV);
