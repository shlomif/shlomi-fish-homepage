#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 1;

use lib "./lib";

use Shlomif::Homepage::TTRender ();

my $printable;
my $stdout;
my $obj = Shlomif::Homepage::TTRender->new(
    { printable => $printable, stdout => $stdout, } );

{
    my ($htmlref) = $obj->render( "art/index.xhtml", \ "[% base_path %]" );

    # TEST
    like( $$htmlref, qr#\A\.\./\z#ms, "->render base_path test", )
}
