; bugs.scm
;
; This script creates a series of squares inside each other, to resemble
; the path of the bugs in the bugs following each other problem, in case the
; bugs are not entirely infinitesimal.
;
; Copyright (C) 1999, 2004 Shlomi Fish
;
; This file can be freely used, modified and distributed under the terms of
; the MIT X11 license.
;
; INSTRUCTIONS:
; Put this file in your ~/.gimp/scripts directory. Run the gimp and
; select the "Xtns -> Script-Fu -> Shlomif -> Bugs" menu item.



; A function to automatically construct one of those INT32ARRAYs or FLOATARRYs
; out of standard Scheme lists
(define (general-array type coords)
    (define array (cons-array (length coords) type))
    (define a 0)
    (while (< a (length coords))
        (aset array a (nth a coords))
        (define a (+ a 1))
    )
    array
)

(define (points-array coords)
    (general-array 'double coords)
)

; A macro to call gimp-pencil with a list as coordinates
(define (my-pencil drawable coords)
    (gimp-pencil drawable (length coords) (points-array coords))
)

(define (regular-brush)
  (gimp-brushes-set-brush "Circle (01)")
)

(define (path-brush)
  (gimp-brushes-set-brush "Circle (03)")
)

(define (my-path-pencil drawable coords)
  (path-brush)
  (my-pencil drawable coords)
  (regular-brush)
)

(define (script-fu-shlomif1-bugs width height bMarkPath ratio)
    (let* (
         (img (car (gimp-image-new (+ width 20) (+ height 20) RGB)))
         (bg-layer (car (gimp-layer-new img (+ width 20) (+ height 20) RGB_IMAGE "Background" 100 NORMAL)))
         (coords (list 10 10 (+ 10 width) 10 (+ 10 width) (+ 10 height) 10 (+ 10 height)))
         (new-coords (make-list 8 0))
         (old-bg (car (gimp-palette-get-background)))
         (a 0)
         (old-brush (car (gimp-brushes-get-brush)))
         (squares '())
         (path-x 10)
         (path-y 10)
    )

         (gimp-image-add-layer img bg-layer 1)

         (gimp-palette-set-background '(255 255 255))
         ;(gimp-edit-fill img bg-layer)
         (gimp-edit-fill bg-layer BG-IMAGE-FILL)
         (gimp-palette-set-background old-bg)


         ; Set the ratio to a value between 0 and 1
         (if (< ratio 0)
             (set! ratio (* ratio -1))
         )
         (if (> ratio 1)
             (set! ratio (/ 1 ratio))
         )
         (if (or (= ratio 0) (= ratio 1))
             (set! ratio 0.1)
         )


         (regular-brush)

         ; We generate the points for all the squares, and put them inside
         ; one big list.
         (while (> (+
            (*
                (- (nth 2 coords) (nth 0 coords))
                (- (nth 2 coords) (nth 0 coords))
         )
            (*
                (- (nth 3 coords) (nth 1 coords))
                (- (nth 3 coords) (nth 1 coords))
            ))
            3
         )

            (my-pencil bg-layer (append coords (list (nth 0 coords) (nth 1 coords))))
             ; (set! squares (append squares coords (list (nth 0 coords) (nth 1 coords))))
             (set! a 0)
             (set! new-coords '())
             (while (< a 8)
                  (set! new-coords (append new-coords (list (+
                       (* (- 1 ratio) (nth a coords))
                       (* ratio (nth (fmod (+ a 2) 8) coords))
                       ))))
                  (set! a (+ a 1))
             )
             ; The path of a single bug.
             (my-path-pencil bg-layer (list path-x path-y (nth 0 coords) (nth 1 coords)))
             (set! path-x (nth 0 coords))
             (set! path-y (nth 1 coords))
             ; (set! path (append path (list (nth 0 coords) (nth 1 coords))))
             (set! coords new-coords)
         )

         (gimp-brushes-set-brush old-brush)

         (gimp-display-new img)
    )
)


(script-fu-register "script-fu-shlomif1-bugs"
                    "<Toolbox>/Xtns/Script-Fu/Shlomif/Bugs"
                    "Bugs in a square image"
                    "Shlomi Fish <shlomif@shlomifish.org>"
                    "Shlomi Fish"
                    "September 1998"
                    ""
                    SF-VALUE "Width" "200"
                    SF-VALUE "Height" "200"
                    SF-TOGGLE "Mark Path?" TRUE
                    SF-VALUE "Ratio" "0.1"
                    )

