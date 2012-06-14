# Initialize the valid operations collection
$ops{'create'} = 1;
$ops{'deposit'} = 1;
$ops{'status'} = 1;
$ops{'exit'} = 2;

while (1)
{
    # Get a valid input from the user.
    while (1)
    {
        print "Please enter what you want to do:\n";
        print "(" . join(", ", keys(%ops)) . ")\n";

        $function = <>;
        chomp($function);

        if (exists($ops{$function}))
        {
            last;
        }
        print "Unknown function!\n Please try again.\n\n"
    }

    if ($function eq "exit")
    {
        last;
    }

    print "Enter the name of the account:\n";
    $account = <>;
    chomp($account);
    if ($function eq "create")
    {
        if (! exists($bank_accounts{$account}))
        {
            $bank_accounts{$account} = 0;
        }
    }
    elsif ($function eq "status")
    {
        if (! exists ($bank_accounts{$account}) )
        {
            print "Error! The account does not exist.\n";
        }
        else
        {
            print "There are " . $bank_accounts{$account} .
                " NIS in the account.\n";
        }
    }
    elsif ($function eq "deposit")
    {
        if (exists($bank_accounts{$account}) )
        {
            print "How much do you wish to deposit?\n";
            $how_much = <>;
            chomp($how_much);
            $bank_accounts{$account} += $how_much;
        }
    }
    print "\n";
}
