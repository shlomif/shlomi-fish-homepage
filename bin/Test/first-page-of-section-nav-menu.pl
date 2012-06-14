#!/usr/bin/perl

use strict;
use warnings;

use MySectNavData;

use vars (qw($section_nav_menu));

sub init_section_nav_menu
{
    if (defined($section_nav_menu))
    {
        return;
    }
my $filename = "puzzles/";
$filename = "/$filename";

$section_nav_menu = MySectNavData::get_nav_menu(
    'path_info' => $filename,
    'current_host' => "t2",
    'root' => "/",
    );
}

init_section_nav_menu();
print $section_nav_menu->get_html();

