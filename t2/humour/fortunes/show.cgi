#!/usr/bin/perl

use strict;
use warnings;

use lib "/home/shlomifish/apps/perl5/lib/perl5";

use local::lib  "/home/shlomifish/apps/perl5/lib/perl5";

use CGI;
use DBI;

use File::Spec::Functions qw( catpath splitpath rel2abs );

# The Directory containing the script.
my $script_dir = catpath( ( splitpath( rel2abs $0 ) )[ 0, 1 ] );

my $db_base_name = "fortunes-shlomif-lookup.sqlite3";

my $full_db_path = "$script_dir/$db_base_name";

my $dbh = DBI->connect("dbi:SQLite:dbname=$full_db_path","","");

my $select_sth = $dbh->prepare(
    q{SELECT text FROM fortune_cookies WHERE str_id = ?}
);

my $cgi = CGI->new;

my $str_id = $cgi->param('id');

sub _main
{
    if (! $str_id)
    {
        print $cgi->header();
        print <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>Unknown fortune ID</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>

<h1>Error! Must specify id parameter</h1>

<p>
The ID parameter must be specified.
</p>
</body>
</html>
EOF
        return;
    }

    my $rv = $select_sth->execute($str_id);

    my ($html_text) = $select_sth->fetchrow_array;

    if (! $html_text)
    {
        print $cgi->header();

        print <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>Unknown fortune ID</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>

<h1>URL not found</h1>

<p>
The fortune ID @{[CGI::escapeHTML($str_id)]} is not recognised.
If you've reached this URL and think it should
be defined please contact <a href="mailto:shlomif\@shlomifish.org">Shlomi
Fish (the Webmaster)</a> and let him know of this problem.
</p>
</body>
</html>
EOF
        return;
    }

    print $cgi->header();
    print <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>Fortune "@{[CGI::escapeHTML($str_id)]}"</title>
<link rel="stylesheet" href="/fortunes.css" type="text/css" media="screen, projection" />
<link rel="stylesheet" href="/fortunes_show.css" type="text/css" media="screen, projection" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>

<ul id="nav">

<li><a href="./">Back to the Main Fortunes Page</a></li>

<li><a href="/">Shlomi Fish's Homepage</a></li>

</ul>

<h1>Fortune "@{[CGI::escapeHTML($str_id)]}"</h1>

<div class="fortunes_list">
$html_text
</div>

</body>
</html>
EOF

    return;
}

_main();
