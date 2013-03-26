use strict;
use warnings;

my $indent=0;
my $line_num = 1;
while(<>)
{
    my $open = m!<define!;
    my $close = m!</define!;
    if($close && (!$open))
    {
        $indent--;
    }

    if ($open || $close)
    {
    print sprintf("%-4s: ", $line_num) . (($indent>=0)?
        "    "x$indent:
        "ERRR"x(-$indent)).$_;
    }

    if ($open && (!$close))
    {
        $indent++;
    }
}
continue
{
    $line_num++;
}

