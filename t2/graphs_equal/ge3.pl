#!/usr/bin/perl

use strict;

use GraphIso;

srand(105);

my ($a);

my $num_graphs=100;

my ($num_nodes, $graph, @graphs);

for($a=0;$a<$num_graphs;$a++)
{
    ($num_nodes, $graphs[$a]) = read_graph_from_file("test_graph.$a.txt");
}

my ($b);

my $count = 0;

for($a=0;$a<$num_graphs;$a++)
{
    for($b=$a;$b<$num_graphs;$b++)
    {
        my $ret = are_graphs_equal($num_nodes, $graphs[$a], $graphs[$b]);

        if ($ret)
        {
            #print "$a == $b.\n";
            if ($a != $b)
            {
                print "$a == $b.\n";
                exit(5);
            }
        }
        else
        {
            #print "$a != $b.\n";
        }
        if ($count++ % 100 == 0)
        {
            print "$count\n";
        }
    }
}

exit(0);

if (0)
{
    my $shuffled_graph = shuffle_graph($num_nodes, $graph);

    my $a = int(rand($num_nodes));
    my $b = int(rand($num_nodes));

    if ($a == $b)
    {
        $shuffled_graph->[$a][$a]++;
    }
    else
    {
        $shuffled_graph->[$a][$b]++;
        $shuffled_graph->[$b][$a]++;
    }
    print (are_graphs_equal($num_nodes, $graph, $shuffled_graph), "\n");
}
