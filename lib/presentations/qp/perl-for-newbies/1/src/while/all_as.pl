print "Please enter a string:\n";
$string=<>;
chomp($string);

# Initialize all_as to TRUE
$all_as = 1;

# The first position in the string.
$position = 0;

while ($all_as && ($position < length($string)))
{
    $char = lc(substr($string, $position, 1));

    if ($char ne "a")
    {
        $all_as = 0;
    }

    # Increment the position
    $position++;
}

if ($all_as)
{
    print "The string you entered is all A's!\n";
}
else
{
    print "At least one of the characters in the string " .
        "you entered is not \"A\".\n";
}
