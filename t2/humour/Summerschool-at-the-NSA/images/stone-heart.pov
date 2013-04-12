#include "colors.inc"
#include "stones.inc"

global_settings {
   assumed_gamma 1.5
   noise_generator 2
}

box {
   <-0.5, -0.5, -0.5>, <0.5, 0.5, 0.5>

   texture { T_Stone15 }

   scale 1
   rotate <0, 0, 0>
}

light_source {
   <4, 5, 6>, rgb <1, 1, 1>
}

camera {
   perspective
   location <1.0, 1.0, 1.0>
   sky <0, 1, 0>
   direction <0, 0, 1>
   right <1.33333, 0, 0>
   up <0, 1, 0>
   look_at <0, 0, 0>
}

