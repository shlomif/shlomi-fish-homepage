#!/usr/bin/perl

open I, "index.old.html";
while ($line = <I>)
{
	if ($line !~ /scm/)
	{
		print $line;
	}
	else
	{
		$filename = $line;
		chomp($filename);
		$filename =~ s/^.*"([a-zA-Z_]*\.scm)".*$/$1/;
		$title = $line;
		chomp($title);
		$title =~ s/^.*">//;
		$title =~ s/<\/a>.*$//;
		print "<a href=\"$filename.html\">$title</a>" . ("\&nbsp;" x 8) .  " (<a href=\"$filename\">Scheme Code</a>)<br>\n";
	}
}
close (I);
