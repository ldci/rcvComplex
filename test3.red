#!/usr/local/bin/red
Red [
]
#include %rcvComplex.red
;--Red tests

print "Complex log test"

z1: complex/create [0.0 1.0]
z2: complex/clog z1
print complex/sAlgebraic z2

z1: complex/create [1.0 1.0]
z2: complex/clog z1
print complex/sAlgebraic z2

z1: complex/create [2.0 1.0]
z2: complex/clog z1
print complex/sAlgebraic z2

z1: complex/create [3.0 1.0]
z2: complex/clog z1
print complex/sAlgebraic z2

z1: complex/create [1.0 2.0]
z2: complex/clog z1
print complex/sAlgebraic z2
