while($string = <>)
{
    chomp($string);
    if (exists($myhash{$string}))
    {
        print "The string \"" . $string . "\" was already encountered!";
        last;
    }
    else
    {
        $myhash{$string} = 1;
    }
}
