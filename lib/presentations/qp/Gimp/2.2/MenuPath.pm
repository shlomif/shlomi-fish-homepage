package MenuPath;

use strict;
use warnings;
use utf8;

sub get_menupath_text
{
    my $inside = shift;

    # Remove new-lines
    $inside =~ s/\n//g;

    # Remove the existing <tt>'s and such.
    $inside =~ s/< *\/? *(?:tt|code) *>//g;

    # convert these ampersand escapes to normal text.
    if (0)
    {
        $inside =~ s/&(amp|lt|gt);/
            (($1 eq "amp") ?
                "&" :
                ($1 eq "lt") ?
                    "<" :
                    ">"
            )
                    /ge;
    }

    # Split to the menu path components
    my @components = split( /\s*-&gt;\s*/, $inside );

    # Wrap the components of the path with the HTML Cascading Style
    # Sheets Magic
    my @components_rendered =
        map { "\n<b class=\"menupathcomponent\">\n" . $_ . "\n" . "</b>\n" }
        @components;

    # An arrow wrapped in CSS magic.
    my $separator_string = qq#<span class="menupathseparator">→</span>\n#;

    my $final_string = join( $separator_string, @components_rendered );

    $final_string = "<span class=\"menupath\">" . $final_string . "</span>";

    return $final_string;
}

1;
