
$a = 5;
$b = 1000;
{
    my ($b);
    for($b=0;$b<10;$b++)
    {
        print $a, "*", $b, " = ", ($a*$b), "\n";
    }
}

print "Now, \$b is ", $b, "\n";

