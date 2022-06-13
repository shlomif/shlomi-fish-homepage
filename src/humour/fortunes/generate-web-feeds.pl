use strict;
use warnings;

use File::Spec   ();
use Getopt::Long qw/ GetOptions /;

my $master_url = "http://www.shlomifish.org/humour/fortunes/";

my $atom_arg;
my $rss_arg;
my $dir_arg;

GetOptions(
    "atom=s" => \$atom_arg,
    "dir=s"  => \$dir_arg,
    "rss=s"  => \$rss_arg,
) or die "Getopt::Long failed - $!";

my $abs_dir  = File::Spec->rel2abs($dir_arg);
my $abs_atom = File::Spec->rel2abs($atom_arg);
my $abs_rss  = File::Spec->rel2abs($rss_arg);

open my $arcs_list_fh, "<", "$dir_arg/fortunes-list.mak";
my @lines = <$arcs_list_fh>;
close($arcs_list_fh);

shift(@lines);

my @fortunes = ( map { /([\w\-_]+)/; $1 } @lines );

my @cmd_line = (
    $^X,
    "-MXML::Grammar::Fortune::Synd::App",
    "-e",
    "run(); exit(0);",
    "--",
    "--dir" => $abs_dir,
    ( map { ( "--xml-file", "$_.xml" ) } (@fortunes) ),
    "--yaml-data"   => "$abs_dir/fortunes-shlomif-ids-data.yaml",
    "--atom-output" => $abs_atom,
    "--rss-output"  => $abs_rss,
    "--master-url"  => $master_url,
    "--title"       => "Shlomi Fish's Fortune Feeds",
    "--tagline"     => "Shlomi Fish's Fortune Feeds",
    "--author"      => "shlomif\@cpan.org (Shlomi Fish)",
);

system(@cmd_line) and die "Error in executing <<@cmd_line>>!";
