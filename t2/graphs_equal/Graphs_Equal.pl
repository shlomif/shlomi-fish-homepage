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
    $graphs[$a] = are_graphs_equal_preprocess_graph($num_nodes, $graphs[$a]);
}

my ($b);

my $count = 0;

my (@param_graphs);

for($a=0;$a<$num_graphs;$a++)
{
    for($b=$a;$b<$num_graphs;$b++)
    {
        if ($a == $b)
        {
            @param_graphs = (
                $graphs[$a], 
                eval {
                    my $g = {%{$graphs[$b]}};
                    $g->{'g'} = shuffle_graph($num_nodes, $g->{'g'});
                    $g;
                }
                );
        }
        else
        {
            @param_graphs = @graphs[$a,$b];
        }
        my $ret_safe = are_graphs_equal(@param_graphs, 1);
        my $ret_unsafe = are_graphs_equal(@param_graphs, 0);

        if ($ret_safe != $ret_unsafe)
        {
            print "$a ? ($ret_safe $ret_unsafe) ? $b\n";
            exit (5);
        }
        if ($ret_safe)
        {
            #print "$a == $b.\n";
            if ($a != $b)
            {
                print "$a == $b.\n";
                exit(5);
            }
        }
        elsif ((!$ret_safe) && ($a == $b))
        {
            print "$a != $b.\n";
            exit(5);
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
