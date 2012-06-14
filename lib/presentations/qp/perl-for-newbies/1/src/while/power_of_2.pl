print "Please enter a number:\n";
$number=<>;
chomp($number);
$power_of_2 = 1;
while ($power_of_2 < $number)
{
    $power_of_2 *= 2;
}
print ("The first power of 2 that is " .
    "greater than this number is " , $power_of_2, "\n");
