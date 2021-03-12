#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;

use utf8;

use Test::More tests => 8;
use Test::Differences (qw(eq_or_diff));

use lib './Tests/lib';
use lib './lib';

use NavDataRender                            ();
use Shlomif::Homepage::NavBlocks::Renderer   ();
use Shlomif::Homepage::NavBlocks             ();
use Shlomif::Homepage::NavBlocks::TableBlock ();
use NavBlocks                                ();

our $latemp_filename;

sub _fn
{
    my $fn = shift;

    $latemp_filename = $fn;

    return "/$fn";
}

my $main_obj = Shlomif::Homepage::NavBlocks->new();

use XML::LibXML ();

my $parser = XML::LibXML->new();

$parser->load_ext_dtd(1);

my $xpc = XML::LibXML::XPathContext->new();
$xpc->registerNs( 'x', q{http://www.w3.org/1999/xhtml} );

# TEST:$num_blocks=8;
foreach my $ext ('')
{
    my $nav_bar = HTML::Widgets::NavMenu->new(
        path_info    => _fn("humour/Selina-Mandrake/$ext"),
        current_host => 't2',
        MyNavData::get_params(),
        'no_leading_dot' => 1,
    );

    my $r = Shlomif::Homepage::NavBlocks::Renderer->new(
        {
            host     => 't2',
            nav_menu => $nav_bar,
        }
    );
    foreach my $block_id ( @{ $main_obj->list_nav_blocks } )
    {
        my $block = $main_obj->get_nav_block($block_id);
        my $links = $block->collect_local_links();

        # TEST*$num_blocks
        subtest "tests for block_id='$block_id'", sub {
            foreach my $link (@$links)
            {
                $link =~ s#/\z#/index.xhtml#ms;
                my $fn = "dest/post-incs/t2/$link";

                ok( scalar( -f $fn ), "$fn exists." );
                my $doc = $parser->parse_file($fn);

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
            done_testing();
            return;
        };

    }

    # die "@$links";
}
