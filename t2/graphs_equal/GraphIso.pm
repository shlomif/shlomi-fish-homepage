package GraphIso;

use Exporter;

@ISA=qw(Exporter);

@EXPORT=(qw(are_graphs_equal read_graph_from_file shuffle_graph), 
    qw(are_graphs_equal_preprocess_graph));

use strict;

sub numeric_max
{
    my $max = shift;
    foreach (@_)
    {
        if ($_ > $max)
        {
            $max = $_;
        }
    }
    return $max;
}

sub are_graphs_equal_preprocess_graph
{
    my $num_nodes = shift;
    my $graph = shift;
    my $ret = { 'g' => $graph, 'num_nodes' => $num_nodes };
    my ($node, $to_node);

    # Get the maximal link width the graph has
    
    my $max_link_count = 0;
    for($node=0;$node<$num_nodes;$node++)
    {
        for($to_node=0;$to_node<$num_nodes;$to_node++)
        {
            if ($node != $to_node)
            {
                $max_link_count = numeric_max(
                    $max_link_count,
                    $graph->[$node][$to_node]
                    );
            }
        }
    }

    $ret->{'max_link_count'} = $max_link_count;

    return $ret;    
}

sub p2n_transform_iterations
{
    my (@graphs);
    my ($num_nodes, $max_link_count, $orig_ids, $first_call);

    ($num_nodes, 
        $graphs[0], 
        $graphs[1], 
        $max_link_count, 
        $orig_ids, 
        $first_call
    ) = @_;

    my (@prev_ids, @next_ids, $iteration, %id_map, $new_id);
    my ($g, $node, $to_node, @link_ids);
    

    @prev_ids = @{$orig_ids};

    for($iteration=0;$iteration<$num_nodes;$iteration++)
    {
        @next_ids = ([], []);
        %id_map = ();
        $new_id = 0;

        for($g=0;$g<2;$g++)
        {
            for($node=0;$node<$num_nodes;$node++)
            {
                # $link_ids[$w] contain the list of nodes which have
                # a $w-wide link to $node.
                @link_ids = (map { [] } ((0) x $max_link_count));
                
                for($to_node=0;$to_node<$num_nodes;$to_node++)
                {
                    if ($to_node == $node)
                    {
                        $link_ids[0] = $graphs[$g]->[$node][$node];
                    }
                    elsif ($graphs[$g]->[$node][$to_node] > 0)
                    {
                        push 
                            @{$link_ids[
                                $graphs[$g]->[$node][$to_node]
                            ]}, 
                            $prev_ids[$g]->[$to_node];
                    }
                }

                # Serialize the node ID

                my $string;

                if (($iteration == 0) && $first_call)
                {
                    # 1. We only need to consider the number of 
                    # connected nodes and the number of self-links
                    # in the first iteration.
                    #
                    # Afterwards it is part of the information inside
                    # the link ID.
                    #
                    # 2. I use scalar because all the node IDs are 0 
                    # so we can simply count them.
                    
                    $string = join(";",
                        $link_ids[0],
                        (map { scalar(@{$_}) } @link_ids[1 .. $#link_ids])
                    );
                    
                }
                else
                {
                    # The identification string is built from the prev ID
                    # of the node and from the IDs of the nodes that are
                    # connected to it grouped by link width.
                    #
                    # The sort here can be implemented as Counting Sort
                    # because the node IDs are limited to |V|.                    
                    
                    $string = join(";",
                        $prev_ids[$g]->[$node],
                        (map 
                            { join(",", (sort { $a <=> $b } @{$_})); } 
                            @link_ids[1 .. $#link_ids]
                        )
                    );
                }

                if (exists($id_map{$string}))
                {
                    $next_ids[$g]->[$node] = $id_map{$string};
                }
                else
                {
                    if ($g == 1)
                    {
                        return 0;  # I encountered a string that 
                        # wasn't present in the previous graph, so 
                        # the graphs cannot be the same.
                    }
                    else
                    {
                        # Allocate a new ID for this template.
                        $id_map{$string} = $new_id;
                        $next_ids[$g]->[$node] = $new_id;
                        $new_id++;
                    }
                }
            }
        }

        # If there is a different number of nodes from each ID, the 
        # two graphs cannot be isomorphic.
        # 
        # Again, this sort can be Counting Sort.
        if (join(",", (sort { $a <=> $b } @{$next_ids[0]})) ne 
            join(",", (sort { $a <=> $b } @{$next_ids[1]}))   )
        {
            return 0;
        }
        if ((join(",", @{$prev_ids[0]}) eq join(",", @{$next_ids[0]})) &&
            (join(",", @{$prev_ids[1]}) eq join(",", @{$next_ids[1]})) )
        {
            last;
        }            
        @prev_ids = @next_ids;
    }
    return (1, \@next_ids, $new_id);
}

# The recursive part of are_graphs_equal
sub age_recurse
{
    my (@graphs);
    my ($num_nodes, $max_link_count, $orig_ids, $new_id);
    my ($safe);

    ($num_nodes,
        $graphs[0],
        $graphs[1],
        $max_link_count,
        $orig_ids,
        $new_id,
        $safe
    ) = @_;
    
    # If all nodes of each graph contain |V| separate ID it means we have
    # a one to one correlation between the two graphs. So, return true.
    if ($new_id == $num_nodes)
    {
        return 1;
    }
        

    my ($id_to_change, $node, @id_map, $the_id);
    my ($place_to_change);    
    
    # Find an ID that is shared by two or more nodes.

    @id_map = ((0) x $new_id);
    for($node=0;$node<$num_nodes;$node++)
    {
        $the_id = $orig_ids->[0]->[$node];
        if ((++$id_map[$the_id]) == 2)
        {
            $id_to_change = $the_id;
            $place_to_change = $node;
            last;
        }
    }
    
    # Take one node from each graph that was assigned this ID and
    # modify its ID to a non-existant one.


    for($node=0;$node<$num_nodes;$node++)
    {
        if ($orig_ids->[1]->[$node] == $id_to_change)
        {
            my (@updated_ids);
            
            # Generate an IDs configuration with two IDs in the graphs
            # modified to a non-existant ID.
            @updated_ids = ( [ @{$orig_ids->[0]} ], [ @{$orig_ids->[1]} ] );
            $updated_ids[0]->[$place_to_change] = $new_id;
            $updated_ids[1]->[$node] = $new_id;
            
            # Run the @prev_ids -> @next_ids transformation on it |V| times.
            my ($ret, $next_ids, $new_id) = p2n_transform_iterations(
                $num_nodes,
                @graphs,
                $max_link_count,
                \@updated_ids,
                0
                );

            if ($ret)
            {
                # Check the new configuration
                $ret = age_recurse(
                    $num_nodes,
                    @graphs,
                    $max_link_count,
                    $next_ids,
                    $new_id,
                    $safe);

                # If $safe is zero we assume that the first 
                # p2n_transform_iterations can't be wrong.
                if ((!$safe) || $ret)
                {
                    return $ret;
                }
            }
        }
    }

    # We couldn't find a working configuration, so let's return
    # false.

    return 0;
}

# ($ret) = are_graphs_equal($graph_handle1, $graph_handle2, $safe);
#
# The main function as far as the user is concerned.
#
# All it does is call the |V| prev_ids->next_ids transformations once
# and then call age_recurse(). 
#
# It is possible that the algorithm may not work if $safe equals false.
# But then again it usually does.
sub are_graphs_equal
{
    my (@graphs, $safe, $max_link_count, $num_nodes);
    my (@initial_ids);
    my (@graph_handles);

    $graph_handles[0] = shift;
    $graph_handles[1] = shift;
    $safe = shift;

    if ($graph_handles[0]->{'num_nodes'} != $graph_handles[1]->{'num_nodes'})
    {
        return 0;
    }
    $num_nodes = $graph_handles[0]->{'num_nodes'};

    if ($graph_handles[0]->{'max_link_count'} != 
        $graph_handles[1]->{'max_link_count'} )
    {
        return 0;
    }
    $max_link_count = $graph_handles[0]->{'max_link_count'};
      

    @graphs = (map { $_->{'g'} } @graph_handles);

    @initial_ids = ([ (0) x $num_nodes ], [ (0) x $num_nodes ]);

    # Call the |V| @prev_ids->@next_ids once.
    my ($ret, $next_ids, $new_id) = p2n_transform_iterations(
        $num_nodes,
        @graphs,
        $max_link_count,
        \@initial_ids,
        1
        );

    if (!$ret)
    {
        return 0;
    }
    else
    {
        return age_recurse(
            $num_nodes,
            @graphs,
            $max_link_count,
            $next_ids,
            $new_id,
            $safe
            );
    }
}

sub read_graph_from_file
{
    my $filename = shift;

    open I, "<" . $filename;

    my $num_nodes = <I>;
    chomp($num_nodes);

    my $graph = [ (0) x $num_nodes ];
    my ($node);
    for($node=0;$node<$num_nodes;$node++)
    {
        $graph->[$node] = [ (0) x $num_nodes ];
    }

    my (@numbers);

    while (<I>)
    {
        if (! m/\S/)
        {
            last;
        }
        
        @numbers = m/\d+/g;

        if ($numbers[0] == $numbers[1])
        {
            $graph->[$numbers[0]]->[$numbers[1]]++;
        }
        else
        {
            $graph->[$numbers[0]]->[$numbers[1]]++;
            $graph->[$numbers[1]]->[$numbers[0]]++;
        }
    }

    close(I);

    return ($num_nodes, $graph);
}

sub shuffle_graph
{
    my $num_nodes = shift;
    my $orig_graph = shift;

    my $graph = [ (0) x $num_nodes ];
    my ($node, $to_node);
    for($node=0;$node<$num_nodes;$node++)
    {
        $graph->[$node] = [ (0) x $num_nodes ];
    }

    my (@indexes);

    @indexes = ( 0 .. ($num_nodes-1));
    my ($n, $j);

    $n = $num_nodes-1;
    while ($n > 0)
    {
        $j = int(rand($n+1));
        ($indexes[$n], $indexes[$j]) = ($indexes[$j], $indexes[$n]);
        $n--;
    }

    for($node=0;$node<$num_nodes;$node++)
    {
        for($to_node=0;$to_node<$num_nodes;$to_node++)
        {
            $graph->[$indexes[$node]][$indexes[$to_node]] = 
                $orig_graph->[$node][$to_node];
        }
    }

    return $graph;
}

1;
