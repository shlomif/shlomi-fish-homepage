#!/usr/bin/perl

use strict;

use GraphIso;

use Data::Dumper;

my ($g1, $num_nodes, $g2);
($num_nodes, $g1) = read_graph_from_file("tg0.txt");
($num_nodes, $g2) = read_graph_from_file("tg1.txt");
print (are_graphs_equal($num_nodes, $g1, $g2), "\n");

exit(0);

srand(105);

my ($a);

my $num_graphs=20;

my ($num_nodes, $graph, @graphs);

for($a=0;$a<$num_graphs;$a++)
{
    ($num_nodes, $graphs[$a]) = read_graph_from_file("test_graph.$a.txt");
}

while(1)
{
    my $a = int(rand($num_graphs));
    my $b = int(rand($num_graphs));

    my $shuffled_graph = shuffle_graph($num_nodes, $graphs[$b]);

    my $ret = are_graphs_equal($num_nodes, $graphs[$a], $shuffled_graph);

    if ($ret)
    {
        print "$a == $b.\n";
    }
    else
    {
        print "$a != $b.\n";
    }
}

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
