#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;

use Test::More tests => 9;
use XML::LibXML ();

use lib './lib';

use NavDataRender                ();
use Shlomif::Homepage::NavBlocks ();

my $main_obj = Shlomif::Homepage::NavBlocks->new();

my $parser = XML::LibXML->new();

my $xpc = XML::LibXML::XPathContext->new();
$xpc->registerNs( 'x', q{http://www.w3.org/1999/xhtml} );

my %cache;

# TEST:$num_blocks=9;
{
    foreach my $block_id ( @{ $main_obj->list_nav_blocks } )
    {
        my $block = $main_obj->get_nav_block($block_id);
        my $links = $block->collect_local_links();

        # TEST*$num_blocks
        subtest "tests for block_id='$block_id'", sub {
            plan( tests => ( 2 * @$links ) );
            foreach my $link (@$links)
            {
                $link =~ s#/\z#/index.xhtml#ms;
                my $fn = "dest/post-incs/t2/$link";

                ok( scalar( -f $fn ), "$fn exists." );
                my $doc = ( $cache{$fn} //= $parser->parse_file($fn) );

                my $r = $xpc->find(
                    sprintf(
q{//x:div[@class="nav_blocks"]/x:div[@id="%s_nav_block"]/x:table},
                        $block_id ),
                    $doc
                );

                is( $r->size(), 1,
                    "Found one toc item for block_id='$block_id';fn='$fn'",
                );
            }
            return;
        };

    }
}
