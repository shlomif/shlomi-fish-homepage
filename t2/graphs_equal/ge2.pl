#!/usr/bin/perl

use strict;

use GraphIso;

srand(105);

my ($num_nodes, $graph);

($num_nodes, $graph) = read_graph_from_file("tg2.txt");

while (1)
{
    my $shuffled_graph = shuffle_graph($num_nodes, $graph);

    my $g1 = are_graphs_equal_preprocess_graph($num_nodes, $graph);
    my $g2 = are_graphs_equal_preprocess_graph($num_nodes, $shuffled_graph);

    my $safe_ret = are_graphs_equal($g1, $g2, 1);
    my $non_safe_ret = are_graphs_equal($g1, $g2, 0);

    print "$safe_ret   $non_safe_ret\n";
    if ($safe_ret != $non_safe_ret)
    {
        last;
    }
}
