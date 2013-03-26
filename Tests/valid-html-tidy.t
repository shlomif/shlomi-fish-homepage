#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use HTML::Tidy;
use File::Find::Object::Rule;
use IO::All;

local $SIG{__WARN__} = sub {
    my $w = shift;
    if ($w !~ /\AUse of uninitialized/)
    {
        die $w;
    }
    return;
};

my $tidy = HTML::Tidy->new({ output_xhtml => 1, });
$tidy->ignore( type => TIDY_WARNING, type => TIDY_INFO );

my $error_count = 0;

for my $fn (File::Find::Object::Rule->file()->name(qr/\.x?html\z/)->in("./dest"))
{
    if (not ($fn =~ m{js/MathJax}
                or $fn =~ m{\Adest/t2-homepage/MathVentures/}))
    {
        $tidy->parse( $fn, (scalar io->file($fn)->slurp()));

        for my $message ( $tidy->messages ) {
            $error_count++;
            diag( $message->as_string);
        }
    }
}

# TEST
is ($error_count, 0, "No errors");
