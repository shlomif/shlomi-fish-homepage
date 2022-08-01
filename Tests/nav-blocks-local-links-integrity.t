#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;

use Test::More tests => 15;
use XML::LibXML ();

use lib './lib';

use NavDataRender                ();
use Shlomif::Homepage::NavBlocks ();

my $main_obj = Shlomif::Homepage::NavBlocks->new();

my $parser = XML::LibXML->new();

my $xpc = XML::LibXML::XPathContext->new();
$xpc->registerNs( 'x', q{http://www.w3.org/1999/xhtml} );

my %cache;

sub _get_doc
{
    my ( $self, $fn ) = @_;

    return ( $cache{$fn} //= $parser->parse_file($fn) );
}

my $master_fn  = "dest/post-incs/t2/meta/nav-blocks/blocks/index.xhtml";
my $master_doc = __PACKAGE__->_get_doc($master_fn);

# TEST:$num_blocks=15;
{
    foreach my $block_id ( @{ $main_obj->list_nav_blocks } )
    {
        my $block = $main_obj->get_nav_block($block_id);
        my $links = $block->collect_local_links();

        # TEST*$num_blocks
        subtest "tests for block_id='$block_id'", sub {
            plan( tests => ( 1 + 2 * @$links ) );
            foreach my $link (@$links)
            {
            SKIP:
                {
                    if ( $link =~ /commercial-fan-fic/ )
                    {
                        skip "commercial_fanfic", 2;
                    }
                    $link =~ s#/\z#/index.xhtml#ms;
                    my $fn = "dest/post-incs/t2/$link";

                    ok( scalar( -f $fn ), "$fn exists." );
                    my $doc = __PACKAGE__->_get_doc($fn);

                    my $r = $xpc->find(
                        sprintf(
q{//x:nav[@class="nav_blocks"]/x:table[@id="%s_nav_block"]},
                            $block_id ),
                        $doc
                    );

                    is(
                        $r->size(),
                        1,
                        "Found one toc item for block_id='$block_id';fn='$fn'",
                    );
                }
            }
            my $r = $xpc->find(
                sprintf(
q{//x:div[@class="nav_blocks"]/x:section[./x:header/x:h3[@id="%s_sect"]]/x:table[@id="%s_nav_block"]},
                    ($block_id) x 2 ),
                $master_doc
            );

            is(
                $r->size(),
                1,
"Found one toc item for block_id='$block_id';master_fn='$master_fn'",
            );
            return;
        };

    }
}
