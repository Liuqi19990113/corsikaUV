#include"../include/para_read.h"

void parameter::get_para(string parameter_path)
{
    ifstream parameter_file;
    parameter_file.open(parameter_path,ios::in);
    stringstream sstem_line;
    string stem_line;
    string para_char;
    stem_line.clear();
    double tem_variable = 0;

    for (int i = 1;i<=2;i++)
    {
        getline(parameter_file,stem_line);
        sstem_line.clear();
        sstem_line.str(stem_line);
        for(int j = 1;j<=2;j++) 
        {
            sstem_line >> para_char;
            para_char.clear(); 
        }
        sstem_line >> tem_variable;
        switch (i)
        {
        case 1:
            qgp_option = tem_variable;
            break;
        case 2:
            eta_or_y_option = tem_variable;
            break;
        }
    }


    if(eta_or_y_option == 0 | eta_or_y_option ==3)
    {
        for (int i = 1; i <= 4; i++)
        {
            getline(parameter_file,stem_line);
            if(i==3)
            {sstem_line.clear();
             sstem_line.str(stem_line);
             for(int j = 1;j<=2;j++)
             {
            sstem_line >> para_char;
            para_char.clear(); 
             }
             sstem_line >> tem_variable;
             eta_left = tem_variable;
            }
            if(i==4)
            {sstem_line.clear();
             sstem_line.str(stem_line);
             for(int j = 1;j<=2;j++)
             {
            sstem_line >> para_char;
            para_char.clear(); 
             }
             sstem_line >> tem_variable;
             eta_right = tem_variable;
            }    
        }
    }

    if(eta_or_y_option == 1)
    {
        for (int i = 1; i <= 4; i++)
        {
            getline(parameter_file,stem_line);
            if(i==1)
            {sstem_line.clear();
             sstem_line.str(stem_line);
             for(int j = 1;j<=2;j++)
             {
            sstem_line >> para_char;
            para_char.clear(); 
             }
            sstem_line >> tem_variable;
             y_left = tem_variable;
            }
            if(i==2)
            {sstem_line.clear();
             sstem_line.str(stem_line);
             for(int j = 1;j<=2;j++)
             {
            sstem_line >> para_char;
            para_char.clear(); 
             }
             sstem_line >> tem_variable;
             y_right = tem_variable;
            }    
        }
    }


getline(parameter_file,stem_line);  
sstem_line.clear();
sstem_line.str(stem_line);
for(int j = 1;j<=2;j++)
{
sstem_line >> para_char;
para_char.clear(); 
}
sstem_line >> tem_variable;
y_step = tem_variable;

getline(parameter_file,stem_line);  
sstem_line.clear();
sstem_line.str(stem_line);
for(int j = 1;j<=2;j++)
{
sstem_line >> para_char;
para_char.clear(); 
}
sstem_line >> tem_variable;
accept_error = tem_variable;






}

















