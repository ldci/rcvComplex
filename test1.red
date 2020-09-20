#!/usr/local/bin/red
Red [
]
#include %rcvComplex.red
;--Red tests

print "Operations on complex numbers" 
print "Creation"
z1: complex/create [3 4]
z2: complex/create [5 -2]
print ["z1 = " complex/sAlgebraic z1]
print ["z2 = " complex/sAlgebraic z2]
z3: complex/negate z2
print ["negate z2 = " complex/sAlgebraic z3]
z3: complex/conjugate z2
print ["conjugate z2 = " complex/sAlgebraic z3]
z4: complex/add z1 z2
print ["z1 + z2 = " complex/sAlgebraic z4]
z4: complex/subtract z1 z2
print ["z1 - z2 = " complex/sAlgebraic z4]
z4: complex/product z1 z2
print ["z1 * z2 = " complex/sAlgebraic z4]
z4: complex/foilProduct z1 z2
print ["z1 * z2 = " complex/sAlgebraic z4]
z4: complex/divide z1 z2
print ["z1 / z2 = " complex/sAlgebraic z4]
z4: complex/scalarProduct z1 2.0
print ["z1 * 2.0 = " complex/sAlgebraic z4]
z4: complex/scalarDivision z1 4.0
print ["z1 / 2.0 = " complex/sAlgebraic z4]
