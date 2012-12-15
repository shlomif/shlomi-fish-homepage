print "Please enter the lower bound of the range:\n";
$lower = <>;
chomp($lower);
print "Please enter the upper bound of the range:\n";
$upper = <>;
chomp($upper);
if ($lower > $upper)
{
    print "This is not a valid range!\n";
}
else
{
    print "Please enter a number:\n";
    $number = <>;
    chomp($number);
    if (($lower <= $number) && ($number <= $upper))
    {
        print "The number is in the range!\n";
    }
    else
    {
        print "The number is not in the range!\n";
    }
}
