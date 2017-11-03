package VimIface;

use strict;
use warnings;

use Text::VimColor;
use Path::Tiny qw( path );

sub is_newer
{
    my $file1 = shift;
    my $file2 = shift;
    my @stat1 = stat($file1);
    my @stat2 = stat($file2);
    if ( !@stat2 )
    {
        return 1;
    }
    return ( $stat1[9] >= $stat2[9] );
}

sub get_syntax_highlighted_html_from_file
{
    my (%args) = (@_);

    my $filename = $args{'filename'};

    my $html_filename = "$filename.html-for-quad-pres";

    if ( is_newer( $filename, $html_filename ) )
    {
        my $syntax = Text::VimColor->new(
            file           => $filename,
            html_full_page => 1,
            ( $args{'filetype'} ? ( filetype => $args{'filetype'} ) : () ),
        );

        path($html_filenam)->spew_utf8( $syntax->html() );
    }

    my $text = path($html_filename)->slurp_raw;
    $text =~ s{^.*<pre>[\s\n\r]*}{}s;
    $text =~ s{[\s\n\r]*</pre>.*$}{}s;
    $text =~ s{(class=")syn}{$1}g;

    return $text;
}

1;

