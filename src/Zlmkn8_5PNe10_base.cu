/*

PN Teukolsky amplitudes at infinity: Z_lmkn8_5PNe10  

 --Sasaki and Tagoshi
    PTEP 2015 (2015) no.3, 033E01: 1412.5689

 8th Nov. 2020; Sis


Convention
 Zlmkn8  = ( hat_Zlmkn8 * exp(-I * (B_inc - FH_ini) )
 
 with initial orbital prameters: r=p/(1-e); \theta = 90; d\cos\theta/dt>0 [RF: 2020/09/12].

The phase factor associated with the initial orbital condition 

 FH_ini = Pi * (n - k/2)

 may be needed ONLY WHEN adjusting the initial phase to the exact amplitude data by RF.
 The initial orbital data of Z(NUM, RF) is  r = p / (1 + e); \theta := 90 - \inc.
 [N.B. The phase "FH_ini" is code specific, and the above choice work ONLY FOR the BHPC codes]


 Current PN order of Teukolaksy amplitude :
 O(v^10, e^10) in (e, Y, v), up to ell = 12

 Shorthad variables for PN amplitudes  in `inspiral_orb_data`
 lnv = ln(v), K = sqrt(1. - q^2 ); y = sqrt(1. -  Y^2) ;
 Ym = Y - 1.0 , Yp = Y + 1.0 ;

PNq[11] = 1, q, q ^2, ..., q ^ 9, q ^ 10
PNe[11] = 1, e, e ^ 2, ..., e ^ 9, e ^ 10
PNv[11] = v ^ 8, v ^ 9, ..., v ^ 17, v ^ 18

PNYp[13] = 1, Yp, Yp^2, ...,  Yp^12
PNY[13]  = 1, Y, Y ^ 2, ..., Y ^ 1, Y ^ 12
PNy[25]  = 1, y, y ^ 2, ..., y ^ 23, y ^ 24


 WARGNING !!
`hZ_lmkn8_5PNe10` stores  only the PN amplitudes that has the index
m + k + n > 0 and m + k + n = 0 with n <= 0
This manifestly guarantees that omega_mkn > 0. 

 Other modes should be computed from the symmetry relation in `Zlmkn8.c`:
 Z8[l, -m, -k, -n] = (-1)^(l + k) * conjugate(Z8_[l, m, k, n])

// ZERO-modes (k+m+n=0) can be tricky to switch. 
The relevant zero modes up to 5PN are below: 

## Zlmkn8[l, m, k, n]: 
zlmkn8[2 -2 3 -1] = O(v^17)
zlmkn8[2 -2 4 -2] = O(v^16)
zlmkn8[2 -1 2 -1] = O(v^17)
zlmkn8[2 -1 3 -2] = O(v^16)
zlmkn8[2 0 1 -1] = O(v^17)
zlmkn8[2 0 2 -2] = O(v^16)
zlmkn8[2 1 0 -1] = O(v^17)
zlmkn8[2 1 1 -2] = O(v^16)
zlmkn8[2 2 -1 -1] = O(v^17)
zlmkn8[2 2 0 -2] = O(v^16)

all the other zero modes are NULL up to 5PNe10 (up to ell = 12).

ell = 12 ONLY includes (m + k) = 0 (mod 2): NEEDS SEPARATE TREATMENT
 (see the function `hZ_12mkn`)

*/


// C headers 
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "Utility.hh"
#include "Spheroidal_PN.h"

// GSL headers
//#include<gsl/gsl_math.h>
//#include<gsl/cmplx.h>
//#include<gsl/cmplx_math.h>

#include "global.h"
#include "Zlmkn8_5PNe10.h"
//#include "cuda_complex.hpp"
#include <stdio.h>

// BHPC headers
//#include "inspiral_waveform.h"


// Teukolsky amplitudes hat_Z_5PNe10 (ell = 2)
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkP10_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkP9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkP8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkP7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkP6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkP5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkP4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkP3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkP2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkP1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkP0_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkM1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkM2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkM3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkM4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=2/hZ_2mkM5_5PNe10.h"

// Teukolsky amplitudes hat_Z_5PNe10 (ell = 3)
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkP10_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkP9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkP8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkP7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkP6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkP5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkP4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkP3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkP2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkP1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkP0_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkM1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkM2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkM3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkM4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkM5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=3/hZ_3mkM6_5PNe10.h"

// Teukolsky amplitudes hat_Z_5PNe10 (ell = 4)
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkP10_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkP9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkP8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkP7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkP6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkP5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkP4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkP3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkP2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkP1_5PNe10.h" 
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkP0_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkM1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkM2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkM3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkM4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkM5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkM6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=4/hZ_4mkM7_5PNe10.h"

/*
// Teukolsky amplitudes hat_Z_5PNe10 (ell = 5)
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkP10_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkP9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkP8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkP7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkP6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkP5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkP4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkP3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkP2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkP1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkP0_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkM1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkM2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkM3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkM4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkM5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=5/hZ_5mkM6_5PNe10.h"

// Teukolsky amplitudes hat_Z_5PNe10 (ell = 6)
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkP10_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkP9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkP8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkP7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkP6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkP5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkP4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkP3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkP2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkP1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkP0_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkM1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkM2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkM3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkM4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkM5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkM6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=6/hZ_6mkM7_5PNe10.h"

// Teukolsky amplitudes hat_Z_5PNe10 (ell = 7)
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkP10_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkP9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkP8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkP7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkP6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkP5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkP4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkP3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkP2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkP1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkP0_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkM1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkM2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkM3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkM4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkM5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkM6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkM7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=7/hZ_7mkM8_5PNe10.h"

// Teukolsky amplitudes hat_Z_5PNe10 (ell = 8)
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkP10_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkP9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkP8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkP7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkP6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkP5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkP4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkP3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkP2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkP1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkP0_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkM1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkM2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkM3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkM4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkM5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkM6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkM7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkM8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=8/hZ_8mkM9_5PNe10.h"

// Teukolsky amplitudes hat_Z_5PNe10 (ell = 9)
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkP10_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkP9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkP8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkP7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkP6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkP5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkP4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkP3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkP2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkP1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkP0_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkM1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkM2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkM3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkM4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkM5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkM6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkM7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkM8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=9/hZ_9mkM9_5PNe10.h"

// Teukolsky amplitudes hat_Z_5PNe10 (ell = 10)
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkP10_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkP9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkP8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkP7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkP6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkP5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkP4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkP3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkP2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkP1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkP0_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkM1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkM2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkM3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkM4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkM5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkM6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkM7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkM8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=10/hZ_10mkM9_5PNe10.h"

// Teukolsky amplitudes hat_Z_5PNe10 (ell = 11)
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkP10_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkP9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkP8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkP7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkP6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkP5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkP4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkP3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkP2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkP1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkP0_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkM1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkM2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkM3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkM4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkM5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkM6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkM7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkM8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkM9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=11/hZ_11mkM10_5PNe10.h"

// Teukolsky amplitudes hat_Z_5PNe10 (ell = 12)
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkP10_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkP9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkP8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkP7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkP6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkP5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkP4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkP3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkP2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkP1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkP0_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkM1_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkM2_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkM3_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkM4_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkM5_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkM6_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkM7_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkM8_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkM9_5PNe10.h"
#include "hat_Zlmkn8_5PNe10/ell=12/hZ_12mkM10_5PNe10.h"
*/
/*-*-*-*-*-*-*-*-*-*-*-* Global variables (but used only within Zlmkn8_5PNe10.c) *-*-*-*-*-*-*-*-*-*-*-*/
//static double pi = M_PI;
//static double m_2pi = 2.0 * M_PI;

/* Cut off numbers for `inspiral_orb_PNvar` (ell_max = 12 with 5PNe10)*/
CUDA_CALLABLE_MEMBER static int PNq_max = 11;
CUDA_CALLABLE_MEMBER static int PNe_max = 11;
CUDA_CALLABLE_MEMBER static int PNv_max = 11;

CUDA_CALLABLE_MEMBER static int PNY_max = 13;
CUDA_CALLABLE_MEMBER static int PNYp_max = 13;
CUDA_CALLABLE_MEMBER static int PNy_max = 25;


/*-*-*-*-*-*-*-*-*-*-*-* Global functions (used only within Zlmkn8_5PNe10.c) *-*-*-*-*-*-*-*-*-*-*-*/
CUDA_CALLABLE_MEMBER
static inline int zero_modes (const int m, const int k, const int n) { 

    /* Exceptional zero modes (|n| < 2! )*/
    //zlmkn8[2 - 2 3 - 1] = O(v ^ 17)
    //zlmkn8[2 - 2 4 - 2] = O(v ^ 16)
    //zlmkn8[2 - 1 2 - 1] = O(v ^ 17)
    //zlmkn8[2 - 1 3 - 2] = O(v ^ 16)
    //zlmkn8[2 0 1 - 1] = O(v ^ 17)
    //zlmkn8[2 0 2 - 2] = O(v ^ 16)
    //zlmkn8[2 1 0 - 1] = O(v ^ 17)
    //zlmkn8[2 1 1 - 2] = O(v ^ 16)
    //zlmkn8[2 2 - 1 - 1] = O(v ^ 17)
    //zlmkn8[2 2 0 - 2] = O(v ^ 16)

     /* bool values: TRUE:1, FALSE: 0 */
    /* Return TRUE: 1 if zero modes of Zlmkn8 vanishes*/
    /* Return FALSE: 0 if zero modes of Zlmkn8 survives*/

    if ( (m + k + n) != 0) {
        ////perror("Parameter errors: zero_modes in `Zlmkn8_5PNe10.c`");
        ////exit(1);
    }
    else if (m == -2 && k == 3 && n == -1) {
        return 0;
    }
    else if (m == -2 && k == 4 && n == -2) {
        return 0;
    }
    else if (m == -1 && k == 2 && n == -1) {
        return 0;
    }
    else if (m == -1 && k == 3 && n == -2) {
        return 0;
    }
    else if (m == 0 && k == 1 && n == -1) {
        return 0;
    }
    else if (m == 0 && k == 2 && n == -2) {
        return 0;
    }
    else if (m == 1 && k == 0 && n == -1) {
        return 0;
    }
    else if (m == 1 && k == 1 && n == -2) {
        return 0;
    }
    else if (m == 2 && k == -1 && n == -1) {
        return 0;
    }
    else if (m == 2 && k == 0 && n == -2) {
        return 0;
    }
    else {
        return 1;
    }

}
CUDA_CALLABLE_MEMBER
inline void Binc(const int k, const int n, const double kappa, const double w, cmplx* Binc_phase) {

    double phase, ini_phase, exp_phase;

    // NULL check
    if (Binc_phase == NULL) {

        ////perror("Point errors: Binc in `Zlmkn8_5PNe10.c`");
        ////exit(1);

    }

    //:::::::::::::::::::::::::::::::::::: BEGIN WARNING !! :::::::::::::::::::::::::::::::::::::::::::::://
    /* Compensate the initial-phase difference between NUM and PN */
    /* One CAN SET ini_phase = 0.0 if NUM/PN compairons is not needed. */
    
    ini_phase = M_PI * (double)( - k * 0.5 );      // Matches Maarten's initial orbital data  
    //ini_phase = M_PI * (double)( n - k * 0.5 );  // Matches Ryuichi's initial orbital data  

    //:::::::::::::::::::::::::::::::::::::: END WARNING !! :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::://


    if (w > 0) { // cos(w*(4*ln(2) + 2*ln(w) - 1 + k) - ini) + sin(w*(4*ln(2) + 2*ln(w) - 1 + k) - ini) * I

        phase = ( -w ) * (0.4e1 * log(0.2e1) + 0.2e1 * log(w) - 0.1e1 + kappa);
        
        //GSL_SET_REAL(Binc_phase, cos(phase - ini_phase));
        //GSL_SET_IMAG(Binc_phase, sin(phase - ini_phase));
        *Binc_phase = cmplx(cos(phase - ini_phase), sin(phase - ini_phase));

    }
    else if (w < 0) { // exp(-2*w*Pi)*cos(w*(4*ln(2) + 2*ln(-w) - 1 + k) - ini) + exp(-2*w*Pi)*sin(w*(4*ln(2) + 2*ln(-w) - 1 + k) - ini)*I 

        phase = ( -w ) * ( 0.4e1 * log(0.2e1) + 0.2e1 * log( -w ) - 0.1e1 + kappa );
        exp_phase = exp(2.0 *  ( -w ) * M_PI);
       
        //GSL_SET_REAL(Binc_phase, cos(phase - ini_phase) * exp_phase);
        //GSL_SET_IMAG(Binc_phase, sin(phase - ini_phase) * exp_phase);
        *Binc_phase = cmplx(cos(phase - ini_phase) * exp_phase, sin(phase - ini_phase) * exp_phase);

    }
    else {

        //perror("Parameters err or w is zero : Binc in `Zlmkn8_5PNe10.c`");
        ////exit(1);

    }


}


/* Select (m, k, n) modes of {hat Z}  for a given ell (2 <= ell <= 12)*/
CUDA_CALLABLE_MEMBER
cmplx hZ_2mkn(const int m, const int k, const int n, inspiral_orb_PNvar* PN_orb) {//

    cmplx hZ = { 0.0 };
   // printf("hZ_2mkn[%d, %d, %d, %d] \n", 2, m, k, n);

    /* For ell = 2, some of zero modes survive.*/
    /* Pick up these exceptional zero modes from `zero modes`*/
   
    if ((m + k + n) == 0 && (zero_modes(m, k, n) == 1))
    {
        //printf("zero mkn[%d, %d, %d] \n", m, k, n);
        hZ = cmplx(0.0, 0.0);

    } else {
        switch (n) {
        case 0:
            hZ = hZ_2mkP0(m, k, PN_orb);
            break;
        case 1:
            hZ = hZ_2mkP1(m, k, PN_orb);
            break;
        case 2:
            hZ = hZ_2mkP2(m, k, PN_orb);
            break;
        case 3:
            hZ = hZ_2mkP3(m, k, PN_orb);
            break;
        case 4:
            hZ = hZ_2mkP4(m, k, PN_orb);
            break;
        case 5:
            hZ = hZ_2mkP5(m, k, PN_orb);
            break;
        case 6:
            hZ = hZ_2mkP6(m, k, PN_orb);
            break;
        case 7:
            hZ = hZ_2mkP7(m, k, PN_orb);
            break;
        case 8:
            hZ = hZ_2mkP8(m, k, PN_orb);
            break;
        case 9:
            hZ = hZ_2mkP9(m, k, PN_orb);
            break;
        case 10:
            hZ = hZ_2mkP10(m, k, PN_orb);
            break;
            /// <summary>
            /// 
            /// </summary>
            /// <param name="m"></param>
            /// <param name="k"></param>
            /// <param name="n"></param>
            /// <param name="PN_orb"></param>
            /// <returns></returns>
        case -1:
            hZ = hZ_2mkM1(m, k, PN_orb);
            break;
        case -2:
            hZ = hZ_2mkM2(m, k, PN_orb);
            break;
        case -3:
            hZ = hZ_2mkM3(m, k, PN_orb);
            break;
        case -4:
            hZ = hZ_2mkM4(m, k, PN_orb);
            break;
        case -5:
            hZ = hZ_2mkM5(m, k, PN_orb);
            break;
        default:
            ////perror("Parameter errors: hZ_2mkn");
            ////exit(1);
            break;
                
        }
    }


    return hZ;

}


CUDA_CALLABLE_MEMBER
cmplx hZ_3mkn(const int m, const int k, const int n, inspiral_orb_PNvar* PN_orb) {//

    cmplx hZ = { 0.0 };
    // hZ = cmplx(0.0, 0.0);
    // printf("hZ_2mkn[%d, %d, %d, %d] \n", 2, m, k, n);

     /* For ell = 3, all the zero modes are irrelevant within 5PNe10.*/
    if ((m + k + n) == 0 )
    {
        
        hZ = cmplx(0.0, 0.0);
        //printf("zero mkn[%d, %d, %d] \n", m, k, n);

    }
    else {
        switch (n) {
        case 0:
            hZ = hZ_3mkP0(m, k, PN_orb);
            break;
        case 1:
            hZ = hZ_3mkP1(m, k, PN_orb);
            break;
        case 2:
            hZ = hZ_3mkP2(m, k, PN_orb);
            break;
        case 3:
            hZ = hZ_3mkP3(m, k, PN_orb);
            break;
        case 4:
            hZ = hZ_3mkP4(m, k, PN_orb);
            break;
        case 5:
            hZ = hZ_3mkP5(m, k, PN_orb);
            break;
        case 6:
            hZ = hZ_3mkP6(m, k, PN_orb);
            break;
        case 7:
            hZ = hZ_3mkP7(m, k, PN_orb);
            break;
        case 8:
            hZ = hZ_3mkP8(m, k, PN_orb);
            break;
        case 9:
            hZ = hZ_3mkP9(m, k, PN_orb);
            break;
        case 10:
            hZ = hZ_3mkP10(m, k, PN_orb);
            break;
        /// <summary>
        /// ////
        /// </summary>
        /// <param name="m"></param>
        /// <param name="k"></param>
        /// <param name="n"></param>
        /// <param name="PN_orb"></param>
        /// <returns></returns>
        case -1:
            hZ = hZ_3mkM1(m, k, PN_orb);
            break;
        case -2:
            hZ = hZ_3mkM2(m, k, PN_orb);
            break;
        case -3:
            hZ = hZ_3mkM3(m, k, PN_orb);
            break;
        case -4:
            hZ = hZ_3mkM4(m, k, PN_orb);
            break;
        case -5:
            hZ = hZ_3mkM5(m, k, PN_orb);
            break;
        case -6:
            hZ = hZ_3mkM6(m, k, PN_orb);
            break;
        default:
            ////perror("Parameter errors: hZ_3mkn");
            ////exit(1);
            break;

        }


    }

    return hZ;

}


CUDA_CALLABLE_MEMBER
cmplx hZ_4mkn(const int m, const int k, const int n, inspiral_orb_PNvar* PN_orb) {//

    cmplx hZ = { 0.0 };
    // printf("hZ_2mkn[%d, %d, %d, %d] \n", 2, m, k, n);

     /* For ell = 4, all the zero modes are irrelevant within  5PNe10*/
    if ((m + k + n) == 0)
    {

        hZ = cmplx(0.0, 0.0);
        //printf("zero mkn[%d, %d, %d] \n", m, k, n);

    }
    else {
        switch (n) {
        case 0:
            hZ = hZ_4mkP0(m, k, PN_orb);
            break;
        case 1:
            hZ = hZ_4mkP1(m, k, PN_orb);
            break;
        case 2:
            hZ = hZ_4mkP2(m, k, PN_orb);
            break;
        case 3:
            hZ = hZ_4mkP3(m, k, PN_orb);
            break;
        case 4:
            hZ = hZ_4mkP4(m, k, PN_orb);
            break;
        case 5:
            hZ = hZ_4mkP5(m, k, PN_orb);
            break;
        case 6:
            hZ = hZ_4mkP6(m, k, PN_orb);
            break;
        case 7:
            hZ = hZ_4mkP7(m, k, PN_orb);
            break;
        case 8:
            hZ = hZ_4mkP8(m, k, PN_orb);
            break;
        case 9:
            hZ = hZ_4mkP9(m, k, PN_orb);
            break;
        case 10:
            hZ = hZ_4mkP10(m, k, PN_orb);
            break;
            /// <summary>
            /// ////
            /// </summary>
            /// <param name="m"></param>
            /// <param name="k"></param>
            /// <param name="n"></param>
            /// <param name="PN_orb"></param>
            /// <returns></returns>
        case -1:
            hZ = hZ_4mkM1(m, k, PN_orb);
            break;
        case -2:
            hZ = hZ_4mkM2(m, k, PN_orb);
            break;
        case -3:
            hZ = hZ_4mkM3(m, k, PN_orb);
            break;
        case -4:
            hZ = hZ_4mkM4(m, k, PN_orb);
            break;
        case -5:
            hZ = hZ_4mkM5(m, k, PN_orb);
            break;
        case -6:
            hZ = hZ_4mkM6(m, k, PN_orb);
            break;
        case -7:
            hZ = hZ_4mkM7(m, k, PN_orb);
            break;
        default:
            ////perror("Parameter errors: hZ_4mkn");
            ////exit(1);
            break;

        }


    }

    return hZ;

}



/*-*-*-*-*-*-*-*-*-*-*-* External functions (can be refered by other source files) *-*-*-*-*-*-*-*-*-*-*-*/
CUDA_CALLABLE_MEMBER
void init_orb_PNvar(const double q, inspiral_orb_data* orb, inspiral_orb_PNvar* PN_orb) {

    int j;

    double tmp_p = orb->tp;
    double tmp_e = orb->te;
    double tmp_Y = orb->tY;

    double tmp_v = sqrt(1.0 / tmp_p);

    /* Precompute PNK and PNq[] OUTSIDE the for loop of the time evolution */
   /* these variables stay CONSTANTS along the evolutions*/
    PN_orb->PNK = sqrt(1.0 - q * q);

    /* PNq[n]... = 1, q, q ^2, ..., q ^ 9, q ^ 10 */
    PN_orb->PNq[0] = 1.0;
    for (j = 1; j < PNq_max; j++) {

        PN_orb->PNq[j] = q * PN_orb->PNq[j - 1];

    }


    /* Pre-compute repeatedly used variables at t = ti for PN amplitudes `hZ_lmkn8_5PNe10` */
   /* Ym = Y - 1. y = sqrt(1. - Y ^ 2);  */
    PN_orb->PNlnv = log(1.0 / sqrt(tmp_p));
    PN_orb->PNYm = tmp_Y - 1.0;

    /* PNe[10] = 1, e, e ^ 2, ..., e ^ 9, e ^ 10 */
    PN_orb->PNe[0] = 1.0;
    for (j = 1; j < PNe_max; j++) {

        PN_orb->PNe[j] = tmp_e * PN_orb->PNe[j - 1];

    }

    /* PNv[11] = v ^ 8, v ^ 9, ..., v ^ 17, v ^ 18 */
    /* Warning! Starts at PNv[0] = v^8 */

    PN_orb->PNv[0] = (tmp_v * tmp_v) * (tmp_v * tmp_v) * (tmp_v * tmp_v) * (tmp_v * tmp_v);
    for (j = 1; j < PNv_max; j++) {

        PN_orb->PNv[j] = tmp_v * PN_orb->PNv[j - 1];

    }

    /* PNY[13] = 1, Y, Y ^ 2, ..., Y ^ 11, Y ^ 12 */
    PN_orb->PNY[0] = 1.0;
    for (j = 1; j < PNY_max; j++) {

        PN_orb->PNY[j] = tmp_Y * PN_orb->PNY[j - 1];

    }

    /* PNYp[13]... = 1, Yp, Yp^2, ...,  Yp^12 where Yp = Y + 1. */
    PN_orb->PNYp[0] = 1.0;
    for (j = 1; j < PNYp_max; j++) {

        PN_orb->PNYp[j] = (1.0 + tmp_Y) * PN_orb->PNYp[j - 1];

    }

    /* PNy[25] = 1, y, y ^ 2, ..., y ^ 23, y ^ 24 where y = sqrt(1 - Y^2) */
    PN_orb->PNy[0] = 1.0;
    for (j = 1; j < PNy_max; j++) {

        PN_orb->PNy[j] = sqrt(1.0 - tmp_Y * tmp_Y) * PN_orb->PNy[j - 1];

    }


}


/* Obtain the full (l, m, k, n) modes of {hat Z} */
CUDA_CALLABLE_MEMBER
cmplx hZ_lmkn(const int l, const int m, const int k, const int n, inspiral_orb_PNvar* PN_orb){ //


   // cmplx test;
  // SET_COMPLEX(&test, 11.0, 3.4);
    switch (l) {
    case 2:
        return hZ_2mkn(m, k, n, PN_orb);
        break;
    case 3:
        return hZ_3mkn(m, k, n, PN_orb);
        break;
    case 4:
        return hZ_4mkn(m, k, n, PN_orb);
        break;
    /*case 5:
        return hZ_5mkn(m, k, n, PN_orb);
        break;
    case 6:
        return hZ_6mkn(m, k, n, PN_orb);
        break;
    case 7:
        return hZ_7mkn(m, k, n, PN_orb);
        break;
    case 8:
        return hZ_8mkn(m, k, n, PN_orb);
        break;
    case 9:
        return hZ_9mkn(m, k, n, PN_orb);
        break;
    case 10:
        return hZ_10mkn(m, k, n, PN_orb);
        break;
    case 11:
        return hZ_11mkn(m, k, n, PN_orb);
        break;
    case 12:
        return hZ_12mkn(m, k, n, PN_orb);
        break;*/
    default:
        ////perror("Parameter errors: hZ_lmkn");
        ////exit(1);
        break;
    }

}

CUDA_CALLABLE_MEMBER
cmplx Zlmkn8_5PNe10(const int l, const int m, const int k, const int n, inspiral_orb_data* orb, inspiral_orb_PNvar* PN_orb) { //

    int Zm, Zk, Zn;

    double W_Zmkn;
    double ReZ, ImZ, Re_hZ, Im_hZ;
    double cos_Binc, sin_Binc;

    cmplx hatZ, Zlmkn, Binc_phase;


    // NULL check
    if (orb == NULL || PN_orb == NULL) {

        ////perror("Point errors: Zlmkn8_5PNe10");
        ////exit(1);

    }


    /* Read off the inspiral data from `inspiral_orb_PNvar`*/
    double q = PN_orb->PNq[1];
    double kappa = PN_orb->PNK;

    double Wr = orb->tWr;
    double Wth = orb->tWth;
    double Wph = orb->tWph;

    /* Make use of the symmetry: Z8[l, -m, -k, -n] = (-1)^(l + k) * conj(Z8_[l, m, k, n])*/
    if ((m + k + n == 0) && (n == 0)) { // These amplitudes are zero within 5PNe10.

        Zlmkn = cmplx(0.0, 0.0);

    }
    else if ((m + k + n < 0) || (m + k + n == 0) && (n > 0)) {

        Zm = (-m);
        Zk = (-k);
        Zn = (-n);

        /* Get PN amplitudes: `hatZ`*/
        hatZ = hZ_lmkn(l, Zm, Zk, Zn, PN_orb);
        Re_hZ = gcmplx::real(hatZ);
        Im_hZ = gcmplx::imag(hatZ);

        /* Phase factoes from `Binc`*/
        W_Zmkn = (double)(Zm * Wph + Zk * Wth + Zn * Wr);
        //printf("elif W_Z[%d %d %d] %.7e \n", Zm, Zk, Zn, W_Zmkn);
        Binc(Zk, Zn, kappa, W_Zmkn, &Binc_phase);
        cos_Binc = gcmplx::real(Binc_phase);
        sin_Binc = gcmplx::imag(Binc_phase);

        /*Restore the full Teukolsky amplitude*/
        /* WARNING! Avoid cmplx functions for efficiency*/
         /* (a + b*I) * exp(-I*(Bin - ini)) */
        /*Re: a*cos(Bi - ini) + b*sin(Bi - ini) */
        /*im: b*cos(Bi - ini) - a*sin(Bi - ini) */

        ///////////////////////////////////////////////////////////
        //:::::::::: WARNING ::::::::::::::::::::::::://
        double sgn = pow(-0.1e1, (double)(l) + Zk);
        //////////////////////////////////////////////////////////////

        /* c.c. of the original Zlmkn: ie,  ReZ + (-1.0) * ImZ */
        ReZ = (Re_hZ * cos_Binc + Im_hZ * sin_Binc) * sgn;
        ImZ = (Im_hZ * cos_Binc - Re_hZ * sin_Binc) * sgn * (-1.0);
        Zlmkn = cmplx(ReZ, ImZ);
        
        /*
        if (Zn == 5 || Zn == -2) {
           printf("Zlmkn[%d, %d, %d, %d] = %.7e + i %.7e, cos_Binc = %.7e \n", l, Zm, Zk, Zn, ReZ, ImZ, cos_Binc);
        }
        */


    }
    else {

        Zm = (m);
        Zk = (k);
        Zn = (n);

        /* Get PN amplitudes: `hatZ`*/
        hatZ = hZ_lmkn(l, Zm, Zk, Zn, PN_orb);
        Re_hZ = gcmplx::real(hatZ);
        Im_hZ = gcmplx::imag(hatZ);

        /* Phase factoes from `Binc`*/
        W_Zmkn = (double)(Zm * Wph + Zk * Wth + Zn * Wr);
        Binc(Zk, Zn, kappa, W_Zmkn, &Binc_phase);
        cos_Binc = gcmplx::real(Binc_phase);
        sin_Binc = gcmplx::imag(Binc_phase);

        //Binc = -W_Zmkn * (0.4e1 * log(0.2e1) + 0.2e1 * log(W_Zmkn) - 0.1e1 + kappa);

      // if (Zn == 0 || Zn == -1) {
      //      printf("hat_Zlmkn[%d, %d, %d, %d] = %.7e + i %.7e, W_Zmkn = %.7e, cos_Binc = %.7e \n", l, Zm, Zk, Zn, Re_hZ, Im_hZ, W_Zmkn, cos_Binc);
      //  }


        /*Restore the full Teukolsky amplitude*/
        /* WARNING! Avoid cmplx functions for efficiency*/
        /* (a + b*I) * exp(-I*(Bin - ini)) */
        /*Re: a*cos(Bi - ini) + b*sin(Bi - ini) */
        /*im: b*cos(Bi - ini) - a*sin(Bi - ini) */
        ReZ = Re_hZ * cos_Binc + Im_hZ * sin_Binc;
        ImZ = Im_hZ * cos_Binc - Re_hZ * sin_Binc;
        Zlmkn = cmplx(ReZ, ImZ);

        /* DEBUG POINT */
      /*
        if ( Zn == 0 || Zn == 3 ) {

        // printf("Zlmkn[%d, %d, %d, %d] = %.7e + i %.7e, cos_Binc = %.7e, sin_Binc = %.7e \n", l, Zm, Zk, Zn, Re_hZ, Im_hZ, cos_Binc, sin_Binc);
         printf("Zlmkn[%d, %d, %d, %d] = %.7e + i %.7e \n", l, Zm, Zk, Zn, ReZ, ImZ);

        }
      */

    }


    //printf("Binc = %.7e, W_Zmkn = %.7e \n", Binc, W_Zmkn);
    //printf("hat_Zlmkn[%d, %d, %d, %d] = %.7e + i %.7e \n", l, Zm, Zk, Zn, Re_hZ, Im_hZ);
    //printf("Zlmkn[%d, %d, %d, %d] = %.7e + i %.7e \n", l, m, k, n, ReZ, ImZ);
    //puts("\n");

    return Zlmkn;

}

/* low-freq. cut */
/* MUST BE larger than the mass_ratio*/
CUDA_CALLABLE_MEMBER static double W_static = 5.0e-3; 

/* high-freq. cut */
/* TEST; NEED EXPERIMENTS (2021/02/09) */
// at least it should be < ~ 0.21 - 0.22 (for e=0.3, p=10; q=0.95, e=0.3)
// at least it should be < ~ 0.17 (for e=0.3, p=15; q = 0.95, e=0.3) [??]
// = 0.225 for {e0, p0, i0} = {0.26, 10, 80deg}
// = 0.205 for {e0, p0, i0} = {0.21, 9.6, 80deg} (hx: 2:3 resonance for the paper)
CUDA_CALLABLE_MEMBER static double W_high = 0.205;

CUDA_CALLABLE_MEMBER static double Slm_Pi = 0.3989422804014326779399461; /*Overall of Spheroidal harmonics Slm_aw: sqrt(2. * Pi)^(-1) in the BHPC convention*/


CUDA_CALLABLE_MEMBER
void get_Slm_vals(double *Slm_out, double *anti_Slm_out, const int l, const int m, const int k, const int n, inspiral_orb_data* orb, inspiral_orb_PNvar* PN_orb, Slm_aw_PNvar* PN_Slm, Slm_aw_PNvar* anti_PN_Slm) {

    // NULL check
    if (orb == NULL || PN_orb == NULL || PN_Slm == NULL || anti_PN_Slm == NULL) {

        //perror("Pointer errors: get_Slm_vals ");
        //exit(1);

    }


    /* Set Loop variables and cut off; j = m + k*/
    //int mi, ki, ni;
    //int m_max = select_m_max(l);
    //int j_max = select_j_max(l);

    /* Tempral variables at a given fixed (l, m, k, n) modes*/
    double Wr, Wth, Wph; 

    /* Complex amplitude of Zlmkn8*/
    cmplx tmp_Z = { 0.0 };

    /* Read out the orbital freq. and phase OUTSIEDE the loop */
    Wr = orb->tWr;
    Wth = orb->tWth;
    Wph = orb->tWph;

    /* Store the data via the Mode sum RIGHT (n >=0): */

    /*
    if (mi == -j_max) {

        //printf("amp_save: now [m, k, n] = [%.d, %.d, %.d] \n", mi, ki, ni);
        //puts("\n");
    }
    */

    /* Set  the voice sets of freq. */
    /* WARNING! immediately skip the loop if Wmkn is nearly static modes */
    ///////////////////////////////////////////////////////////////////////////
    double Wmkn = (double)(m * Wph + k * Wth + n * Wr);
    double abs_Wmkn = fabs(Wmkn);

    if (abs_Wmkn < W_static || abs_Wmkn > W_high ) {
        //printf("Static! tt = %.5e, Wmkn[%d, %d, %d]  = %.7e \n", orb->tt, mi, k0, ni, Wmkn);
        return;
    }
    ///////////////////////////////////////////////////////////////////////////
    double Wmkn2 = Wmkn * Wmkn;
    double Wmkn3 = Wmkn2 * Wmkn;
    double Wmkn4 = Wmkn2 * Wmkn2;

    /* Get the Spheroidal harmonics Slm_aw(theta) and Slm_aw(pi - theta) */
    /* Set the freq.data required for PN Spheroidal harmonics Sln_aw: `Spheroidal.c`  */
    PN_Slm->Sw[1] = Wmkn;
    PN_Slm->Sw[2] = Wmkn2;
    PN_Slm->Sw[3] = Wmkn3;
    PN_Slm->Sw[4] = Wmkn4;

    anti_PN_Slm->Sw[1] = Wmkn;
    anti_PN_Slm->Sw[2] = Wmkn2;
    anti_PN_Slm->Sw[3] = Wmkn3;
    anti_PN_Slm->Sw[4] = Wmkn4;

    // for the Right-mode sum (n => 0)
    *Slm_out = (Slm_Pi / Wmkn2) * Slm_aw(l, m, PN_Slm);
    
    // for the Left-mode sum (n < 0)
    *anti_Slm_out = (Slm_Pi / Wmkn2) * Slm_aw(l, m, anti_PN_Slm) * pow(-1.0, (double)(l));

    //  if (mi == -1) {

//        printf("Slm_aw[%d, %d; %d, %d] = %.7e with Wmkn = %.7e \n", l, mi, ki, ni, Slm_aw(l, mi, PN_Slm), Wmkn);
        //puts("\n");

    //   }

    

    /* Get the complex Teukolsky amplitude Zlmkn8[l, m, k, n]: `Zlmkn8_5PNe10.c` */

}

#define NUM_THREADS_PN 32
CUDA_KERNEL
void Zlmkn8_5PNe10_kernel(cmplx *Almkn_out, int *l_all, int *m_all, int *k_all, int *n_all, double *q_all, double *Theta_all, double *tp_all, double *te_all, double *tY_all, double *tWr_all, double *tWth_all, double *tWph_all, int num_modes, int num_points)
{

    int start, increment;

    #ifdef __CUDACC__
    start = threadIdx.x + blockIdx.x * blockDim.x;
    increment = gridDim.x * blockDim.x;
    #else
    start = 0;
    increment = 1;
    //#pragma omp parallel for
    #endif 

    for (int i = start; i < num_points; i += increment)
    {
        inspiral_orb_data orb;
        inspiral_orb_PNvar PN_orb;
        //orb->tt = tt_all[i]; /* Slow time tilde t */

        orb.tp = tp_all[i];
        orb.te = te_all[i]; 
        orb.tY = tY_all[i]; /* orbital parameters [tilde p(tt), tilde e(tt), tilde Y(tt) ] */

        orb.tWr = tWr_all[i];
        orb.tWth = tWth_all[i]; 
        orb.tWph = tWph_all[i]; /* orbital frequencies tilde W(tt) */

       //orb->Pr = Pr_all[i]; 
        //orb->Pth = Pth_all[i]; 
        //orb->Pph = Pph_all[i]; /* orbital phase Phi */
        double q = q_all[i];
        double Theta = Theta_all[i];
        init_orb_PNvar(q, &orb, &PN_orb);

        Slm_aw_PNvar PN_Slm = { 0.0 };
        Slm_aw_PNvar anti_PN_Slm = { 0.0 };
        
        init_PNSlm(q, Theta, &PN_Slm, 1); // flag = 1    
        init_PNSlm(q, Theta, &anti_PN_Slm, 0); // flag = 0

        int start2, increment2;
        #ifdef __CUDACC__
        start2 = blockIdx.y;
        increment2 = gridDim.y;
        #else
        start2 = 0;
        increment2 = 1;
        //#pragma omp parallel for
        #endif 

        for (int mode_i = start2; mode_i < num_modes; mode_i += increment2 )
        {
            int l_here = l_all[mode_i];
            int m_here = m_all[mode_i];
            int k_here = k_all[mode_i];
            int n_here = n_all[mode_i];

            cmplx Slm(0.0, 0.0);
            cmplx anti_Slm(0.0, 0.0);

            double Slm_out = 0.0;
            double anti_Slm_out = 0.0;

            get_Slm_vals(&Slm_out, &anti_Slm_out, l_here, m_here, k_here, n_here, &orb, &PN_orb, &PN_Slm, &anti_PN_Slm);

            if ((Slm_out == 0.0) && (anti_Slm_out == 0.0))
            {
                continue;
            }

            cmplx Zlmkn = Zlmkn8_5PNe10(l_here, m_here, k_here, n_here, &orb, &PN_orb);
            double R_ReZ = Zlmkn.real();
            double R_ImZ = Zlmkn.imag();
            double L_ReZ = R_ReZ * pow(-1.0, (double)(l_here) + (double)(k_here));
            double L_ImZ = R_ImZ * pow(-1.0, (double)(l_here) + (double)(k_here) + 1.0);

            cmplx right(Slm_out * R_ReZ, Slm_out * R_ImZ);
            cmplx left(anti_Slm_out * R_ReZ, anti_Slm_out * R_ImZ);

            Almkn_out[mode_i * num_points + i] = right;
            // left is recorded in the second half of the array
            Almkn_out[num_modes * num_points + mode_i * num_points + i] = left;

        }
        // TODO: do we need this?
        CUDA_SYNC_THREADS;
    }
}



void Zlmkn8_5PNe10_wrap(cmplx *Almkn_out, int *l_all, int *m_all, int *k_all, int *n_all, double *q_all, double *Theta_all, double *tp_all, double *te_all, double *tY_all, double *tWr_all, double *tWth_all, double *tWph_all, int num_modes, int num_points)
{
    #ifdef __CUDACC__
    int num_blocks = std::ceil((num_points + NUM_THREADS_PN -1)/NUM_THREADS_PN);
    dim3 grid(num_blocks, num_modes);
    Zlmkn8_5PNe10_kernel<<<grid, NUM_THREADS_PN>>>(Almkn_out, l_all, m_all, k_all, n_all, q_all, Theta_all, tp_all, te_all, tY_all, tWr_all, tWth_all, tWph_all, num_modes, num_points);
    cudaDeviceSynchronize();
    gpuErrchk(cudaGetLastError());
    #else
    Zlmkn8_5PNe10_kernel(Almkn_out, l_all, m_all, k_all, n_all, q_all, Theta_all, tp_all, te_all, tY_all, tWr_all, tWth_all, tWph_all, num_modes, num_points);
    #endif
}