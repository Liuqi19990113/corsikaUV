#include<iostream>
#include<stdlib.h>
#include<algorithm>
#include<cmath>
#include<ctime>
#include<random>
#include<fstream>
#include<sstream>
#include<string>
using namespace std;
extern "C"{
  /**run hydro from corsika*/
  void HydroRun_(int proj_id,int tar,double gamma,double mass0,double phi_x,double phi_y,double phi_z,int nptl,int nspec,int idptl[],double pptl[][5]);
  /**read particle from hydro output file*/
  void ReadHydro(double beta[4],int nptl,int nspec,int idptl[],double pptl[][5]);
  /**do Lorentz transformation from (p[0],p[1],p[2],p[3]) to (E,px,py,pz)*/
  void LorentzTransform(const double beta[4],double p[4]);
  /**use python shell to get particle information*/
  void HydroPython(double ene,int nucleus_judge,int pro_para_1,int pro_para_2,int tar_para_1,int tar_para_2);
}

void LorentzTransform(const double beta[4],double p[4]){
  double beta2=beta[1]*beta[1]+beta[2]*beta[2]+beta[3]*beta[3];
  double beta_p=beta[1]*p[1]+beta[2]*p[2]+beta[3]*p[3];
  double C=(beta[0]-1)/beta2;
  double E=p[0]*beta[0]-beta[0]*beta_p;
  double px=-beta[0]*beta[1]*p[0]+p[1]+C*beta[1]*beta_p;
  double py=-beta[0]*beta[2]*p[0]+p[2]+C*beta[2]*beta_p;
  double pz=-beta[0]*beta[3]*p[0]+p[3]+C*beta[3]*beta_p;
  p[0]=E,p[1]=px,p[2]=py,p[3]=pz;
}


void HydroPython(double ene,int nucleus_judge,int pro_para_1,int pro_para_2,int tar_para_1,int tar_para_2){
  char command[200];
  sprintf(command,"python ./urqmd_vishnew/run.py %g %d %d %d %d %d",ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2);
  // cout<<command<<endl;
  system(command);
}

void HydroRun_(int proj_id,int tar,double gamma,double mass0,double phi_x,double phi_y,double phi_z,int nptl,int nspec,int idptl[],double pptl[][5]){
  //initial the particle information
  //elab per nucleon
  double ene=gamma*mass0;
  //projectile information
  //if =1 , is nucleus
  int nucleus_judge,pro_A,pro_Z,pro_pid,pro_iso3;
  if(proj_id>=200){
    nucleus_judge=1;
    pro_A=proj_id/100;
    pro_Z=proj_id-pro_A*100;
    ene/=pro_A;
  }
  else{
    nucleus_judge=0;
    if(proj_id==14){
      //p+
      pro_pid=1;
      pro_iso3=1;
    }
    else if(proj_id==15){
      //p-
      pro_pid=-1;
      pro_iso3=-1;
    }
    else if(proj_id==7){
      //pi0
      pro_pid=101;
      pro_iso3=0;
    }
    else if(proj_id==8){
      //pi+
      pro_pid=101;
      pro_iso3=2;
    }
    else if(proj_id==9){
      //pi0
      pro_pid=101;
      pro_iso3=-2;
    }
  }

  //target information
  int tar_A,tar_Z;
  if(tar==14){
    //N
    tar_A=14;
    tar_Z=7;
  }
  else if(tar==16){
    //O
    tar_A=16;
    tar_Z=8;
  }
  else if(tar==40){
    //Ar
    tar_A=40;
    tar_Z=18;
  }
  else{
    //unknown target
    tar_A=tar;
    tar_Z=tar/2;
  }

  
  if(nucleus_judge){
    HydroPython(ene,nucleus_judge,pro_A,pro_Z,tar_A,tar_Z);
  }
  else{
    HydroPython(ene,nucleus_judge,pro_pid,pro_iso3,tar_A,tar_Z);
  }
  //beta
  double beta0=sqrt(gamma*gamma-1);
  double beta[4]={gamma};
  //set beta to transform from cms to lab
  beta[1]=-beta0*phi_x,beta[2]=-beta0*phi_y,beta[3]=-beta0*phi_z;
}


void ReadHydro(double beta[4],int nptl,int nspec,int idptl[],double pptl[][5]){
  const string input_file_QGP="./urqmd_vishnew/urqmd/urqmd_QGP_19.txt";
  const string input_file_spec="./urqmd_vishnew/urqmd/urqmd_spec_19.txt";

  //begin read spectator
  ifstream input_spec(input_file_spec.c_str());
  string data_line;
  stringstream input_line;
  if(input_spec){
    //remove header
    for(int i=0;i<4;i++){
      data_line.clear();
      getline(input_spec,data_line);
    }
    while(true){
      getline(input_spec,data_line);
      if(input_spec.eof())break;
      input_line.clear();
      input_line.str(data_line);
      double p[4]={0};
      double pdg=0;
      double counter=0;
      double mass=0;
      //frezout position
      double x[4]={0};
      //particle counter
      input_line>>counter;
      //pdg id
      input_line>>pdg;
      //momentum
      input_line>>p[1]>>p[2]>>p[3]>>p[0];
      //p[3]<1 means it is spectator from target
      if(p[3]<1)continue;
      input_line>>mass;
      input_line>>x[1]>>x[2]>>x[3]>>x[0];
      //judge if it is spectator
      if(x[0]==0){
        idptl[nptl]=pdg;
        LorentzTransform(beta,p);
        for(int i=0;i<4;i++){
          pptl[nptl][i]=p[i];
        }
        pptl[nptl][4]=mass;
        nptl++;
        nspec++;
      }
    }
    input_spec.close();
  }

  //begin QGP
  ifstream input_QGP(input_file_QGP.c_str());
  //remove header
  for(int i=0;i<4;i++){
    data_line.clear();
    getline(input_QGP,data_line);
  }
  while(true){
    getline(input_QGP,data_line);
    if(input_QGP.eof())break;
    input_line.clear();
    input_line.str(data_line);
    double p[4]={0};
    double pdg=0;
    double counter=0;
    double mass=0;
    //frezout position
    double x[4]={0};
    //particle counter
    input_line>>counter;
    //pdg id
    input_line>>pdg;
    //momentum
    input_line>>p[1]>>p[2]>>p[3]>>p[0];
    input_line>>mass;
    idptl[nptl]=pdg;
    LorentzTransform(beta,p);
    for(int i=0;i<4;i++){
      pptl[nptl][i]=p[i];
    }
    pptl[nptl][4]=mass;
    nptl++;
  }
  input_QGP.close();
}