#!/usr/bin/env perl

use strict;
use warnings;

use SDL;
use SDL::Video;
use SDL::Rect;
use SDL::Event;
use SDL::Events;
use SDL::Surface;

my $LOG2_DEGREES_RANGE = 9;
my $DEGREES_RANGE      = 1 << $LOG2_DEGREES_RANGE;
my $DEGREES_RANGE_M_1  = ( $DEGREES_RANGE - 1 );

#sub DEG_MOD { return ($_[0]&($DEGREES_RANGE_M_1));}

my $mycont = 1;

my %options;

$options{'flags'}  = SDL_SWSURFACE;
$options{'-title'} = 'flag.pl';

$options{'width'}  = 640;
$options{'height'} = 480;
$options{'depth'}  = 32;

my $app = SDL::Video::set_video_mode(
    $options{'width'}, $options{'height'},
    $options{'depth'}, $options{'flags'}
);

my $x_num_points = 20;
my $y_num_points = 10;
my $x_x_offset   = 20;
my $x_y_offset   = 0;
my $y_x_offset   = 3;
my $y_y_offset   = 10;
my $y_amplitude  = 10.0;
my $y_amp_delta  = 50;
my $x_amp_delta  = 20;

# This is so it won't get out of the end of the screen
my $y_abs_offset = 20;
my $x_abs_offset = 10;
my @sin_lookup   = map { 0 } ( 1 .. $DEGREES_RANGE );

my ( $x, $y, $t, $prev_t );
my $prev_y_height;
my $this_y_height;
my ( $x_pos, $y_pos );

my ( $y_acc_degree,      $y_x_acc_degree );
my ( $prev_y_acc_degree, $prev_y_x_acc_degree );
my ( $y_acc_y_pos,       $y_acc_x_pos );

my $screen = $app;
my (@rects);
my $the_rect;

my $a;

my $PI = 3.1415926535;

for ( $a = 0 ; $a < $DEGREES_RANGE ; $a++ )
{
    $sin_lookup[$a] =
        int( sin( ( 2 * $PI / $DEGREES_RANGE ) * $a ) * $y_amplitude );
}

my $fill_color = SDL::Video::map_RGB( $screen->format(), 0xFF, 0xFF, 0xFF );
my $pen_color  = SDL::Video::map_RGB( $screen->format(), 0x00, 0x00, 0x00 );

@rects = map { SDL::Rect->new( 0, 0, 1, 2 ); }
    ( 1 .. ( $x_num_points * $y_num_points ) );

#
# Calculate all the x positions of the rects in advance
#
$the_rect    = 0;
$y_acc_x_pos = $x_abs_offset;
for ( $y = 0 ; $y < $y_num_points ; $y++ )
{
    $x_pos = $y_acc_x_pos;
    for ( $x = 0 ; $x < $x_num_points ; $x++ )
    {
        $rects[$the_rect]->x($x_pos);
        $the_rect++;
        $x_pos += $x_x_offset;
    }
    $y_acc_x_pos += $y_x_offset;
}

# Mark: Fill the whole screen
{
    my $whole_screen_rect = SDL::Rect->new( 0, 0, 640, 480 );
    SDL::Video::fill_rect( $screen, $whole_screen_rect, $fill_color );
    SDL::Video::update_rects( $screen, $whole_screen_rect, );
}

sub putpixel
{
    my ( $x, $y, $color ) = @_;
    my $lineoffset = $y * ( $screen->pitch / 4 );
    $screen->set_pixels( $lineoffset + $x, $color );
}

my $event = SDL::Event->new();

my %events = ( SDL_QUIT() => sub { $mycont = 0; }, );

$prev_t = 0;
for ( $t = 1 ; $mycont ; $t = ( ( $t + 1 ) & ( $DEGREES_RANGE - 1 ) ) )
{
    $the_rect = 0;

    $y_acc_degree      = $t;
    $prev_y_acc_degree = $prev_t;
    $y_acc_y_pos       = $y_abs_offset;
    $y_acc_x_pos       = $x_abs_offset;
    for ( $y = 0 ; $y < $y_num_points ; $y++ )
    {
        $y_x_acc_degree      = $y_acc_degree;
        $prev_y_x_acc_degree = $prev_y_acc_degree;

        $x_pos = $y_acc_x_pos;
        $y_pos = $y_acc_y_pos;
        for ( $x = 0 ; $x < $x_num_points ; $x++ )
        {
            $prev_y_height = $y_pos + $sin_lookup[$prev_y_x_acc_degree];
            $this_y_height = $y_pos + $sin_lookup[$y_x_acc_degree];

            $rects[$the_rect]->y(
                (
                    ( $prev_y_height < $this_y_height )
                    ? $prev_y_height
                    : $this_y_height
                )
            );
            $the_rect++;

            # I don't need to lock the screen, so I'm omitting it */

            putpixel( $x_pos, $prev_y_height, $fill_color );

            putpixel( $x_pos, $this_y_height, $pen_color );

            $y_x_acc_degree =
                ( $y_x_acc_degree + $x_amp_delta ) & ($DEGREES_RANGE_M_1);
            $prev_y_x_acc_degree =
                ( $prev_y_x_acc_degree + $x_amp_delta ) & ($DEGREES_RANGE_M_1);
            $x_pos += $x_x_offset;
            $y_pos += $x_y_offset;
        }
        $y_acc_degree = ( $y_acc_degree + $y_amp_delta ) & ($DEGREES_RANGE_M_1);
        $prev_y_acc_degree =
            ( $prev_y_acc_degree + $y_amp_delta ) & ($DEGREES_RANGE_M_1);
        $y_acc_y_pos += $y_y_offset;
        $y_acc_x_pos += $y_x_offset;
    }

    SDL::Video::update_rects( $screen, @rects );

    #$app->update();

    $prev_t = $t;
    SDL::Events::pump_events();
    SDL::Events::poll_event($event);
    if ( $events{ $event->type() } )
    {
        &{ $events{ $event->type() } };
    }
}

__END__
