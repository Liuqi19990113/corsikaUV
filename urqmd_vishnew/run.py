import os
import shutil
import sys
import random
from math import sqrt

root_path=sys.path[0]
# urqmd initial variable
urqmd_path=root_path+"/urqmd"
urqmd_initial_exec=urqmd_path+"/urqmd_initial.sh"
urqmd_initial_result14=urqmd_path+"/urqmd_initial_14.txt"
urqmd_initial_result19=urqmd_path+"/urqmd_initial_19.txt"
initial_path=root_path+"/Initial"
urqmd_para_1=urqmd_path+"/input_initial_4"
urqmd_para_2=urqmd_path+"/input_initial_8000"
QGP_judge_exec=urqmd_path+"/QGP_judge"
# transform variable
transform_path=root_path+"/transform"
transform_exec=transform_path+"/transform"
transform_para=transform_path+"/Transform_para.txt"
transform_input=transform_path+"/urqmd_initial_14.txt"
transform_result_dir=transform_path+"/Initial"
transform_para=transform_path+"/Transform_para.txt"
transform_cut=transform_result_dir+"/QGP_cut19.txt"
# VISHNew variable
vishnew_path=root_path+"/VISHNew"
vishnew_exec=vishnew_path+"/VISHNew"
vishnew_input_dir=vishnew_path+"/Initial"
vishnew_result_dir=vishnew_path+"/results"
#iSS variable
iss_path=root_path+"/iSS"
iss_exec=iss_path+"/iSS"
iss_input_dir=iss_path+"/results"
iss_result=iss_path+"/OSCAR.DAT"
iss_cut_exec=iss_path+"/iSS_cut"
iss_cut_result=iss_path+"/iSS_cut19.txt"
#osc2u variable
osc2u_path=root_path+"/osc2u"
osc2u_exec=osc2u_path+"/osc2u"
osc2u_QGP=osc2u_path+"/OSCAR.DAT"
osc2u_cut=osc2u_path+"/QGP_cut19.txt"
osc2u_result=osc2u_path+"/fort.14"
osc2u_QGP_move=osc2u_path+"/QGP_start"
osc2u_cut_move=osc2u_path+"/cut_start"
#urqmd frezout
urqmd_QGP=urqmd_path+"/urqmd_QGP_19.txt"
urqmd_spec=urqmd_path+"/urqmd_spec_19.txt"
urqmd_frez_QGP=urqmd_path+"/QGP_start"
urqmd_frez_cut=urqmd_path+"/cut_start"
urqmd_frez_exec=urqmd_path+"/urqmd_frez.sh"
urqmd_frez_result=urqmd_path+"/frez_result"
# result dir
result_path=root_path+"/result"
result_file=result_path+"/event"

def write_urqmd_para(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,urqmd_seed):
  # print(" run.py : urqmd seed {}".format(urqmd_seed))
  output=open(urqmd_para_1,'w')
  A=1.6
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

def write_transform_para(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2):
  output=open(transform_para,'w')
  # tau=sqrt(((2*ene*0.937)**2-4*0.937**2)/(40000-4*0.937**2))
  # tau=sqrt(100./ene*0.937)
  tau=0.4
  output.write("tau {} //tau_0\n".format(tau))
  output.write('''Rver 1. //R_ver or sigma_r
Reta 1.  //R_eta or sigma_eta
t 0 4 20 // t_range: t_down t_up t_bin ,with bin is (2*val)+1
x -13 13 65 // x_range: x_down x_up x_bin ,with bin is (2*val)+1
y -13 13 65 // y_range: y_down y_up y_bin ,with bin is (2*val)+1
eta -8 8 40 // eta_range: eta_down eta_up eta_bin ,with bin is (2*val)+1
QGP_search_mode 2 // 0: calculate eta_cut from Edec, 1: use input eta_cut 2: use fireball volume on eta=0
QGP_volume 0.001 //minimum volume for QGP generated
eta_cut -0 0 // for eta_cut_mode=1,output particle over eta_cut to QGP_cut19.txt and QGP_cut14.txt
Edec 2 // decoupling energy density GeV/fm^3, for eta_cut_mode=0
range 3 //range of particle impact
input urqmd_initial_14.txt //input file name
output Initial //output file dir
K 1 // normalization factor of EPTensor
VISHNEW 1 // output vishnew Initial: ed.txt u1.txt u2.txt,ed in GeV/fm^3
MUSIC 0 // output MUSIC Initial:haven't been finished
DEBUG 0 // if 1, output some information for debug, else clean''')
  output.close()

def run_transform(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2):
  os.chdir(transform_path)
  #write_transform_para(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2)
  if(not os.path.exists(transform_result_dir)):
    os.mkdir(transform_result_dir)
  [volume,E_core,p_core]=list(map(float,os.popen(transform_exec+' '+transform_para).read().split(' ')))
  if(E_core>0):
    if(os.path.exists(vishnew_input_dir)):
      shutil.rmtree(vishnew_input_dir)
    shutil.move(transform_cut,osc2u_cut)
    shutil.move(transform_result_dir,vishnew_input_dir)
  return [volume,E_core,p_core]


def run_urqmd_initial(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh):
  write_urqmd_para(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh)
  if(os.path.exists(transform_input)):
    os.remove(transform_input)
  if(os.path.exists(urqmd_QGP)):
    os.remove(urqmd_QGP)
  if(os.path.exists(urqmd_spec)):
    os.remove(urqmd_spec)
  os.chdir(urqmd_path)
  urqmd_judge0=os.popen(urqmd_initial_exec).read()
  urqmd_judge=urqmd_judge0.replace('\n', '')
  urqmd_judge=urqmd_judge.strip(" ")
  try:
    urqmd_para=list(map(int,urqmd_judge.split()))
  except ValueError:
    print("run_urqmd_initial error: ")
    print(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh)
    print(urqmd_judge0)
    return run_urqmd_initial(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh+1)
  else:
    pass
  # judge if non interact
  if(urqmd_para[0]==0):
    return run_urqmd_initial(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh+1)
  # use transform to judge if have QGP, use QGP_judge_mode 2
  shutil.move(urqmd_initial_result14,transform_input)
  [volume,E_core,p_core]=run_transform(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2)
  
  return [volume,E_core,p_core]


def run_vishnew():
  os.chdir(vishnew_path)
  if(not os.path.exists(vishnew_result_dir)):
    os.mkdir(vishnew_result_dir)
  os.popen(vishnew_exec).read()
  if(os.path.exists(iss_input_dir)):
    shutil.rmtree(iss_input_dir)
  shutil.move(vishnew_result_dir,iss_input_dir)

def run_iSS(E_core,p_core):
  os.chdir(iss_path)
  os.popen(iss_exec).read()
  cut_judge=int(os.popen(iss_cut_exec+" {E} {p}".format(E=E_core,p=p_core)).read
  ())
  if(cut_judge==0):
    run_iSS(E_core,p_core)
    return
  if(os.path.exists(osc2u_QGP)):
    os.remove(osc2u_QGP)
  shutil.move(iss_cut_result,osc2u_QGP)


def run_osc2u():
  os.chdir(osc2u_path)
  os.popen(osc2u_exec+"<"+osc2u_QGP).read()
  os.rename(osc2u_result,osc2u_QGP_move)
  if(os.path.exists(urqmd_frez_QGP)):
    os.remove(urqmd_frez_QGP)
  shutil.move(osc2u_QGP_move,urqmd_frez_QGP)

  os.popen(osc2u_exec+"<"+osc2u_cut).read()
  os.rename(osc2u_result,osc2u_cut_move)
  if(os.path.exists(urqmd_frez_cut)):
    os.remove(urqmd_frez_cut)
  shutil.move(osc2u_cut_move,urqmd_frez_cut)

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

[volume,E_core,p_core]=run_urqmd_initial(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2,seedh)
E_0=0
if(E_core>E_0):
  run_vishnew()
  run_iSS(E_core,p_core)
  # shutil.move(iss_result,urqmd_QGP)
  run_osc2u()
  run_urqmd_frez()
# if(QGP_judge==0):
#   os.rename(urqmd_QGP,urqmd_spec)
  # os.rename(urqmd_initial_result19,urqmd_spec)