#!/usr/bin/perl

use English;

$temp_file_name = "temp". $PROCESS_ID . ".txt";

foreach $file (@ARGV)
{
	open O, ">$temp_file_name";
	open I, "$file";
	
	while (<I>)
	{
		s!\r!!g;
		print O $_;
	}
	close (O);
	close (I);

	system("mv -f $temp_file_name \"$file\"");
}