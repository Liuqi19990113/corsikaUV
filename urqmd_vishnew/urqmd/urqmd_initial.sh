#!/bin/sh

run=${1-nothing}


export ftn09=input_initial
export ftn13=test.f13
export ftn14=urqmd_initial_14.txt
export ftn15=test.f15
export ftn16=test.f16
export ftn19=urqmd_initial_19.txt
export ftn20=test.f20

./urqmd
rm test*
