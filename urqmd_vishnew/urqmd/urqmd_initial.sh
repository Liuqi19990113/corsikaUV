#!/bin/sh

export ftn09=input_initial_4
export ftn13=test.f13
export ftn14=urqmd_initial_14.txt
export ftn15=test.f15
export ftn16=test.f16
export ftn19=urqmd_initial_19.txt
export ftn20=test.f20

./urqmd
rm test*

export ftn09=input_initial_8000
export ftn13=test.f13
export ftn14=test.f14
export ftn15=test.f15
export ftn16=test.f16
export ftn19=urqmd_spec_19.txt
export ftn20=test.f20

./urqmd
rm test*
