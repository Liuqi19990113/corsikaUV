import os
import shutil
import sys
import numpy as np

root_path=sys.path[0]
# urqmd initial variable
urqmd_path=root_path+"/urqmd"
urqmd_initial_exec=urqmd_path+"/urqmd_initial.sh"
urqmd_initial_result=urqmd_path+"/urqmd_result14"
initial_path=root_path+"/Initial"
urqmd_para=urqmd_path+"/input_initial"
# transform variable
transform_path=root_path+"/transform"
transform_exec=transform_path+"/transform"
transform_para=transform_path+"/Transform_para.txt"
transform_input=transform_path+"/urqmd_result14"
transform_result_dir=transform_path+"/Initial"
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
#osc2u variable
osc2u_path=root_path+"/osc2u"
osc2u_exec=osc2u_path+"/osc2u"
osc2u_input=osc2u_path+"/OSCAR.DAT"
osc2u_result=osc2u_path+"/fort.14"
osc2u_result_move=osc2u_path+"/frez_start"
#urqmd frezout
urqmd_frez_input=urqmd_path+"/frez_start"
urqmd_frez_exec=urqmd_path+"/urqmd_frez.sh"
urqmd_frez_result=urqmd_path+"/frez_result"
# result dir
result_path=root_path+"/result"
result_file=result_path+"/event"
  

def write_urqmd_para(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2):
  output=open(urqmd_para,'w')
  #it is nucleus
  if(nucleus_judge==1):
    output.write("pro {} {}\n".format(pro_para_1,pro_para_2))
  else:
    output.write("PRO {} {}\n".format(pro_para_1,pro_para_2))
  output.write("tar {} {}\n".format(tar_para_1,tar_para_2))


  if(tar_para_1==40):
    output.write("IMP 0. 6.85\n")
  elif(tar_para_1==16):
    output.write("IMP 0. 5.73\n")
  elif(tar_para_1==14):
    output.write("IMP 0. 6.5.59\n")
  else:
    output.write("IMP 0. {}\n".format(3.2*float(tar_para_1)**(1/3)))
  
  output.write("ene {}\n".format(ene))
  output.write("nev 1\n")
  output.write("time 4 0.1\n")
  output.write("f13\nf15\nf16\nf20\n")
  output.write("cto 18 1")


def run_urqmd_initial():
  os.chdir(urqmd_path)
  os.popen(urqmd_initial_exec)
  if(os.path.exists(transform_input)):
    os.remove(transform_input)
  shutil.move(urqmd_initial_result,transform_input)


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
write_urqmd_para(ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2)