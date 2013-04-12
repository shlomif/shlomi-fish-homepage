#include "colors.inc"
#include "stones.inc"
#include "functions.inc"

global_settings {
   assumed_gamma 1.5
   noise_generator 2
}

//box {
//   <-0.5, -0.5, -0.5>, <0.5, 0.5, 0.5>
//
//   texture { T_Stone15 }
//
//   scale 1
//   rotate <0, 0, 0>
//}

isosurface { //-------------------------
    function { f_heart( x,y,z, -0.15)}
    threshold 0
    accuracy 0.0001
    max_gradient 100
    contained_by { box{<-1.1,-1.5,-1.1>,<1.1,1.22,1.5>}}

    //texture { pigment { color rgb<1,0.7,0.1>}
    //    finish { phong 1 specular 0.3}
    //} // end of texture
    texture { T_Stone15 }
    scale <1,1,1>*1.0
    rotate <-90, 90, 0>
    translate <0,1.3,0>
} // end of isosurface ----------------

light_source {
   <4, 5, 6>, rgb <1, 1, 1>
}

camera {
   perspective
   location <1.0, 5.0, 5.0>
   sky <0, 1, 0>
   direction <0, 0, 1>
   right <1.33333, 0, 0>
   up <0, 1, 0>
   look_at <0, 0, 0>
}

