package Shlomif::LMSolver::Tilt::Multi;

use strict;

use Shlomif::LMSolver::Tilt::Base;

use Shlomif::LMSolver::Input;

use vars qw(@ISA);

@ISA=qw(Shlomif::LMSolver::Tilt::Base);

sub input_board
{
    my $self = shift;
    my $filename = shift;
    
    my $spec = 
    {
        'dims' => { 'type' => "xy(integer)", 'required' => 1 },
        'start' => { 'type' => "xy(integer)", 'required' => 1 },
        'goals' => {'type' => "array(xy(integer))", 'required' => 1 },
        'layout' => { 'type' => "layout", 'required' => 1},
    };

    my $input_obj = Shlomif::LMSolver::Input->new();

    my $input_fields = $input_obj->input_board($filename, $spec);

    my ($width, $height) = @{$input_fields->{'dims'}->{'value'}}{'x','y'};
    my ($start_x, $start_y) = @{$input_fields->{'start'}->{'value'}}{'x','y'};

    
    if (($start_x >= $width) || ($start_y >= $height))
    {
        die "The Starting position is out of bounds of the board in file \"$filename\"!\n";        
    }

    my @goals_map = map { [ (0) x $width ] } (1 .. $height);
    my $goals = $input_fields->{'goals'}->{'value'};
    my $goal_id = 1;
    foreach my $g (@$goals)
    {
        my $x = $g->{'x'};
        my $y = $g->{'y'};
        if (($x >= $width) || ($y >= $height))
        {
            die "The goal ($x,$y) is out of bounds of the board in file \"$filename\"!\n";
        }
        $goals_map[$y]->[$x] = $goal_id;
        $goal_id++;
    }

    my ($horiz_walls, $vert_walls) = 
        $input_obj->input_horiz_vert_walls_layout($width, $height, $input_fields->{'layout'});

    $self->{'width'} = $width;
    $self->{'height'} = $height;
    $self->{'horiz_walls'} = $horiz_walls;
    $self->{'vert_walls'} = $vert_walls;
    $self->{'goals_map'} = \@goals_map;
    $self->{'num_goals'} = ($goal_id-1);

    my $reached_goals_bitmap = 0;

    my $dest_goals_bitmap = 0;
    for(my $i=1;$i<$goal_id;$i++)
    {
        $dest_goals_bitmap |= (1 << $i);
    }
    
    $self->{'dest_goals_bitmap'} = $dest_goals_bitmap;
    
    return [ $start_x, $start_y, $reached_goals_bitmap ];
}

sub pack_state
{
    my $self = shift;
    my $state_vector = shift;

    return pack("ccL", @$state_vector);
}

sub unpack_state
{
    my $self = shift;
    my $state = shift;
    return [ unpack("ccL", $state) ];
}

sub display_state
{
    my $self = shift;
    my $state = shift;
    my ($x, $y, $reached_goals) = (map { $_ + 1} @{$self->unpack_state($state)});
    return "($x,$y) Goals Collected=[" . join(",", (grep { $reached_goals &= (1 << $_) } (1 .. ($self->{'num_goals'})))) . "]";
}

sub check_if_unsolveable
{
    my $self = shift;
    my $coords = shift;

    return 0;
}

sub check_if_final_state
{
    my $self = shift;

    my $coords = shift;

    return ($coords->[2] == $self->{'dest_goals_bitmap'});
}

sub enumerate_moves
{
    my $self = shift;
    my $coords = shift;

    return (qw(u d l r));
}

sub perform_move
{
    my $self = shift;

    my $coords = shift;
    my $move = shift;

    my ($new_coords, $intermediate_states) = 
        $self->move_ball_to_end($coords, $move);

    my $goal_bitmap = $coords->[2];

    my $goals_map = $self->{'goals_map'};
    foreach my $state (@$intermediate_states)
    {
        my ($x,$y) = @$state;
        my $goal = $goals_map->[$y]->[$x];
        #printf("Goal=%i\n", $goal);
        if ($goal > 0)
        {
            $goal_bitmap |= (1<<$goal);
        }
    }
    
    return [ @$new_coords, $goal_bitmap];
}

1;
