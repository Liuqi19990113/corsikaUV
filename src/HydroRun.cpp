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
  void hydro_run_(const int&proj_id,const int&tar,const double&gamma,const double&m_pro,const double&cos_x,const double&cos_y,const double&cos_z,int&nptl,int&nspec,int idptl[],double pptl[][5]);
  /**read particle from hydro output file*/
  void ReadHydro(double beta[4],int&nptl,int&nspec,int idptl[],double pptl[][5]);
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

void hydro_run_(const int&proj_id,const int&tar,const double&gamma,const double&m_pro,const double&cos_x,const double&cos_y,const double&cos_z,int&nptl,int&nspec,int idptl[],double pptl[][5]){
  //initial the particle information
  //mass of proton and neutron
  const double m_p=0.938272013,m_n=0.939565346;
  const double E_pro=gamma*m_pro;
  double ene=E_pro;
  int nucleus_judge,pro_A,pro_Z,pro_pid,pro_iso3;
  //projectile information
  //if =1 , is nucleus
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
    if(tar<=0||tar>208){
      cerr<<"wrong :tar ="<<tar<<endl;
      exit(-1);
    }
  }
  const double m_tar=tar_Z*m_p+(tar_A-tar_Z)*m_n;


  // run python script
  if(nucleus_judge){
    HydroPython(ene,nucleus_judge,pro_A,pro_Z,tar_A,tar_Z);
  }
  else{
    HydroPython(ene,nucleus_judge,pro_pid,pro_iso3,tar_A,tar_Z);
  }

  //beta
  double momentum=sqrt(gamma*gamma-1)*m_pro;
  const double beta0=momentum/(E_pro+m_tar);
  const double gamma0=1/sqrt(1-beta0*beta0);
  double beta[4]={gamma0};
  //set beta to transform from cms to lab
  beta[1]=-beta0*cos_x,beta[2]=-beta0*cos_y,beta[3]=-beta0*cos_z;
  ReadHydro(beta,nptl,nspec,idptl,pptl);
  double p_sum[4]={0};
  for(int i=0;i<nptl;i++){
    for(int j=0;j<4;j++){
      p_sum[j]+=pptl[i][j];
    }
  }
}


void ReadHydro(double beta[4],int&nptl,int&nspec,int idptl[],double pptl[][5]){
  string input_file_QGP="./urqmd_vishnew/urqmd/urqmd_QGP_19.txt";
  string input_file_spec="./urqmd_vishnew/urqmd/urqmd_spec_19.txt";
  nptl=0;
  
  ifstream input_QGP(input_file_QGP.c_str());
  string data_line;
  stringstream input_line;

  double energy_cms=0;

  //judge if use hydro
  bool QGP_judge=false;
  if(input_QGP){
    QGP_judge=true;
  }
  //begin QGP
  if(input_QGP){
    //remove header
    for(int i=0;i<4;i++){
      data_line.clear();
      getline(input_QGP,data_line);
    }
    while(true){
      data_line.clear();
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
      energy_cms+=p[0];
      LorentzTransform(beta,p);
      for(int i=0;i<3;i++){
        pptl[nptl][i]=p[i+1];
      }
      pptl[nptl][3]=p[0];
      pptl[nptl][4]=mass;
      nptl++;
    }
    input_QGP.close();
  }

  //get beta of spectator
  ifstream input_spec(input_file_spec.c_str());
  double beta_spec[4]={0};
  double p_spec[4]={0};
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
      for(int i=0;i<4;i++){
        p_spec[i]+=p[i];
      }
    }
    input_spec.close();
  }
  
  for(int i=1;i<4;i++){
    beta_spec[i]=p_spec[i]/p_spec[0];
  }
  beta_spec[0]=1/sqrt(1-beta_spec[1]*beta_spec[1]-beta_spec[2]*beta_spec[2]-beta_spec[3]*beta_spec[3]);
  //read spectator
  input_spec.open(input_file_spec.c_str());
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
      input_line>>mass;
      input_line>>x[1]>>x[2]>>x[3]>>x[0];
      //if use QGP, only spectator,if not use QGP, all particle
      if(x[0]==0||!QGP_judge){
        idptl[nptl]=pdg;
        // to cms system
        LorentzTransform(beta_spec,p);
        energy_cms+=p[0];
        // to lab system
        LorentzTransform(beta,p);
        for(int i=0;i<3;i++){
          pptl[nptl][i]=p[i+1];
        }
        pptl[nptl][3]=p[0];
        pptl[nptl][4]=mass;
        nptl++;
        nspec++;
      }
    }
    input_spec.close();
  }
  if(QGP_judge){
    cout<<"have QGP\n";
  }
}