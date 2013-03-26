$myhash{"hello"} = "world";
$myhash{"perl"} = "TMTOWTDI";
$myhash{"shlomi"} = "fish";

if (exists($myhash{"perl"}))
{
    print "The key perl exists!\n";
}
else
{
    print "The key perl does not exist!\n";
}

delete($myhash{"perl"});

if (exists($myhash{"perl"}))
{
    print "The key perl exists!\n";
}
else
{
    print "The key perl does not exist!\n";
}

