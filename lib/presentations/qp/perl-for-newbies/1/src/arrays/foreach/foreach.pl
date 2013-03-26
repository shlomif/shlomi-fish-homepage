@numbers = (15,5,7,3,9,1,20,13,9,8,
	15,16,2,6,12,90);

$max = $numbers[0];
$min = $numbers[0];

foreach $i (@numbers[1..$#numbers])
{
	if ($i > $max)
	{
		$max = $i;
	}
	elsif ($i < $min)
	{
		$min = $i;
	}
}

print "The maximum is " . $max . "\n";
print "The minimum is " . $min . "\n";
