use strict;
use warnings;

use Path::Tiny qw/ path /;

require 5.010;

my $abs_in_fn  = path( shift @ARGV )->absolute();
my $abs_out_fn = path( shift @ARGV )->absolute();

my $contents = $abs_in_fn->slurp_utf8;

$contents =~ s{\A(?:.*?)<body>}{}ms;
$contents =~ s{</body>(?:.*?)\z}{}ms;

$contents =~
s#(<h3 id=\s*"([^"]+)"[^>]*>[^<]+</h3>)#<div class="head">$1\n<p class="disp"><a href="show.cgi?id=$2">Display</a></p></div>\n#g;

$contents =~
s#(<table class="irc-conversation">.*?</table>)#<div class="irc-body">$1</div>#gms;

$contents =~ s/\n(\s*)#/${1} #/gms;

$abs_out_fn->spew_utf8($contents);
