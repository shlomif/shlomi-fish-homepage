use strict;
use warnings;

while (1)
{
    print "Please enter what you want to do:\n";
    print "(create, deposit, retrieve, status. exit)\n";
    $function = <>;
    chomp($function);
    if ($function eq "exit")
    {
        last;
    }
    print "Enter the name of the account:\n";
    $account = <>;
    chomp($account);
    if ($function eq "create")
    {
        if (exists($bank_accounts{$account}))
        {
            print "Error! The account already exists!\n";
        }
        else
        {
            $bank_accounts{$account} = 0;
            print "Account created.\n";
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
        if ( ! exists($bank_accounts{$account}) )
        {
            print "Error! The account does not exist.\n";
        }
        else
        {
            print "How much do you wish to deposit?\n";
            $how_much = <>;
            chomp($how_much);
            if ($how_much < 0)
            {
                print "Error! Cannot deposit a negative value.";
            }
            else
            {
                $bank_accounts{$account} += $how_much;
                print "The amount was deposited in the account.";
            }
        }
    }
    elsif ($function eq "retrieve")
    {
        if ( ! exists($bank_accounts{$account}) )
        {
            print "Error! The account does not exist.";
        }
        else
        {
            print "How much do you wish to retrieve?\n";
            $how_much = <>;
            chomp($how_much);
            if ($how_much < 0)
            {
                print "Error! Cannot retrieve a negative value.\n";
            }
            elsif ($bank_accounts{$account} < $how_much)
            {
                print "Error! There isn't enough money in the account.\n";
            }
            else
            {
                $bank_accounts{$account} -= $how_much;
                print "The amount was retrieved from the account.";
            }

        }
    }
    else
    {
        print "Error! Unknown function.\n";
    }
    print "\n";
}
