package Shlomif::Homepage::P4N_Lect5_HebNotes;

use strict;
use warnings;
use utf8;

use Encode      qw/ decode_utf8 encode_utf8 /;
use Shlomif::MD ();

my $HEAD = <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="he" dir="rtl">
<head>
<title>Shlomi Fish’s Homepage</title>
<meta charset="utf-8"/>
<meta name="description" content="Perl for Newbies Lecture 5: Hebrew Notes"/>
<style>
body { direction: rtl; text-align: right; }
</style>
</head>
<body>
EOF

sub calc
{
    my $BODY =
        Shlomif::MD::as_text("src/lecture/Perl/Newbies/lecture5-notes.txt");
    return decode_utf8(
        encode_utf8($HEAD) . encode_utf8($BODY) . "\n</body></html>" );
}

1;
