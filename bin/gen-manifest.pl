#!/usr/bin/perl

use strict;
use warnings;

use IO::All;
use File::Find::Object;
use URI::Escape qw/uri_escape/;
use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);

my $manifest = io->file('./dest/t2/MANIFEST.html');

$manifest->print(<<'EOF');
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>Shlomi Fish’s Homepage’s List of all Files</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<h1>MANIFEST</h1>
<ul>
EOF


{
    my $ffo = File::Find::Object->new({}, './dest/t2');

    while (my $r = $ffo->next_obj())
    {
        if ($r->is_file)
        {
            my $rel_path = escape_html(join('/', @{$r->full_components()}));
            $manifest->print(qq{<li><a href="} . uri_escape($rel_path)
                . qq{">$rel_path</a></li>\n});
        }
    }
}

$manifest->print(<<'EOF');
</ul>
</body>
</html>
EOF
