#!/usr/bin/perl
# convert-kabc-dist-lists.pl - Port the Distribution Lists from
# KAddressbook's older format (in the $HOME/.kde/share/apps/kabc/distlist
# file) to the format used by the KAddressbook in kdepim-3.5.4.
#
# Requires the IO::All module from CPAN.
#
# Run this script inside $HOME/.kde/share/apps/kabc/.
#
# Written by Shlomi Fish, November 2006.
#
# This code is made available under the MIT X11 License.

use strict;
use warnings;

use IO::All;

my @lines = io("distlists")->chomp->getlines;

shift(@lines);

my $list_num = 1;

my $orig = "std.vcf";
my $backup = "__BACKUP-std.vcf";
if (!-e $backup)
{
    io($orig) > io($backup);
}

my $vcf = io($orig);
foreach my $l (@lines)
{
    if ($l =~ m{^([^=]+)=([A-Za-z\d,]+)$})
    {
        my ($name, $members_str) = ($1, $2);
        $members_str =~ s{,$}{};
        my @members = split(/,,/, $members_str);

        my $out_mem = join("", map { ";$_\\," } @members);
        $vcf->append(<<"EOF");

BEGIN:VCARD
FN:$name
N:$name;;;;
UID:DistList$list_num
VERSION:3.0
X-KADDRESSBOOK-DistributionList:$out_mem
END:VCARD
EOF
    }
}
continue
{
    $list_num++;
}
