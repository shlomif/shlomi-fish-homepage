#!/usr/bin/perl

$input_filename = '/home/users/shlomif/Docs/forward.txt';

my ($line, @fields, %hashAddresses);

open INPUT, $input_filename;
while ($line = <INPUT>)
{
	chomp $line;
	@fields = split(/:/, $line);
	$hashAddresses{$fields[0]} = $fields[1];
}
close (INPUT);

use CGI;

$q = new CGI;

if ( exists($hashAddresses{$q->param('t')}) )
{
print $q->redirect('mailto:' . $hashAddresses{$q->param('t')});
}
else
{
print "Content-Type: text/plain\n\n";
print "Unknown ID: " . $q->param('t') . "\n";
}
