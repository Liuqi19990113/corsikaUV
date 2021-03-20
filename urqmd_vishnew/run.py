import os
import shutil
import sys
import numpy as np
import random
from para import *


def run_urqmd_initial(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh):
  write_urqmd_para(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh)
  if(os.path.exists(transform_input)):
    os.remove(transform_input)
  if(os.path.exists(urqmd_QGP)):
    os.remove(urqmd_QGP)
  if(os.path.exists(urqmd_spec)):
    os.remove(urqmd_spec)
  os.chdir(urqmd_path)
  os.popen(urqmd_initial_exec).read()
  QGP_judge=int(os.popen(QGP_judge_exec).read())
  if(QGP_judge==-1):
    return run_urqmd_initial(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh+1)
  elif(QGP_judge==1):
    shutil.move(urqmd_initial_result14,transform_input)
  return QGP_judge



def run_transform():
  os.chdir(transform_path)
  if(not os.path.exists(transform_result_dir)):
    os.mkdir(transform_result_dir)
  os.popen(transform_exec+' '+transform_para).read()
  if(os.path.exists(vishnew_input_dir)):
    shutil.rmtree(vishnew_input_dir)
  shutil.move(transform_result_dir,vishnew_input_dir)

def run_vishnew():
  os.chdir(vishnew_path)
  if(not os.path.exists(vishnew_result_dir)):
    os.mkdir(vishnew_result_dir)
  os.popen(vishnew_exec).read()
  if(os.path.exists(iss_input_dir)):
    shutil.rmtree(iss_input_dir)
  shutil.move(vishnew_result_dir,iss_input_dir)

def run_iSS():
  os.chdir(iss_path)
  os.popen(iss_exec).read()
  if(os.path.exists(osc2u_input)):
    os.remove(osc2u_input)
  shutil.move(iss_result,osc2u_input)


def run_osc2u():
  os.chdir(osc2u_path)
  os.popen(osc2u_exec+"<"+osc2u_input).read()
  os.rename(osc2u_result,osc2u_result_move)
  if(os.path.exists(urqmd_frez_input)):
    os.remove(urqmd_frez_input)
  shutil.move(osc2u_result_move,urqmd_frez_input)

def run_urqmd_frez():
  os.chdir(urqmd_path)
  os.popen(urqmd_frez_exec).read()



# main process

#get parameter
ene=float(sys.argv[1])
nucleus_judge=int(sys.argv[2])
pro_para_1=int(sys.argv[3])
pro_para_2=int(sys.argv[4])
tar_para_1=int(sys.argv[5])
tar_para_2=int(sys.argv[6])
seedh=int(sys.argv[7])
random.seed(seedh)
print("HydroRun : python run.py {} {} {} {} {} {} {}".format(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh))

QGP_judge=run_urqmd_initial(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh)
if(QGP_judge==1):
  run_transform()
  run_vishnew()
  run_iSS()
  # shutil.move(iss_result,urqmd_QGP)
  run_osc2u()
  run_urqmd_frez()
# if(QGP_judge==0):
#   os.rename(urqmd_QGP,urqmd_spec)
  # os.rename(urqmd_initial_result19,urqmd_spec)