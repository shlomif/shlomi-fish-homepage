use strict;
use warnings;

use IO::All qw/ io /;

require 5.010;

use File::Spec;
use XML::Grammar::Fortune;

my $in_fn = shift(@ARGV);
my $out_fn = shift(@ARGV);

my $abs_in_fn = File::Spec->rel2abs($in_fn);

my $abs_out_fn = File::Spec->rel2abs($out_fn);

my $contents = io->file($abs_in_fn)->utf8->slurp();

$contents =~ s{\A(?:.*?)<body>}{}ms;
$contents =~ s{</body>(?:.*?)\z}{}ms;

$contents =~ s#(?<full><h3 id=\s*"(?<id>[^"]+)"[^>]*>[^<]+</h3>)#$+{full}\n<p class="disp"><a href="show.cgi?id=$+{id}">Display</a></p>\n#g;

$contents =~ s/\n(\s*)#/${1} #/gms;

io->file($abs_out_fn)->utf8->print($contents);
