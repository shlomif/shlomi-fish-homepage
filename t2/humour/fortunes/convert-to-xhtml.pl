use strict;
use warnings;

use Cwd;
use File::Spec;
use String::ShellQuote;

my $xml_fn = shift(@ARGV);
my $out_fn = shift(@ARGV);

my $html_fn = $xml_fn;

my $abs_xml_fn = File::Spec->rel2abs($xml_fn);

my $abs_out_fn = File::Spec->rel2abs($out_fn);

my $xml_data_gen_cmd = 
    q#perl -MXML::Grammar::Fortune -e 'XML::Grammar::Fortune->new({mode => "convert_to_html", output_mode => "filename"})->run({input => shift(@ARGV), output => shift(@ARGV)})' # .  shell_quote($abs_xml_fn, $abs_out_fn);

# print STDERR $xml_data_gen_cmd; exit(0);
system($xml_data_gen_cmd);

open my $text_fh, "<", $abs_out_fn;
binmode ($text_fh, ":utf8");
my $contents;
{
    local $/;
    $contents = <$text_fh>;
}
close($text_fh);

$contents =~ s{\A(.*?)<body>}{}ms;
$contents =~ s{</body>(.*?)\z}{}ms;

open my $xhtml_raw_out, ">", "${abs_out_fn}-for-input";
binmode ($xhtml_raw_out, ":utf8");
print {$xhtml_raw_out} $contents;
close($xhtml_raw_out);
