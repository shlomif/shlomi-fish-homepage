#!/usr/bin/perl

use strict;
use warnings;

# Send an E-mail to myself
# Note: this is just an example - there are modules to do this on CPAN.

open MAIL, "|/usr/sbin/sendmail shlomif\@shlomifish.org";
print MAIL "To: Shlomi Fish <shlomif\@shlomifish.org>\n";
print MAIL "From: Shlomi Fish <shlomif\@shlomifish.org>\n";
print MAIL "\n";
print MAIL "Hello there, moi!\n";
close(MAIL);
