#!/usr/bin/perl -w

use strict;

use Contents;

my $contents = Contents::get_contents();


my $prefix = "/var/www/html/shlomi/haifux/lecture/FCS-TNP/";

sub get_branch
{
    my $output_ref = shift;
    my $branch = shift;
    my $path = shift;

    my $text = "";

    my $filename = join("/", @$path) . (exists($branch->{'subs'}) ? "/index.html" : "");

    open I, "<$prefix/$filename";
    $text .= join("",<I>);
    close(I);

    $text =~ s/^[\x00-\xFF]*?<body.*?>//;
    $text =~ s/<\/body>[\x00-\xFF]*$//;

    $output_ref->($text);
    $output_ref->("<hr>\n" . "\cl\n");

    foreach my $sub_b (@{$branch->{'subs'}})
    {
        &get_branch(
            $output_ref,
            $sub_b,
            [ @$path, $sub_b->{'url'} ]
        );
    }
}

sub output_ref
{
    my $text = shift;
    print $text;
}

output_ref(
    "<html>\n" .
    "<head>\n" .
    "<link rel=\"StyleSheet\" href=\"./style.css\" type=\"text/css\">\n" .
    "<title>" . $contents->{'title'} . "</title>\n" .
    "</head>\n" .
    "<body bgcolor=\"white\">\n"
    );
&get_branch(
    \&output_ref,
    $contents,
    []
);
output_ref("\n</body>\n</html>\n");

