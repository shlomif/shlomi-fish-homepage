#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;
use utf8;

use lib './lib';
use Template                         ();
use Parallel::ForkManager::Segmented ();

use Path::Tiny qw/ path /;
use Getopt::Long qw/ GetOptions /;

use HTML::Latemp::AddToc ();

$Shlomif::Homepage::in_nav_block = undef();

use Shlomif::Homepage::TTRender ();
my $printable;
my $stdout;
my @filenames;
GetOptions(
    'printable!' => \$printable,
    'stdout!'    => \$stdout,
    'fn=s'       => \@filenames,
);

my $LATEMP_SERVER = "t2";
my $template      = Template->new(
    {
        COMPILE_DIR  => ( $ENV{TMPDIR} // "/tmp" ) . "/shlomif-hp-tt2-cache",
        COMPILE_EXT  => ".ttc",
        INCLUDE_PATH => [ ".", "./lib", ],
        PRE_PROCESS  => ["lib/blocks.tt2"],
        POST_CHOMP   => 1,
        RELATIVE     => 1,
        ENCODING     => 'utf8',
    }
);

my @DEST = ( '.', "dest", "pre-incs", $LATEMP_SERVER, );
my @tt;
my $obj  = Shlomif::Homepage::TTRender->new;
my $vars = $obj->calc_vars(
    {
        printable => $printable,
    }
);

if (@filenames)
{
    @tt = @filenames;
}
else
{
    @tt = path("lib/make/tt2.txt")->lines_raw;
    chomp @tt;
}
my $toc        = HTML::Latemp::AddToc->new;
my $INC_PREF   = qq#\n(((((include "cache/combined/$LATEMP_SERVER#;
my $INC_SUFFIX = qq#")))))\n#;

sub _inc
{
    my ( $input_tt2_page_path, $id ) = @_;
    return sprintf( "%s/%s/%s%s",
        $INC_PREF, $input_tt2_page_path, $id, $INC_SUFFIX );
}

my $base_path_ref = $obj->get_base_path_ref;

my %INDEX = ( map { $_ => 1 } 'index.html', 'index.xhtml' );

sub proc
{
    my $input_tt2_page_path = shift;
    $::latemp_filename = $input_tt2_page_path;
    my @fn     = split m#/#, $input_tt2_page_path;
    my @fn_nav = @fn;
    my $tail   = \$fn_nav[-1];
    $$tail = '' if ( exists $INDEX{$$tail} );
    $$base_path_ref =
        ( '../' x ( scalar(@fn) - 1 ) );
    my $fn2 = join( '/', @fn_nav ) || '/';

    $vars->{base_path}   = $$base_path_ref;
    $vars->{fn_path}     = $input_tt2_page_path;
    $vars->{raw_fn_path} = $input_tt2_page_path =~ s#(\A|/)index\.x?html\z#$1#r;
    my $set = sub {
        my ( $name, $inc ) = @_;
        $vars->{$name} = _inc( $input_tt2_page_path, $inc );
        return;
    };
    $set->( 'leading_path_string',           "breadcrumbs-trail" );
    $set->( 'html_head_nav_links',           "html_head_nav_links" );
    $set->( 'shlomif_main_expanded_nav_bar', "shlomif_main_expanded_nav_bar" );
    $set->(
        'nav_links_without_accesskey',
        "shlomif_nav_links_renderer-with_accesskey=0"
    );
    $set->(
        'nav_links_with_accesskey',
        "shlomif_nav_links_renderer-with_accesskey=1"
    );
    $set->( 'nav_menu_html',      "main_nav_menu_html" );
    $set->( 'sect_nav_menu_html', "sect-navmenu" );
    my $html = '';
    $template->process( "src/$input_tt2_page_path.tt2",
        $vars, \$html, binmode => ':utf8', )
        or die $template->error();

    $toc->add_toc( \$html );
    if ($stdout)
    {
        binmode STDOUT, ':encoding(utf-8)';
        print $html;
    }
    else
    {
        path( @DEST, @fn, )->spew_utf8($html);
    }
}

Parallel::ForkManager::Segmented->new->run(
    {
        #         disable_fork => 1,
        items        => \@tt,
        nproc        => 1,
        batch_size   => 100,
        process_item => \&proc,
    }
);
