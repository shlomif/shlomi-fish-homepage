#!/usr/bin/perl

use strict;

use Math::BigInt;

my $random_mask1 = ((new Math::BigInt(2)) ** (eval { my @a = ("0xffffffffffffffffL" =~ /f/g); scalar(@a); } * 4));

my $random_mask2 = ((new Math::BigInt(2)) ** (eval { my $num = "0x7fffffffL"; my @a = ($num =~ /f/g); my @b = ($num =~ /7/g); (scalar(@a)*4+scalar(@b)*3); }));

my $random_mask3 = ((new Math::BigInt(2)) ** 21);

my $random_mask4 = (new Math::BigInt("6364136223846793005"));

sub get_new_random_context
{
    my $seed = shift;

    return {
        'seed' => (new Math::BigInt($seed))
        };        
}

sub myrand
{
    my $random_context = shift;
    my $rand_max = shift;

    $random_context->{'seed'} =  (($random_context->{'seed'}*$random_mask4 + 1) % $random_mask1);

    my $ret = (($random_context->{'seed'} / $random_mask3) % $random_mask2);
    $ret = "$ret";
    return ($ret / 2147483648.0)*$rand_max;
}

sub write_graph_to_file
{
    my $filename = shift;
    my $num_nodes = shift;
    my $graph = shift;

    open O, ">". $filename;
    print O $num_nodes, "\n";
    my ($node, $to_node, $a);
    for($node=0;$node<$num_nodes;$node++)
    {
        for($to_node=$node;$to_node<$num_nodes;$to_node++)
        {
            for($a=0;$a<$graph->[$node][$to_node];$a++)
            {
                print O $node, " -> ", $to_node, "\n";
            }
        }
    }
    close(O);

    return 1;
}

sub generate_random_graph
{
    my $num_nodes = shift;
    my $num_links = shift;
    my $random_context = shift;

    my $graph = [ (0) x $num_nodes ];
    my ($node, $to_node);
    for($node=0;$node<$num_nodes;$node++)
    {
        $graph->[$node] = [ (0) x $num_nodes ];
    }

    my $a;
    for($a=0;$a<$num_links;$a++)
    {
        $node = int(myrand($random_context, $num_nodes));
        $to_node = int(myrand($random_context, $num_nodes));
        if ($node == $to_node)
        {
            $graph->[$node][$to_node]++;
        }
        else
        {
            $graph->[$node][$to_node]++;
            $graph->[$to_node][$node]++;
        }
    }

    return $graph;
}

my $seed = shift || "102";

my $num_nodes = 15;

#my $random_context = get_new_random_context("57521231279");
#my $random_context = get_new_random_context("5");
#my $random_context = get_new_random_context("15");
#my $random_context = get_new_random_context("789");
#my $random_context = get_new_random_context("1023090");
my $random_context = get_new_random_context($seed);
my ($a, $graph);
for($a=0;$a<100;$a++)
{
    $graph = generate_random_graph($num_nodes, 35, $random_context);
    write_graph_to_file("test_graph.".$a.".txt", $num_nodes, $graph);
}
