use strict;
use warnings;

my $indent   = 0;
my $line_num = 1;
while ( my $l = <> )
{
    my $open  = $l =~ m!\A\[%\-? +((?:WRAPPER +faq_h[0-9]+_section)|IF)!;
    my $close = ( $indent && ( $l =~ m!\A\[%(?:\- *)? +END! ) );
    if ( $close && ( !$open ) )
    {
        --$indent;
    }

    if ( $open || $close )
    {
        print sprintf( "%-4s: ", $line_num )
            . (
            ( $indent >= 0 )
            ? "    " x $indent
            : "ERRR" x ( -$indent )
            ) . $l;
    }

    if ( $open && ( !$close ) )
    {
        ++$indent;
    }
}
continue
{
    ++$line_num;
}
