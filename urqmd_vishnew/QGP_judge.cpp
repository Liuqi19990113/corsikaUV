#include<iostream>
#include<fstream>
#include<string>
#include<sstream>
using namespace std;
int main(int argc,char*argv[]){
  string input_file="urqmd_initial_19.txt";
  ifstream input(input_file.c_str());
  string data_line;
  stringstream input_line;
  //remove header
  for(int i=0;i<4;i++){
    data_line.clear();
    getline(input,data_line);
  }
  //energy in QGP and energy in spectator
  double QGP_energy=0,energy=0;
  int spec_num=0,secondaries=0;
  while(true){
    getline(input,data_line);
    if(input.eof())break;
    input_line.clear();
    input_line.str(data_line);
    double middle,this_energy;
    for(int i=0;i<11;i++){
      input_line>>middle;
      if(i==5){
        this_energy=middle;
        spec_num++;secondaries++;
        energy+=this_energy;
      }
      else if(i==10&&middle!=0){
        QGP_energy+=this_energy;
        spec_num--;
      }
    }
  }
  // -1:non-interact 0:not hydro 1:hydro 
  if(secondaries==spec_num){
    cout<< -1;
    return 0;  
  }
  //test 
  cout<<0;
  return 0;
  //the energy which will create QGP
  const double critical_energy=100000;
  if(QGP_energy>=critical_energy)cout<< 1;
  else cout<< 0;
  return 0;
}