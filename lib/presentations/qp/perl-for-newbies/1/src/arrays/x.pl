print "Test 1:\n";
@myarray = ("Hello", "World");
@array2 = ((@myarray) x 5);
print join(", ", @array2), "\n\n";

print "Test 2:\n";
@array3 = (@myarray x 5);
print join(", ", @array3), "\n\n";

print "Test 3:\n";
$string = "oncatc";
print (($string x 6), "\n\n");

print "Test 4:\n";
print join("\n", (("hello") x 5)), "\n\n";

print "Test 5:\n";
print join("\n", ("hello" x 5)), "\n\n";

