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

    # Get how many nodes are reachable from every node by means
    # of DFS/BFS.

    my (%connected_nodes, @num_connected_nodes);

    @num_connected_nodes = ((-1) x $num_nodes);

    for($node=0;$node<$num_nodes;$node++)
    {
        if ($num_connected_nodes[$node] == -1)
        {
            %connected_nodes = ();

            my (@nodes_to_visit, $n, $tn);

            @nodes_to_visit = ($node);

            while (scalar(@nodes_to_visit))
            {
                #$n = shift(@nodes_to_visit);   # For BFS
                $n = pop(@nodes_to_visit);     # For DFS
                if (!exists($connected_nodes{$n}))
                {
                    $connected_nodes{$n} = 1;
                    for($tn=0;$tn<$num_nodes;$tn++)
                    {
                        if ( ($graph->[$n][$tn] > 0) &&
                             (!exists($connected_nodes{$n})) )
                        {
                            push @nodes_to_visit, $tn;
                        }
                    }
                }
            }

            foreach my $n (keys(%connected_nodes))
            {
                $num_connected_nodes[$n] = scalar(keys(%connected_nodes));
            }
        }
    }

    $ret->{'num_connected_nodes'} = [ @num_connected_nodes ] ;

    return $ret;    
}

sub are_graphs_equal
{
    my (@graphs);
    my (@graph_handles);
    
    $graph_handles[0] = shift;
    $graph_handles[1] = shift;

    # If the two graph do not have the same number of nodes then they 
    # are certainly not isomorphic.
    if ($graph_handles[0]->{'num_nodes'} != $graph_handles[1]->{'num_nodes'})
    {
        return 0;
    }

    my $num_nodes = $graph_handles[0]->{'num_nodes'};

    @graphs = (map { $_->{'g'} } @graph_handles);

    

    my (@prev_ids, @next_ids, %id_map);

    # Initial value for the prev_ids: all zeros
    @prev_ids = ([ (0) x $num_nodes ], [ (0) x $num_nodes ]);

    my ($iteration, $node, $g, $to_node, @link_ids, $max_link_count, $new_id);
    my ($super_iteration);

    # If the graphs do not have the same maximum for width of link, they
    # are not isomorphic.

    if ($graph_handles[0]->{'max_link_count'} != $graph_handles[1]->{'max_link_count'})
    {
        return 0;
    }
    $max_link_count = $graph_handles[0]->{'max_link_count'};
   
    # Retrieve the number of nodes which are reachable from every node in the 
    # graph.
    my (@num_connected_nodes);

    @num_connected_nodes = (map { [ @{$_->{'num_connected_nodes'}} ] } @graph_handles);
    
    for($super_iteration=0;$super_iteration<$num_nodes;$super_iteration++)
    {
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

                    if (($iteration == 0) && ($super_iteration == 0))
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
                            $num_connected_nodes[$g]->[$node],
                            $link_ids[0],
                            (map { scalar(@{$_}) } @link_ids[1 .. $#link_ids])
                        );
                        
                    }
                    else
                    {
                        # The identification string is built from the prev ID
                        # of the node and from the IDs of the nodes that are
                        # connected to it grouped by link width.
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
            if (join(",", (sort { $a <=> $b } @{$next_ids[0]})) ne 
                join(",", (sort { $a <=> $b } @{$next_ids[1]}))   )
            {
                return 0;
            }
            @prev_ids = @next_ids;
        }
        if ($new_id == $num_nodes)
        {
            return 1;
        } 
        {
            my (@sorted_ids, $i, $id_to_change);
            
            # Find an ID that is shared by two or more nodes.
            
            @sorted_ids = (sort {$a <=> $b } @{$prev_ids[0]});
            for($i=0;$i<$num_nodes;$i++)
            {
                if ($sorted_ids[$i] == $sorted_ids[$i+1])
                {
                    $id_to_change = $sorted_ids[$i];
                    last;
                }
            }
            
            # Take one node from each graph that was assigned this ID and
            # modify its ID to a non-existant one.
            
            for($g=0;$g<2;$g++)
            {
                for($i=0;$i<$num_nodes;$i++)
                {
                    if ($prev_ids[$g]->[$i] == $id_to_change)
                    {
                        $prev_ids[$g]->[$i] = $new_id;
                        last;
                    }
                }
            }
        }
    }

    return 1;
}
