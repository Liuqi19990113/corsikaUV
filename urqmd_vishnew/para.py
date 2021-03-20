import os
import shutil
import sys
import numpy as np
import random
from exec_path import *
  

def write_urqmd_para(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,urqmd_seed):
  print(" run.py : urqmd seed {}".format(urqmd_seed))
  output=open(urqmd_para_1,'w')
  A=2
  R_pro=0
  #it is nucleus
  if(nucleus_judge==1):
    output.write("pro {} {}\n".format(pro_para_1,pro_para_2))
    R_pro=A*(pro_para_1+tar_para_1)**(1./3)
  else:
    output.write("PRO {} {}\n".format(pro_para_1,pro_para_2))
    R_pro=A*(1+tar_para_1)**(1./3)
  output.write("tar {} {}\n".format(tar_para_1,tar_para_2))

  R_tar=A*(tar_para_1**(1./3))
  R=R_pro+R_tar
  output.write("IMP 0. {}\n".format(R))
  output.write("rsd {}\n".format(urqmd_seed))
  output.write("ene {}\n".format(ene))
  output.write("nev 1\n")
  output.write("tim 4 0.1\n")
  output.write("f13\nf15\nf16\nf20\n#f14\n#f19\n")
  output.write("cto 18 1\n")
  output.write("xxx")

  output.close()

  output=open(urqmd_para_2,'w')
  #it is nucleus
  if(nucleus_judge==1):
    output.write("pro {} {}\n".format(pro_para_1,pro_para_2))
  else:
    output.write("PRO {} {}\n".format(pro_para_1,pro_para_2))
  output.write("tar {} {}\n".format(tar_para_1,tar_para_2))

  output.write("IMP 0. {}\n".format(R))
  output.write("rsd {}\n".format(urqmd_seed))
  output.write("ene {}\n".format(ene))
  output.write("nev 1\n")
  output.write("tim 8000 8000\n")
  output.write("f13\nf15\nf16\nf20\nf14\n#f19\n")
  output.write("xxx")

  output.close()