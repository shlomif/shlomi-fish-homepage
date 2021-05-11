#! /usr/bin/env perl
#
# Short description for refactor-nav-blocks-tt2.pl
#
# Version 0.0.1
# Copyright (C) 2021 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the MIT license.

use strict;
use warnings;
use 5.014;
use autodie;

use Path::Tiny qw/ path tempdir tempfile cwd /;

use File::Update qw/ modify_on_change /;

path("src")->visit(
    sub {
        my $fn = shift;
        if (   ( -d $fn )
            or ( $fn !~ /\.tt2\z/ )
            or ( $fn =~ m#src/meta/nav-blocks# ) )
        {
            return;
        }
        modify_on_change(
            $fn,
            sub {
                my $text = shift;
                my @l    = split /^/ms, $$text, -1;
                my $ret  = "";
                for ( my $i = 0 ; $i < @l ; ++$i )
                {
                    my $l = $l[$i];
                    if ( $l =~ m#\A\[\%-? +WRAPPER +nav_blocks +-?\%\]\n\z# )
                    {
                        my @names;
                    NAMES:
                        for ( ++$i ; $i < @l ; ++$i )
                        {
                            $l = $l[$i];
                            if ( $l ne "\n" )
                            {
                                if ( $l =~ m#\A\[\%-? +END +-?\%\]\n\z# )
                                {
                                    last NAMES;
                                }
                                if ( my ($name) =
                                    $l =~
m#\A\[\%-? +PROCESS +(\w+?)_nav_block +-?\%\]\n\z#
                                    )
                                {
                                    push @names, $name;
                                }
                                else
                                {
                                    die "wrong line '$l'";
                                }
                            }
                        }
                        die if not @names;
                        $ret .=
                              "[% INCLUDE render_compact_nav_blocks names = ["
                            . join( ", ", map { "\"$_\"" } @names )
                            . ", ] %]\n";
                    }
                    else
                    {
                        $ret .= $l;
                    }
                }
                if ( $$text ne $ret )
                {
                    $$text = $ret;
                    return 1;
                }
                return;
            }
        );
        return;
    },
    {
        recurse => 1,
    },
);
