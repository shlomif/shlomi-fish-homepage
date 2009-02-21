use strict;
use warnings;

use Cwd;
use File::Spec;
use String::ShellQuote;
use Getopt::Long;

### Definitions:

my $fortune_xml_base_dir = "$ENV{HOME}/progs/perl/cpan/XML/Grammar/Fortune/trunk/XML-Grammar-Fortune/module";

my $good_perl_path = "$ENV{HOME}/apps/perl/perl-5.8.8-debug/bin/perl";

##########################################################################

my $atom_arg;
my $rss_arg;
my $dir_arg;

GetOptions(
    "atom=s" => \$atom_arg,
    "dir=s" => \$dir_arg,
    "rss=s" => \$rss_arg,
);

my $abs_dir = File::Spec->rel2abs($dir_arg);
my $abs_atom = File::Spec->rel2abs($atom_arg);
my $abs_rss = File::Spec->rel2abs($rss_arg);

open my $arcs_list_fh, "<", "$dir_arg/fortunes-list.mak";
my @lines = <$arcs_list_fh>;
close($arcs_list_fh);

shift(@lines);

my @fortunes = (map { /([\w\-_]+)/ ; $1 } @lines);
chdir($fortune_xml_base_dir);

my @cmd_line = 
(
    $good_perl_path,
    "-Mblib",
    "bin/web-feed-syndicate.pl",
    "--dir" => $abs_dir,
    (map { ("--xml-file" , "$_.xml") } (@fortunes)),
    "--yaml-data" => "$abs_dir/fortunes-shlomif-ids-data.yaml",
    "--atom-output" => $abs_atom,
    "--rss-output" => $abs_rss,
    "--master-url" => "http://www.shlomifish.org/humour/fortunes/",
    "--title" => "Shlomi Fish's Fortune Feeds",
    "--tagline" => "Shlomi Fish's Fortune Feeds",
    "--author" => "Shlomi Fish",
);
print join(" ", @cmd_line), "\n";
exit(system(@cmd_line));
