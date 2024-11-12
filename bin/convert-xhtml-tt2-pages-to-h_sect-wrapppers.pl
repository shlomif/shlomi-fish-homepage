#! /usr/bin/env perl
#
# Short description for convert-xhtml-tt2-pages-to-h_sect-wrapppers.pl
#
# Version 0.0.1
# Copyright (C) 2024 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Carp                                   qw/ confess /;
use Getopt::Long                           qw/ GetOptions /;
use Path::Tiny                             qw/ cwd path tempdir tempfile /;
use Docker::CLI::Wrapper::Container v0.0.4 ();

sub run
{
    my $output_fn;

    my $in_fh = \*ARGV;
    my $out   = "";
    my $prev_level;

    while ( my $line = <$in_fh> )
    {
        if ( my ($level) = $line =~ m@\A\<h([0-9]+)@ms )
        {
            if ( $level !~ m#\A[1-6]\z#ms )
            {
                confess "Out of range level $level !";
            }
            my $l = $line . "";
            my ($id);
            if ( not( $l =~ s@\A<h\Q$level\E id="([a-zA-Z0-9\-_\.]+)">@@ms ) )
            {
                confess "no id=\"\" attribute !";
            }
            $id = $1;
            if ( not( $l =~ s@</h\Q$level\E>\n\z@@ms ) )
            {
                confess "no closing tag !";
            }
            my $href;
            my $linktext;
            my $ol;
            if ( $l =~ s@\A<a href="([^\"]+)">([^\<]+)</a>\z@@ms )
            {
                ( $href, $linktext ) = ( $1, $2 );
                $ol =
qq#[% WRAPPER h${level}_section href = "${href}" id = "${id}" title = "${linktext}" %]\n#;
            }
            elsif ( $l =~ s@\A([^\<\>]+)\z@@ms )
            {
                ($linktext) = ( $1, );
                $ol =
qq#[% WRAPPER h${level}_section id = "${id}" title = "${linktext}" %]\n#;
            }
            else
            {
                confess "wrong/intermediate lne formt ' $line '";
            }
            if ( defined($prev_level) )
            {
                foreach my $lev ( reverse( $level .. $prev_level ) )
                {
                    $out .= qq#\n\n[% END %]\n\n#;
                }
            }
            $out .= $ol;
            $prev_level = $level;
        }
        elsif ( my ($tag) = $line =~ m@(</h[0-9]+)@ms )
        {
            confess "Out of place end tag “$tag” !";
        }
        else
        {
            $out .= $line;
        }
    }
    my $oprev = '';
    foreach my $lev ( reverse( 2 .. $prev_level ) )
    {
        $oprev .= qq#\n\n[% END %]\n\n#;
    }
    $out =~ s@(^\[\%\-? *END *\-?\%\]\n*)\z@$oprev . $1@ems;
    $out =~ s#\n\n+#\n\n#gms;

    print $out;
    return;

    my $obj = Docker::CLI::Wrapper::Container->new(
        { container => "rinutils--deb--test-build", sys => "debian:sid", } );

    GetOptions( "output|o=s" => \$output_fn, )
        or die "errror in cmdline args: $!";

    if ( !defined($output_fn) )
    {
        die "Output filename not specified! Use the -o|--output flag!";
    }

    # $obj->do_system( { cmd => [ "git", "clone", "-b", $BRANCH, $URL, ] } );

    exit(0);
}

run();

1;

__END__

=encoding UTF-8

=head1 NAME

=head1 VERSION

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2007 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut
