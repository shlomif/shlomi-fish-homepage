package VimIface;

use strict;
use warnings;

use Test::Trap qw( trap $trap :flow:stderr(systemsafe):stdout(systemsafe):warn );

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
    my $html_filename = "$filename.html";

    if (is_newer( $filename, $html_filename))
    {
        trap {
            system(
                "gvim","-f","+syn on", 
                "+so \$VIMRUNTIME/syntax/2html.vim",
                "+wq", "+q", $filename
            );
        };
        if ($trap->exit())
        {
            die "gvim failed!";
        }
    }
    local *I;
    open I, "<", $html_filename;
    my $text = join("", <I>);
    close(I);
    $text =~ s{^.*<pre>[\s\n\r]*}{}s;
    $text =~ s{[\s\n\r]*</pre>.*$}{}s;
    return $text;
}

1;

