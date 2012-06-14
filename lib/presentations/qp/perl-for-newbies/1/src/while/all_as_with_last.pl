print "Please enter a string:\n";
$string=<>;
chomp($string);

# The first position in the string.
$position = 0;

while ($position < length($string))
{
    $char = lc(substr($string, $position, 1));

    if ($char ne "a")
    {
        last;
    }

    # Increment the position
    $position++;
}

# If the position is the end of the string it means the loop was not
# terminated prematurely, so an "a" was not encountered.
if ($position == length($string))
{
    print "The string you entered is all A's!\n";
}
else
{
    print "At least one of the characters in the string " .
        "you entered is not \"A\".\n";
}
