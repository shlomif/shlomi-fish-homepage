package Shlomif::LMSolver::Tilt::RedBlue;

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
        'red_start' => { 'type' => "xy(integer)", 'required' => 1 },
        'red_goal' => {'type' => "xy(integer)", 'required' => 1 },
        'blue_start' => { 'type' => "xy(integer)", 'required' => 1 },
        'blue_goal' => {'type' => "xy(integer)", 'required' => 1 },        
        'layout' => { 'type' => "layout", 'required' => 1},
    };

    my $input_obj = Shlomif::LMSolver::Input->new();

    my $input_fields = $input_obj->input_board($filename, $spec);

    my ($width, $height) = @{$input_fields->{'dims'}->{'value'}}{'x','y'};
    my ($red_start_x, $red_start_y) = @{$input_fields->{'red_start'}->{'value'}}{'x','y'};
    my ($red_goal_x, $red_goal_y) = @{$input_fields->{'red_goal'}->{'value'}}{'x','y'};
    my ($blue_start_x, $blue_start_y) = @{$input_fields->{'blue_start'}->{'value'}}{'x','y'};
    my ($blue_goal_x, $blue_goal_y) = @{$input_fields->{'blue_goal'}->{'value'}}{'x','y'};

    
    if (($red_start_x >= $width) || ($red_start_y >= $height))
    {
        die "The starting position of the red block is out of bounds of the board in file \"$filename\"!\n";        
    }

    if (($red_goal_x >= $width) || ($red_goal_y >= $height))
    {
        die "The goal position of the red block is out of bounds of the board in file \"$filename\"!\n";        
    }

    if (($blue_start_x >= $width) || ($blue_start_y >= $height))
    {
        die "The starting position of the blue block is out of bounds of the board in file \"$filename\"!\n";        
    }

    if (($blue_goal_x >= $width) || ($blue_goal_y >= $height))
    {
        die "The goal position of the blue block is out of bounds of the board in file \"$filename\"!\n";        
    }
    

    my ($horiz_walls, $vert_walls) = 
        $input_obj->input_horiz_vert_walls_layout($width, $height, $input_fields->{'layout'});

    $self->{'width'} = $width;
    $self->{'height'} = $height;
    $self->{'goals'} = [$red_goal_x, $red_goal_y, $blue_goal_x, $blue_goal_y];

    $self->{'horiz_walls'} = $horiz_walls;
    $self->{'vert_walls'} = $vert_walls;
    
    return [ $red_start_x, $red_start_y, $blue_start_x, $blue_start_y];
}

sub pack_state
{
    my $self = shift;
    my $state_vector = shift;

    return pack("cccc", @$state_vector);
}

sub unpack_state
{
    my $self = shift;
    my $state = shift;
    return [ unpack("cccc", $state) ];
}

sub display_state
{
    my $self = shift;
    my $state = shift;
    my ($rx, $ry, $bx, $by) = (map { $_ + 1} @{$self->unpack_state($state)});
    return ("Red=($rx,$ry) ; Blue=($bx,$by)");
}

sub check_if_unsolveable
{
    my $self = shift;
    my $coords = shift;

    return (($coords->[0] == $coords->[2]) && ($coords->[1] == $coords->[3]));
}

sub check_if_final_state
{
    my $self = shift;

    my $coords = shift;

    return (join(",", @$coords) eq join(",", @{$self->{'goals'}}));
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

    my ($rx, $ry, $bx, $by) = @$coords;

    my ($red_new_coords, $red_intermediate_states) = 
        $self->move_ball_to_end([ $rx, $ry], $move);

    my ($blue_new_coords, $blue_intermediate_states) = 
        $self->move_ball_to_end([ $bx, $by], $move);
    
    return [ @$red_new_coords, @$blue_new_coords ];
}

1;
