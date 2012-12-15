#!/usr/bin/perl

my $new_info = <<'EOF';
<info>
    <author>David Crane &amp; Marta Kauffman</author>
    <work href="http://en.wikipedia.org/wiki/Friends">"Friends" (T.V. Show)</work>
</info>
EOF

while (<>)
{
    s{<info/>}{$new_info};
    print;
}
