use strict;
use warnings;

use IO::All;

use File::Spec;
use XML::Grammar::Fortune;

my $in_fn = shift(@ARGV);
my $out_fn = shift(@ARGV);

my $abs_in_fn = File::Spec->rel2abs($in_fn);

my $abs_out_fn = File::Spec->rel2abs($out_fn);

my $contents = io->file($abs_in_fn)->utf8->slurp();

$contents =~ s{\A(?:.*?)<body>}{}ms;
$contents =~ s{</body>(?:.*?)\z}{}ms;

$contents =~ s{<h3( id="[^>]+>[^<]+)</h3>}{<fortune_h3$1</fortune_h3>}g;

$contents =~ s/^(\s*)#/${1}\\#/gms;

io->file($abs_out_fn)->utf8->print($contents);
