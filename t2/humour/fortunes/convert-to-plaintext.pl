use Cwd;
use File::Spec;
use String::ShellQuote;
use strict;
use warnings;

### Definitions:

my $fortune_xml_base_dir = "$ENV{HOME}/progs/perl/cpan/XML/Grammar/Fortune/trunk/XML-Grammar-Fortune/module";

my $good_perl_path = "$ENV{HOME}/apps/perl/perl-5.8.8-debug/bin/perl";

##########################################################################

my $xml_fn = shift(@ARGV);
my $out_fn = shift(@ARGV);

my $html_fn = $xml_fn;


my $abs_xml_fn = File::Spec->rel2abs($xml_fn);

my $abs_out_fn = File::Spec->rel2abs($out_fn);

my $xml_data_gen_cmd = "cd " . shell_quote($fortune_xml_base_dir) . 
    q# ; perl -Mblib -MXML::Grammar::Fortune::ToText -e 'my ($in_fn, $out_fn) = @ARGV; open my $out, ">", $out_fn; binmode($out, ":utf8"); XML::Grammar::Fortune::ToText->new({input => shift(@ARGV), output => $out})->run();close($out)' # .  shell_quote($abs_xml_fn, $abs_out_fn);

# print STDERR $xml_data_gen_cmd; exit(0);
system($xml_data_gen_cmd);

