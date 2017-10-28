#!/usr/bin/perl

package Test::HTML::My;

use strict;
use warnings;
use 5.008;

our $VERSION = 'v0.0.3';

use Test::More;

use File::Find::Object::Rule;
use IO::All qw/ io /;
require HTML::TokeParser;

use MooX qw/ late /;

has filename_re => (
    is      => 'ro',
    default => sub {
        return qr/\.x?html\z/;
    }
);

has targets => ( is => 'ro', isa => 'ArrayRef', required => 1 );

has filename_filter => (
    is      => 'ro',
    default => sub {
        return sub { return 1; }
    }
);

sub run
{
    my $self = shift;
    plan tests => 1;
    local $SIG{__WARN__} = sub {
        my $w = shift;
        if ( $w !~ /\AUse of uninitialized/ )
        {
            die $w;
        }
        return;
    };

    my $error_count = 0;

    my $filename_re = $self->filename_re;
    my $filter      = $self->filename_filter;

    foreach my $target ( @{ $self->targets } )
    {
        for my $fn (
            File::Find::Object::Rule->file()->name($filename_re)->in($target) )
        {
            if ( $filter->($fn) )
            {
                my $p = HTML::TokeParser->new($fn);
            TOKENS:
                while ( my $token = $p->get_token )
                {
                    if ( $token->[0] eq 'S' or $token->[0] eq 'E' )
                    {
                        if ( 'tt' eq lc $token->[1] )
                        {
                            ++$error_count;
                            diag("tt tag found in $fn.");
                            last TOKENS;
                        }
                    }
                }
            }
        }
    }

    # TEST
    is( $error_count, 0, "No errors" );
}

1;

=pod

=head1 NAME

Test::HTML::Tidy::Recursive - recursively check files in a directory using
HTML::Tidy .

=head1 VERSION

version v0.0.3

=head1 SYNOPSIS

    use Test::HTML::Tidy::Recursive;

    Test::HTML::Tidy::Recursive->new({
        targets => ['./dest-html', './dest-html-production'],
        })->run;

Or with over-riding the defaults:

=cut

package main;

Test::HTML::My->new(
    {
        targets         => ['./dest'],
        filename_filter => sub {
            my $fn = shift;
            return (
                not(   $fn =~ m{js/MathJax}
                    or $fn =~
                    m#\A dest/t2/lecture/.*(?:Vim|Test-Run|Opt-Multi-Task)#x )
            );
        },
    }
)->run;
