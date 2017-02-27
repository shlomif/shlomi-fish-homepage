package Shlomif::DocBookClean;

use strict;
use warnings;

sub cleanup_docbook
{
    my ($str_ref) = @_;

    # It's a kludge
    $$str_ref =~ s{ lang="en"}{}g;
    $$str_ref =~ s{ xml:lang="en"}{}g;
    $$str_ref =~ s#<head profile="">#<head>#g;
    $$str_ref =~
s# (?:xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"|xml:space="preserve")([ >]|/>)#$1#g;
    $$str_ref =~ s{ type="(?:1|disc)"}{}g;
    $$str_ref =~ s{<hr[^/]*/>}{<hr />}g;
    $$str_ref =~ s{ target="_top"}{}g;

    return;
}

1;

