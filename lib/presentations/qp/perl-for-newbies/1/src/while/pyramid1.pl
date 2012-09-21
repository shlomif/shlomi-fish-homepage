print "Please enter the length of the pyramid:\n";
$size = <>;
chomp($size);

ROW_LOOP: for $row (1 .. $size)
{
    for $column (1 .. ($size+1))
    {
        if ($column > $row)
        {
            print "\n";
            next ROW_LOOP;
        }
        print "#";
    }
}
