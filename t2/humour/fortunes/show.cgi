#!/usr/bin/perl

use strict;
use warnings;

use Sys::Hostname;

BEGIN
{
    if (hostname() =~ m{heptagon})
    {
        eval <<'EOF';
use lib "/home/shlomifish/apps/perl5/lib/perl5";

use local::lib  "/home/shlomifish/apps/perl5/lib/perl5";
EOF
    }
}

use CGI;
use DBI;
use Encode qw(decode);

use File::Spec::Functions qw( catpath splitpath rel2abs );

binmode STDOUT, ':encoding(utf8)';

# We're using rand() later.
srand();

# The Directory containing the script.
my $script_dir = catpath( ( splitpath( rel2abs $0 ) )[ 0, 1 ] );

my $db_base_name = "fortunes-shlomif-lookup.sqlite3";

my $full_db_path = "$script_dir/$db_base_name";

my $dbh = DBI->connect("dbi:SQLite:dbname=$full_db_path","","");

my $select_sth = $dbh->prepare(
    q{SELECT text FROM fortune_cookies WHERE str_id = ?}
);

my $select_max_id = $dbh->prepare(
    q{SELECT MAX(id) FROM fortune_cookies}
);

my $lookup_str_id_from_id = $dbh->prepare(
    q{SELECT str_id FROM fortune_cookies WHERE id = ?}
);

my $cgi = CGI->new;

sub _header
{
    my $params = shift || [];

    print $cgi->header(-charset => 'utf-8', @$params);

    return;
}

my $mode = ($cgi->param('mode') || 'str_id');

if ($mode eq "random")
{
    _pick_random();
}
elsif ($mode eq "str_id")
{
    my $str_id = $cgi->param('id');
    _show_by_str_id($str_id);
}
else
{
    _invalid_mode();
}

sub _invalid_mode
{
    _header();
    print <<'EOF';
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

<h1>Error! Invalid mode "@{[CGI::escapeHTML($str_id)]}".</h1>

<p>
Only valid modes are <tt>random</tt> and <tt>str_id</tt> (the latter is the
default).
</p>

</body>
</html>
EOF
    return;
}

sub _pick_random
{
    my $rv = $select_max_id->execute();

    my ($max_id) = $select_max_id->fetchrow_array;

    if (! $max_id)
    {
        _header();

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

<h1>Query failed</h1>

<p>
Report this problem to the webmaster.
</p>
</body>
</html>
EOF
        return;
    }

    $rv = $lookup_str_id_from_id->execute(
        int(rand() * ($max_id)) + 1
    );

    my ($str_id) = $lookup_str_id_from_id->fetchrow_array();

    if (! $str_id)
    {
        _header();

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

<h1>lookup_str_id_from_id query failed</h1>

<p>
Report this problem to the webmaster.
</p>
</body>
</html>
EOF
        return;

    }

    # str_id must not contain any strange HTML/URI/etc. characters
    # If it does - then we suck.
    print $cgi->redirect("./show.cgi?id=$str_id");

    return;
}

sub _show_by_str_id
{
    my ($str_id) = @_;

    if (! $str_id)
    {
        _header();
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
        _header();

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

    $html_text = decode('utf-8', $html_text);

    _header();
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
<li><a href="show.cgi?mode=random">Random Fortune</a></li>
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
