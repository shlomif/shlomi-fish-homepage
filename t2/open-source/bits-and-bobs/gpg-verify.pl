#!/usr/bin/perl -w

use strict;

my $fingerprints_fn = shift;

(open I, "gpg --list-keys --fingerprint|") ||
    die "Could not pipe from GnuPG";
my $key = "";
my %gpg_keys; # Fingerprint keys.
while (<I>)
{
    if (/^pub/ .. /^\n$/)
    {
        $key .= $_;
    }
    if (/^\n$/)
    {
        if ($key =~ /^pub/)
        {
            $key =~ /^(pub.*)\n/;
            $gpg_keys{$1} = $key;
        }
        $key = "";
    }
}
close(I);
open I, "<$fingerprints_fn";
$key = "";
while (<I>)
{
    if (/^pub/ .. /^\n$/)
    {
        $key .= $_;
    }
    if (/^\n$/)
    {
        if ($key =~ /^pub/)
        {
            $key =~ /^(pub.*)\n/;
            my $id = $1;
            if (exists($gpg_keys{$id}))
            {
                if ($gpg_keys{$id} eq $key)
                {
                    # print "\nKey Exists! ($id)";
                }
                else
                {
                    print "Key is not correct: ($id)\n";
                }
            }
        }
        $key = "";
    }
}
close(I);

