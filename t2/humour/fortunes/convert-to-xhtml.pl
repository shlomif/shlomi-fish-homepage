use Cwd;
use File::Spec;
use String::ShellQuote;
use strict;
use warnings;

my $xml_fn = shift(@ARGV);

my $fortune_xml_base_dir = "$ENV{HOME}/progs/perl/cpan/XML/Grammar/Fortune/trunk/XML-Grammar-Fortune/module";

my $good_perl_path = "$ENV{HOME}/apps/perl/perl-5.8.8-debug/bin/perl";

my $html_fn = $xml_fn;

$html_fn =~ s{.xml\z}{.html};
my $filename = $html_fn;

$filename =~ s{\.html\z}{.xml};

my $abs_filename = File::Spec->rel2abs($filename);

my $xhtml_out = $abs_filename;

$xhtml_out =~ s{\.xml\z}{.xhtml};

my $xml_data_gen_cmd = "cd " . shell_quote($fortune_xml_base_dir) . 
    q# ; perl -Mblib -MXML::Grammar::Fortune -e 'XML::Grammar::Fortune->new({mode => "convert_to_html", input => shift(@ARGV), output => shift(@ARGV)})->run()' # .  shell_quote($abs_filename, $xhtml_out);

# print STDERR $xml_data_gen_cmd; exit(0);
system($xml_data_gen_cmd);

open my $text_fh, "<", $xhtml_out;
binmode ($text_fh, ":utf8");
my $contents;
{
    local $/;
    $contents = <$text_fh>;
}
close($text_fh);

$contents =~ s{\A(.*?)<body>}{}ms;
$contents =~ s{</body>(.*?)\z}{}ms;

open my $xhtml_raw_out, ">", $html_fn."-xhtml-for-input";
binmode ($xhtml_raw_out, ":utf8");
print {$xhtml_raw_out} $contents;
close($xhtml_raw_out);
