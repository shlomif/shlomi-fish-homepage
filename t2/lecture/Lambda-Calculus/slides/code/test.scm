(load "div_test.scm")

(newline)
(display "Result is : ")
(display (church->int ((reminder (int->church 100)) (int->church 7))))
(newline)
