package VimIface;

use strict;
use warnings;

use Text::VimColor;

sub is_newer
{
    my $file1 = shift;
    my $file2 = shift;
    my @stat1 = stat($file1);
    my @stat2 = stat($file2);
    if (! @stat2)
    {
        return 1;
    }
    return ($stat1[9] >= $stat2[9]);
}

sub get_syntax_highlighted_html_from_file
{
    my (%args) = (@_);

    my $filename = $args{'filename'};

    my $html_filename = "$filename.html-for-quad-pres";

    if (is_newer( $filename, $html_filename))
    {
        my $syntax = Text::VimColor->new(
            file => $filename,
            html_full_page => 1,
            ($args{'filetype'} ? (filetype => $args{'filetype'}) : ()),
        );

        open my $out, ">", $html_filename
            or die "Could not open HTML file '$html_filename' for output - $!";

        print {$out} $syntax->html();
        close($out);
    }

    open my $in, "<", $html_filename
        or die "Could not open HTML file '$html_filename' for input - $!";
    my $text = do { local $/; <$in> };
    close($in);

    $text =~ s{^.*<pre>[\s\n\r]*}{}s;
    $text =~ s{[\s\n\r]*</pre>.*$}{}s;
    $text =~ s{(class=")syn}{$1}g;

    return $text;
}

1;

