
$x = 5;
$y = 1000;
{
    my ($y);
    for($y=0;$y<10;$y++)
    {
        print $x, "*", $y, " = ", ($x*$y), "\n";
    }
}

print "Now, \$y is ", $y, "\n";

