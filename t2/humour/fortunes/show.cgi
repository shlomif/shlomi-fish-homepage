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

my $select_sth = $dbh->prepare(<<'EOF');
SELECT f.text, f.title, c.str_id, c.title
FROM fortune_cookies AS f, fortune_collections AS c
WHERE ((f.str_id = ?) AND (f.collection_id = c.id))
EOF

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

sub _emit_error
{
    my ($args) = @_;

    _header(['-status' => '404 Not Found',]);
    _wrap_error_html($args);

    return;
}

sub _wrap_error_html
{
    my ($args) = @_;

    my $title = $args->{title};
    my $body = $args->{body};

    print <<"ERROR_HTML";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>$title</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
$body
</body>
</html>
ERROR_HTML
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
    _invalid_mode($mode);
}

sub _invalid_mode
{
    my ($mode) = @_;

    my $mode_esc = CGI::escapeHTML($mode);

    _emit_error({ 
            title => qq{Error! Invalid mode "$mode_esc"},
            body => <<"END_OF_BODY", });
<h1>Error! Invalid mode "$mode_esc".</h1>

<p>
Only valid modes are <tt>random</tt> and <tt>str_id</tt> 
(where <tt>str_id</tt> is the default).
</p>
END_OF_BODY
    return;
}

sub _pick_random
{
    my $rv = $select_max_id->execute();

    my ($max_id) = $select_max_id->fetchrow_array;

    if (! $max_id)
    {
        _emit_error({ 
                title => "Query failed",
                body => <<"END_OF_BODY", });
<h1>Query failed</h1>

<p>
Report this problem to the webmaster.
</p>
END_OF_BODY
        return;
    }

    $rv = $lookup_str_id_from_id->execute(
        int(rand() * ($max_id)) + 1
    );

    my ($str_id) = $lookup_str_id_from_id->fetchrow_array();

    if (! $str_id)
    {
        _emit_error({ title => q{Unknown fortune ID},
                body => <<'EOF'});
<h1>lookup_str_id_from_id query failed</h1>

<p>
Report this problem to the webmaster.
</p>
EOF
        return;
    }

    # str_id must not contain any strange HTML/URI/etc. characters
    # If it does - then we suck.
    print $cgi->redirect("./show.cgi?id=$str_id");

    return;
}

sub _display_fortune_from_data
{
    my ($html_text, $html_title, $col_str_id, $col_title) = @_;

    $html_text = decode('utf-8', $html_text);

    my $title_esc =
        CGI::escapeHTML(decode('utf-8', $html_title)) . " - Fortune"
        ;

    _header();
    print <<"FORTUNE";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>$title_esc</title>
<link rel="stylesheet" href="/fortunes.css" type="text/css" media="screen, projection" />
<link rel="stylesheet" href="/fortunes_show.css" type="text/css" media="screen, projection" />
<link rel="stylesheet" href="/screenplay.css" type="text/css" media="screen, projection" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<ul id="nav">
<li><a href="/">Shlomi Fish's Homepage</a></li>
<li><a href="./">Fortune Cookies Page</a></li>
<li><a href="${col_str_id}.html">@{[CGI::escapeHTML($col_title)]}</a></li>
</ul>
<ul id="random">
<li><a href="show.cgi?mode=random">Random Fortune</a></li>
</ul>
<h1>$title_esc</h1>
<div class="fortunes_list">
$html_text
</div>
</body>
</html>
FORTUNE

    return;
}

sub _show_by_str_id
{
    my ($str_id) = @_;

    if (! $str_id)
    {
        _emit_error({ title => q{ID parameter not specified},
                body => <<'END_OF_BODY'});
<h1>Error! Must specify ID parameter</h1>

<p>
The ID parameter must be specified.
</p>
END_OF_BODY
        return;
    }

    my $rv = $select_sth->execute($str_id);

    if (my @data = $select_sth->fetchrow_array)
    {
        return _display_fortune_from_data(@data);
    }
    else
    {
        _emit_error({ title => q{URL not found},
                body => <<"END_OF_BODY"});
<h1>URL not found</h1>

<p>
The fortune ID @{[CGI::escapeHTML($str_id)]} is not recognised.
If you've reached this URL and think it should
be defined please contact <a href="mailto:shlomif\@shlomifish.org">Shlomi
Fish (the Webmaster)</a> and let him know of this problem.
</p>
END_OF_BODY
        return;
    }
}
