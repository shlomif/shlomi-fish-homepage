for($row = 1 ; $row <= 10 ; $row++)
{
    for($column = 1 ; $column <= 10 ; $column++)
    {
        $result = $row*$column;
        $pad = ( " "  x  (4-length($result)) );
        print $pad, $result;
    }
    print "\n";
}
