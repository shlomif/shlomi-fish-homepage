print "Please enter your name:\n";
$name = <>;
chomp($name);
$fl = lc(substr($name, 0, 1));
if (($fl eq "a")||($fl eq "b")||($fl eq "c"))
{
    print "Your name starts with one of the " .
        "first three letters of the ABC.\n";
}
else
{
    print "Your name does not start with one of the " .
        "first three letters of the ABC.\n";
}
