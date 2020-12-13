#include<iostream>
#include<stdlib.h>
#include<algorithm>
#include<cmath>
#include<ctime>
#include<random>
using namespace std;
extern "C"{
  /**run hydro from corsika*/
  void HydroRun_(int proj_id,int tar,double gamma,double mass0,double phi_x,double phi_y,double phi_z);
}
void HydroRun_(int proj_id,int tar,double gamma,double mass0,double phi_z,double phi_x,double phi_y){
  //initial the particle information
  //elab per nucleon
  double ene=gamma*mass0;
  //projectile information
  //if =1 , is nucleus
  int nucleus_judge,pro_A,pro_Z,pro_pid,pro_iso3;
  if(proj_id>=200){
    nucleus_judge=1;
    pro_A=proj_id%100;
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
  beta[1]=beta0*phi_x,beta[2]=beta0*phi_y,beta[3]=beta0*phi_z;
}


/**do Lorentz transformation from (p[0],p[1],p[2],p[3]) to (E,px,py,pz)*/
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

//use python shell to get particle information
void HydroPython(double ene,int nucleus_judge,double pro_para_1,double pro_para_2,double tar_para_1,double tar_para_2){
  system("python ./run.py");
}
// test code 
// int main(){
//   std::default_random_engine e;
//   e.seed(int(time(0)));
//   std::uniform_real_distribution<double>rndgen(-1./3,1./3);
//   double beta_x=rndgen(e),beta_y=rndgen(e),beta_z=rndgen(e);
//   double gamma=1/sqrt(1-(beta_x*beta_x+beta_y*beta_y+beta_z*beta_z));
//   double E=10,px=E*beta_x,py=E*beta_y,pz=E*beta_z;
//   cout<<E<<' '<<px<<' '<<py<<' '<<pz<<endl;
//   LorentzTransform(gamma,beta_x,beta_y,beta_z,E,px,py,pz);
//   cout<<E<<' '<<px<<' '<<py<<' '<<pz<<endl;
//   LorentzTransform(gamma,-beta_x,-beta_y,-beta_z,E,px,py,pz);
//   cout<<E<<' '<<px<<' '<<py<<' '<<pz<<endl;
// }