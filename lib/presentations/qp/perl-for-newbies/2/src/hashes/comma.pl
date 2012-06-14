%hash1 = (
    "shlomi" => "fish",
    "orr" => "dunkelman",
    "guy" => "keren"
    );

%hash2 = (
    "george" => "washington",
    "jules" => "verne",
    "isaac" => "newton"
    );

%combined = (%hash1, %hash2);

foreach $key (keys(%combined))
{
    print $key, " = ", $combined{$key}, "\n";
}
