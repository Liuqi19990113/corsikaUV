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
  void hydro_run_(const int&proj_id,const int&tar,const double&gamma,const double&m_pro,int&nptl,int&nspec,int idptl[],double pptl[][5],int spec_judge[]);
  /**read particle from hydro output file*/
  void ReadHydro(const double beta[4],int&nptl,int&nspec,int idptl[],double pptl[][5],int spec_judge[]);
  /**do Lorentz transformation from (p[0],p[1],p[2],p[3]) to (px,py,pz,E)*/
  void LorentzTransform(const double beta[4],double p[4]);
  /**use python shell to get particle information*/
  void HydroPython(const double ene,const int nucleus_judge,const int pro_para_1,const int pro_para_2,const int tar_para_1,const int tar_para_2);
}

void LorentzTransform(const double beta[4],double p[4]){
  // double beta2=beta[0]*beta[0]+beta[1]*beta[1]+beta[2]*beta[2];
  // double beta_p=beta[0]*p[0]+beta[1]*p[1]+beta[2]*p[2];
  // double C=(beta[3]-1)/beta2;
  // double E=p[3]*beta[3]-beta[3]*beta_p;
  // double px=-beta[3]*beta[0]*p[3]+p[0]+C*beta[0]*beta_p;
  // double py=-beta[3]*beta[1]*p[3]+p[1]+C*beta[1]*beta_p;
  // double pz=-beta[3]*beta[2]*p[3]+p[2]+C*beta[2]*beta_p;
  // p[3]=E,p[0]=px,p[1]=py,p[2]=pz;
  double E=0,pz=0;
  pz=beta[3]*(p[2]-beta[2]*p[3]);
  E=beta[3]*(p[3]-beta[2]*p[2]);
  p[2]=pz;p[3]=E;
}


void HydroPython(const double ene,const int nucleus_judge,const int pro_para_1,const int pro_para_2,const int tar_para_1,const int tar_para_2){
  char command[200];
  sprintf(command,"python ./urqmd_vishnew/run.py %g %d %d %d %d %d",ene,nucleus_judge,pro_para_1,pro_para_2,tar_para_1,tar_para_2);
  // cout<<command<<endl;
  system(command);
}

void hydro_run_(const int&proj_id,const int&tar,const double&gamma,const double&m_pro,int&nptl,int&nspec,int idptl[],double pptl[][5],int spec_judge[]){
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
    else if(proj_id==13){
      //n
      pro_pid=1;
      pro_iso3=-1;
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
      //pi-
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
  double beta[4]={0,0,0,0};
  beta[3]=gamma0;
  //set beta to transform from cms to lab
  beta[2]=-beta0;
  ReadHydro(beta,nptl,nspec,idptl,pptl,spec_judge);
  // double E1=0,E0=0;
  // double E=0;
  // for(int i=0;i<nptl;i++){
  //   E+=pptl[i][3];
  //   if(spec_judge[i]==1){
  //     E0+=pptl[i][3];
  //     if(idptl[i]==2212){
  //       E1+=m_p*gamma;
  //     }
  //     else{
  //       E1+=m_n*gamma;
  //     }
  //   }
  // }
  // cout<<"mass error "<<(E1-E0)/(gamma*m_pro)<<' '<<(E1-E0)/E1<<endl;
  // cout<<"energy fraction "<<E/(gamma*m_pro)<<' '<<(E-E0+E1)/(gamma*m_pro)<<endl;
  return;
}


void ReadHydro(const double beta[4],int&nptl,int&nspec,int idptl[],double pptl[][5],int spec_judge[]){
  string input_file_QGP="./urqmd_vishnew/urqmd/urqmd_QGP_19.txt";
  string input_file_spec="./urqmd_vishnew/urqmd/urqmd_spec_19.txt";
  nptl=0;
  nspec=0;
  ifstream input_QGP(input_file_QGP.c_str());
  string data_line;
  stringstream input_line;

  //judge if use hydro
  bool QGP_judge=false;
  if(input_QGP){
    QGP_judge=true;
  }


  //get beta of spectator
  ifstream input_spec(input_file_spec.c_str());
  double p_spec=0,E_spec=0;

  //read spectator
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
      double p[4]={0,0,0,0};
      int pdg=0;
      int counter=0;
      double mass=0;
      //frezout position
      double x[4]={0,0,0,0};
      //particle counter
      input_line>>counter;
      //pdg id
      input_line>>pdg;
      //momentum
      input_line>>p[0]>>p[1]>>p[2]>>p[3];
      input_line>>mass;
      input_line>>x[0]>>x[1]>>x[2]>>x[3];
      //if use QGP, only spectator,if not use QGP, all particle
      p_spec+=p[2];
      E_spec+=p[3];
      //eliminate p_z<0 spectator
      // if((x[3]==0&&p[2]>0)||!QGP_judge){
      idptl[nptl]=pdg;
      spec_judge[nptl]=0;
      for(int i=0;i<4;i++){
        pptl[nptl][i]=p[i];
      }
      pptl[nptl][4]=mass;
      if(x[3]==0){
        //eliminate backwark spectator
        if(p[2]>0){
          nspec++;
          spec_judge[nptl]=1;
        }
        else{
          nptl--;
        }
      }
      nptl++;
      // }
    }
    input_spec.close();
    double beta_spec[4]={0,0,0,0};
    beta_spec[2]=p_spec/E_spec;
    beta_spec[3]=1/sqrt(1-beta_spec[2]*beta_spec[2]);

    for(int i=0;i<nptl;i++){
      double p[4]={0};
      LorentzTransform(beta_spec,pptl[i]);
      LorentzTransform(beta,pptl[i]);
    }
  }
  

  //begin QGP


  double p_QGP=0,E_QGP=0;
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
      int pdg=0;
      int counter=0;
      double mass=0;
      //frezout position
      double x[4]={0};
      //particle counter
      input_line>>counter;
      //pdg id
      input_line>>pdg;
      //momentum
      input_line>>p[0]>>p[1]>>p[2]>>p[3];
      input_line>>mass;
      idptl[nptl]=pdg;
      // LorentzTransform(beta,p);
      p_QGP+=p[2];
      E_QGP+=p[3];
      for(int i=0;i<4;i++){
        pptl[nptl][i]=p[i];
      }
      pptl[nptl][4]=mass;
      spec_judge[nptl]=0;
      nptl++;
    }
    input_QGP.close();

    double beta_QGP[4]={0,0,0,0};
    beta_QGP[2]=p_QGP/E_QGP;
    beta_QGP[3]=1/sqrt(1-beta_QGP[2]*beta_QGP[2]);
    for(int i=nspec;i<nptl;i++){
      // to cms system
      LorentzTransform(beta_QGP,pptl[i]);
      // to lab system
      LorentzTransform(beta,pptl[i]);
    }
  }



  // if(QGP_judge){
  //   cout<<"have QGP\n";
  // }
  // else
  // {
  //   cout<<"only urqmd\n";
  // }
  
}