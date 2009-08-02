for $y (1 .. 10)
{
    for $x (1 .. 10)
    {
        $product = $y*$x;
        # Add as much whitespace as needed so the number will occupy
        # exactly 4 characters.
        for $whitespace (1 .. (4-length($product)))
        {
            print " ";
        }
        print $product;
    }
    # Move to the next line
    print "\n";
}
