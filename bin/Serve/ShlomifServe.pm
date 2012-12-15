package ShlomifServe;

use strict;
use warnings;

use CGI;
use MIME::Types;

sub serve
{
    my (%args) = (@_);
    my $dir_to_serve = $args{'dir_to_serve'};

    my $cgi = CGI->new();
    my $mimetypes = MIME::Types->new();
    my $path = $cgi->path_info();

    if (grep { ($_ eq ".") || ($_ eq "..") } (split /\//, $path))
    {
        print $cgi->header();
        print "<html><body>You suck! Don't use .. or . as
        path components</body></html>";
        exit(0);
    }

    if ($path =~ m{/$})
    {
        if (-f $dir_to_serve.$path."index.html")
        {
            $path .= "index.html";
        }
        else
        {
            opendir D, $dir_to_serve.$path;
            my @files = (sort { $a cmp $b } grep { $_ ne "." } readdir(D));
            closedir(D);
            print $cgi->header();
            my $title = "Listing for " . CGI::escapeHTML($path);
            my $files_string = join("",
                map {
                    my $fn = CGI::escapeHTML($_) .
                        ((-d $dir_to_serve.$path."/".$_)?"/":"");
                    qq{<li><a href=\"$fn\">$fn</a></li>\n}
                } @files);
            $files_string = @files ? "<ol>\n$files_string\n</ol>" : "";
            print <<"EOF";
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html>
<head>
<title>$title</title>
</head>
<body style="background-color:white">
<h1>$title</h1>
$files_string
</body>
</html>
EOF
            exit(0);
        }
    }

    my $file_full_path = $dir_to_serve.$path;
    my $text;
    do {
        local $/;
        open my $in, "<", $file_full_path;
        $text = <$in>;
        close($in);
    };
    my $mime_type = $mimetypes->mimeTypeOf($file_full_path);
    if ($mime_type eq "text/html")
    {
        $text =~ s!http://www\.shlomifish\.org/!http://localhost/sites/hp/shlomif/!g;
        $text =~ s!http://vipe\.technion\.ac\.il/\~shlomif/!http://localhost/sites/hp/vipe/!g;
    }
    print "Content-Type: $mime_type\n\n";
    print $text;

    exit(0);
}

1;

