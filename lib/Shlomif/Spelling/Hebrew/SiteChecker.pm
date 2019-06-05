package Shlomif::Spelling::Hebrew::SiteChecker;

use strict;
use warnings;
use autodie;
use utf8;

use 5.014;

use MooX qw/late/;

extends('HTML::Spelling::Site::Checker');

sub should_check
{
    my ( $self, $args ) = @_;
    return ( $args->{word} =~ m#\A[\p{Hebrew}\-'’]+\z# );
}

1;
