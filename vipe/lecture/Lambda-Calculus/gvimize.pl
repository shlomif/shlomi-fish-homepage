#!/usr/bin/perl

#$gvim = "L:\\programs\\vim\\vim55\\gvim";
#$vimruntime = "L:\\programs\\vim\\vim55";
$gvim = "gvim";
$vimruntime = "/usr/share/vim/vim58";

open I, "index.old.html";
while ($line = <I>)
{
	if ($line !~ /scm/)
	{
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
		#print "<a href=\"$filename.html\">$title</a>" . ("\&nbsp;" x 8) .  " (<a href=\"$filename\">Scheme Code</a>)<br>\n";

        my $dest_filename = $filename . ".html";
        my @src_stat = stat($filename);
        my @dest_stat = stat($dest_filename);
        if ( (! -e $dest_filename) ||
             ($src_stat[9] > $dest_stat[9])
           )
        {
            # Do Nothing
        }
        else
        {
            next;
        }
            
		
        my @commands = ("syn on", "so $vimruntime/syntax/2html.vim", "wq", "q");
        my $cmd_line = $gvim . " -f " . join(" ", (map { "+\"$_\"" } @commands)) . " " . $filename;
        print "$cmd_line\n";
        system($cmd_line);
        # system("$gvim -f -c \"syn on\" -c \"so $vimruntime/syntax/2html.vim\" -c \"wq\" -c \"q\" $filename");
        #exit();
	}
}
close (I);
