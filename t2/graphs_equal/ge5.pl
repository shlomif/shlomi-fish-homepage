#!/usr/bin/perl

use strict;

use GraphIso;

srand(105);

my ($num_nodes, $graph1, $graph2);

($num_nodes, $graph1) = read_graph_from_file("tg6.txt");
($num_nodes, $graph2) = read_graph_from_file("tg6.txt");

while (1)
{
    my $shuffled_graph = shuffle_graph($num_nodes, $graph2);

    my $g1 = are_graphs_equal_preprocess_graph($num_nodes, $graph1);
    my $g2 = are_graphs_equal_preprocess_graph($num_nodes, $shuffled_graph);

    my $safe_ret = are_graphs_equal($g1, $g2, 1);
    my $non_safe_ret = are_graphs_equal($g1, $g2, 0);

    print "$safe_ret   $non_safe_ret\n";
    if ($safe_ret != $non_safe_ret)
    {
        last;
    }
}
