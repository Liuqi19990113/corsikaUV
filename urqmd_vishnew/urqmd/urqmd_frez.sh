#!/bin/sh


export ftn09=input_frez
export ftn10=QGP_start
export ftn13=test.f13
export ftn14=test.f14
export ftn15=test.f15
export ftn16=test.f16
export ftn19=urqmd_QGP_19.txt
export ftn20=test.f20

./urqmd
rm test*

# export ftn09=input_frez
# export ftn10=cut_start
# export ftn13=test.f13
# export ftn14=test.f14
# export ftn15=test.f15
# export ftn16=test.f16
# export ftn19=urqmd_spec_19.txt
# export ftn20=test.f20

# ./urqmd
# rm test*