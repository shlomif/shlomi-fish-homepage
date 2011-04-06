#!/usr/bin/perl 

use strict;
use warnings;

use XML::LibXML;
use XML::LibXML::Reader;
use XML::LibXML::XPathContext;
use Getopt::Long;

my $out_fn;

# Input the filename
foreach my $filename (@ARGV)
{
    my $reader = XML::LibXML::Reader->new(
        location => $filename, load_ext_dtd => 0, 'no_network' => 1
    ) or die "Cannot read '$filename'.";
    while ($reader->read())
    {
        if ($reader->nodeType() == XML_TEXT_NODE)
        {
            my $data = $reader->value;

            my @lines = split(/\n/, $data, -1);

            foreach my $idx (0 .. $#lines)
            {
                my $line = $lines[$idx];

                if ($line =~ m{"})
                {
                    printf {*STDOUT} ("%s:%d:%s\n",
                        $filename, $reader->lineNumber()+$idx, $line
                    );
                }
            }
        }
    }

}
