#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

my $fingerprints_fn = shift;

open my $gpg_fh, '-|', 'gpg', '--list-keys', '--fingerprint'
    or die "Could not pipe from GnuPG";
my $key = "";
my %gpg_keys;    # Fingerprint keys.
while (<$gpg_fh>)
{
    if ( /^pub/ .. /^\n$/ )
    {
        $key .= $_;
    }
    if (/^\n$/)
    {
        if ( $key =~ /^pub/ )
        {
            $key =~ /^(pub.*)\n/;
            $gpg_keys{$1} = $key;
        }
        $key = "";
    }
}
close($gpg_fh);
open my $finger_fh, '<', $fingerprints_fn;
$key = "";
while (<$finger_fh>)
{
    if ( /^pub/ .. /^\n$/ )
    {
        $key .= $_;
    }
    if (/^\n$/)
    {
        if ( $key =~ /^pub/ )
        {
            $key =~ /^(pub.*)\n/;
            my $id = $1;
            if ( exists( $gpg_keys{$id} ) )
            {
                if ( $gpg_keys{$id} eq $key )
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
close($finger_fh);
