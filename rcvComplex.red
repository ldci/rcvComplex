#!/usr/local/bin/red
Red [
	Title:   "Red Computer Vision: Complex Number"
	Author:  "Francois Jouen and Toomas Vooglaid"
	File: 	 %rcvComplex.red
	Tabs:	 4
	Rights:  "Copyright (C) 2020 Red Foundation. All rights reserved."
	License: {
		Distributed under the Boost Software License, Version 1.0.
		See https://github.com/red/red/blob/master/BSL-License.txt
	}
]

;--Red does not support complex numbers (z = a + ib), such as 3+4i, 5-2i, -8+7i or i
;--i (iota) must be expressed as 1.0i
;--1 + i must be expressed as 1.0 + 1.0i
;--i = square-root -1
;--i = square-root -1 -> i^2 = -1	;--magic value for complex numbers
	

complex: context [
	;--Complex Number Object
	complexR: object [
		re:	0.0	;--real part (float!) 
		im: 1.0	;--imaginary part (float!)
	]
	
	create: func [
	"Creates a complex number froma block of integer or float values"
		values	[block!]
		return:	[object!]
		/local 
		_z		[object!]
	][
		_z: copy complexR
		_z/re: to-float values/1
		_z/im: to-float values/2
		_z
	]
	
	negate: func [
	"Returns the opposite of a complex number"
		z		[object!]
		return: [object!]
		/local 
		_z		[object!]
	][
		_z: copy z 
		_z/re: 0.0 - z/re 
		_z/im: 0.0 - z/im 
		_z
	]
	
	conjugate: func [
	"Returns the conjugate of a complex number"
		z		[object!]
		return: [object!]
		/local 
		_z		[object!]
	][
		_z: copy z
		_z/im: 0.0 - _z/im 
		_z
	]
	
	real: func [
	"Returns real part of complex number"
		z		[object!]
		return: [float!]
	][
		z/re
	]
	
	imaginary: func [
	"Returns imaginary part of complex number"
		z		[object!]
		return: [float!]
	][
		z/im
	]
	
	modulus: func [
	"Returns z modulus as a float"
		z		[object!]
		return: [float!]
	][
		square-root ((z/re * z/re) + (z/im * z/im))
	]
	
	argument: func [
	"Return z argument as an angle in radians or degrees"
		z		[object!]
		return: [float!]
		/degrees
	][	
		either degrees [arctangent z/im / z/re][arctangent/radians z/im / z/re]
	]
	
	clog: func [
	"Returns the natural logarithm of any complex number" 
		z		[object!]
		return:	[object!]
		/local 
		_z		[object!]
	][
		_z: copy complexR
		_z/re: log-e modulus z
		_z/im: argument z
		_z
	]
	
	toPolar: func [
	"Breaks a complex number into its polar component"
		z		[object!]
		return: [block!]
	][
		reduce [modulus z argument z]
	]
	

	toCartesian: func [
	"Returns cartesian coordinates from polar components"
		polar	[block!]
		return:	[block!]
	][
		reduce [polar/1 * cos polar/2  polar/1 * sin polar/2]
	]
	
	toComplex: func [
	"Creates a complex number from two values in polar notation"
		polar	[block!]
		return: [object!]
		/rounding		
	][
		_z: copy complexR
		_z/re: polar/1 * cos polar/2
		_z/im: polar/1 * sin polar/2
		if rounding [
			_z/re: round/to _z/re 0.01
			_z/im: round/to _z/im 0.01
		]
		_z
	]
	
	;--Thanks to André Lichnerowicz (1915-1998)
	;--we use a object compatible with matrix object
	toMatrix: func [
	"Transforms complex number to a 2x2 matrix"
		z		[object!]
		return:	[object!]
	][
		;matrix/create 3 64 2x2 reduce [z/re 0.0 - z/im z/im z/re]
		mdata: reduce [z/re 0.0 - z/im z/im z/re]
		mx: object [
				type: 3
				bits: 64
				rows: 2
				cols: 2
				data: make vector! reduce [type bits rows * cols]
		]
		mx/data: mdata
		mx
	]
	
	
	add: func [
	"Adds 2 complex numbers"
		z1		[object!]
		z2		[object!]
		return: [object!]
		/local 
		_z		[object!]
	][
		_z: copy complexR
		_z/re: z1/re + z2/re
		_z/im: z1/im + z2/im
		_z
	]
	
	subtract: func [
	"Subtracts 2 complex numbers"
		z1		[object!]
		z2		[object!]
		return: [object!]
		/local 
		_z		[object!]
	][
		_z: copy complexR
		_z/re: z1/re - z2/re
		_z/im: z1/im - z2/im
		_z
	]
	
	;(a+bi)(c+di) = (ac−bd) + (ad+bc)i; fast
    product: func [
	"Multiplies 2 complex numbers"
		z1		[object!]
		z2		[object!]
		return: [object!]
		/local 
		_z			[object!]
	][
		_z: copy complexR
		_z/re: (z1/re * z2/re) - (z1/im * z2/im)
		_z/im: (z1/re * z2/im) + (z1/im * z2/re)
		_z
	]
    ;FOIL Method (Firsts, Outers, Inners, Lasts)			
	foilProduct: func [
	"Multiplies 2 complex numbers"
		z1		[object!]
		z2		[object!]
		return: [object!]
		/local 
		_z			[object!]
		p1 p2 p3 p4	[float!]
	][
		_z: copy complexR
		p1: z1/re * z2/re		;--real product
		p2: z1/re * z2/im		;--imaginary product
		;we have to process i
		p3: z1/im * z2/re		;--we get i*i
		p4: z1/im * z2/im * -1	;-- * i^2 = -1
		_z/re: p1 + p4			;--real part
		_z/im: p2 + p3			;--imaginary part
		_z
	]
	
	divide: func [
	"Divides 2 complex numbers"
		z1		[object!]
		z2		[object!]
		return: [object!]
		/local 
		_z		[object!]
	][
		_z: copy complexR
		c: conjugate z2
		p1: product z1 c
		p2: product z2 c
		_z/re:  p1/re / p2/re 
		_z/im:  p1/im / p2/re
		_z
	]
	
	scalarProduct: func [
	"Multiplies a complex number by a scalar"
		z		[object!]
		scalar	[float!]
		return: [object!]
		/local 
		_z		[object!]
	][
		_z: copy complexR
		_z/re: z/re * scalar
		_z/im: z/im * scalar
		_z
	]
	
	scalarDivision: func [
	"Divides a complex number by a scalar"
		z		[object!]
		scalar	[float!]
		return: [object!]
		/local 
		_z		[object!]
	][
		_z: copy complexR
		_z/re: z/re / scalar
		_z/im: z/im / scalar
		_z
	]
	
	;-- for printing complex numbers
	sAlgebraic: func [
	"Returns algebraic notation of a complex number as a string"
		z		[object!]
		return: [string!]
	][
		;s:  "0.0+1.0i"	;--algebraic representation of z
		s: form z/re
		if z/im >= 0.0 [append s "+"]
		append s form z/im
		append s "i"
		s
	]
	
	sPolar: func [
	"Returns polar notation of a complex number as a string"
		z		[object!]
		return: [string!]
	][
		;x + iy =	r cos θ + i r sin θ
		;cis is just shortcut for cos θ + i sin θ
		str: form modulus z
		append str " cis " 
		append str argument z
		str
	]
];--end of context






