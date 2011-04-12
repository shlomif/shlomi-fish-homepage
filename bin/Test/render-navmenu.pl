#!/usr/bin/perl 

use strict;
use warnings;
use MyNavData;
use Shlomif::Homepage::NavMenu::JQTreeView;
use CGI qw();
use MyNavLinks;

binmode STDOUT, ":utf8";

my $my_THE_filename = "art/better-scm/index.html";
{
my $filename = $my_THE_filename;
$filename =~ s{index\.html$}{};
$filename = "/$filename";

use vars qw($nav_bar);

$nav_bar = Shlomif::Homepage::NavMenu::JQTreeView->new(
    'path_info' => $filename,
    'current_host' => "t2",
    MyNavData::get_params(),
    'ul_classes' => [ "navbarmain", ("navbarnested") x 10 ],
    );

my $rendered_results = $nav_bar->render();

print map { "$_\n" } @{$rendered_results->{html}};
}
