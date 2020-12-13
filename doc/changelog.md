# changelog

此文档记录了我在对corsika尝试进行的一些修改，主要记录了添加的变量以及基本修改内容

## 09-18

计算高能模型调用次数/high_counter/

```fortran
c---------------------------------------------------------------------
c 记录高能碰撞次数信息
        integer :: SDPM_counter,NUC_counter,NUC5_counter,NUC6_counter&
                ,NUC7_counter,NUC8_counter,counter_file_id
        character(len=30)::counter_file="./counter_file.dat"
        common /high_counter/ SDPM_counter,NUC_counter,NUC5_counter&
                ,NUC6_counter,NUC7_counter,NUC8_counter,counter_file_id
        common /high_counter/ counter_file
c 以上变量分别在CORSIKAMAIN和SDPM中声明，在CORSIKAMAIN中初始化
c SDPM_counter = 调用SDPM函数的次数,进入SDPM后+1
c NUC_counter = 在SDPM用pn和原子核进行作用的次数，进入SDPM后判断成立加一
c NUC5_counter = 在SDPM用10^5~6GeV pn和原子核进行作用的次数，进入SDPM后判断成立加一
c NUC6_counter = 在SDPM用10^6~7GeV pn和原子核进行作用的次数，进入SDPM后判断成立加一
c NUC7_counter = 在SDPM用10^7GeV以上pn和原子核进行作用的次数，进入SDPM后判断成立加一
c counter_file_id = 储存结果的通道号
c----------------------------------------------------------------------
c       CORSIKAMAIN 内的语句
        SDPM_counter=0
        NUC_counter=0
        NUC5_counter=0
        NUC6_counter=0
        NUC7_counter=0
        NUC8_counter=0
        counter_file_id=102
        open(Unit=counter_file_id,File=counter_file,Format="formatted")
c       SDPM内的语句
        integer :: ELABN_counter=0
c ELABN_counter = projectile的能量
c------------------------------------------------------------------------
```

## 09-21

变量同09-18，但将原先的记录原子核改为记录所有含有夸克的粒子，并修改了计数的变量名

```fortran
c 记录高能碰撞次数信息
      integer :: SDPM_counter,HARD_counter,HARD5_counter
     &        ,HARD6_counter
     &        ,HARD7_counter,HARD8_counter,counter_file_id
      character(len=30)::counter_file="./counter_file.dat"
      common /high_counter/ SDPM_counter,HARD_counter
     &          ,HARD5_counter
     &          ,HARD6_counter,HARD7_counter,HARD8_counter
     &          ,counter_file_id
      common /high_counter/ counter_file
c 以上变量分别在CORSIKAMAIN和SDPM中声明，在CORSIKAMAIN中初始化
c SDPM_counter = 调用SDPM函数的次数,进入SDPM后+1
c HARD_counter = 在SDPM用hardron进行作用的次数，进入SDPM后判断成立加一
c HARD5_counter = 在SDPM用10^5GeV以上hardron进行作用的次数，进入SDPM后判断成立加一
c HARD6_counter = 在SDPM用10^6GeV以上hardron进行作用的次数，进入SDPM后判断成立加一
c HARD7_counter = 在SDPM用10^7GeV以上hardron进行作用的次数，进入SDPM后判断成立加一
c counter_file_id = 储存结果的通道号
c----------------------------------------------------------------------
c       CORSIKAMAIN 内的语句
        SDPM_counter=0
        HARD_counter=0
        HARD5_counter=0
        HARD6_counter=0
        HARD7_counter=0
        HARD8_counter=0
        counter_file_id=102
        open(Unit=counter_file_id,File=counter_file,Format="formatted")
c       SDPM内的语句
        integer :: ELABN_counter=0
c ELABN_counter = projectile的能量
c------------------------------------------------------------------------
```

## 09-23

添加变量记录7-8GeV的hardron的详细信息

```fortran
c 记录高能碰撞次数信息
      integer :: SDPM_counter,HARD_counter,HARD5_counter
     &        ,HARD6_counter
     &        ,HARD7_counter,HARD8_counter,counter_file_id
      character(len=30) counter_file
      integer :: HARD7_bin
      common /high_counter/
     &          HARD7_bin
     &          ,counter_file
     &          ,SDPM_counter,HARD_counter
     &          ,HARD5_counter
     &          ,HARD6_counter,HARD7_counter,HARD8_counter
     &          ,counter_file_id
c 以上变量分别在CORSIKAMAIN和SDPM中声明，在CORSIKAMAIN中初始化
c SDPM_counter = 调用SDPM函数的次数,进入SDPM后+1
c HARD_counter = 在SDPM用hardron进行作用的次数，进入SDPM后判断成立加一
c HARD5_counter = 在SDPM用10^5GeV以上hardron进行作用的次数，进入SDPM后判断成立加一
c HARD6_counter = 在SDPM用10^6GeV以上hardron进行作用的次数，进入SDPM后判断成立加一
c HARD7_counter = 在SDPM用10^7GeV以上hardron进行作用的次数，进入SDPM后判断成立加一
c HARD8_counter = 在SDPM用10^8GeV以上hardron进行作用的次数，进入SDPM后判断成立加一
c counter_file_id = 储存结果的通道号
c HARD7_bin(9) = 存储7-8GeV的hardron分布
c----------------------------------------------------------------------
c       CORSIKAMAIN 内的初始化
        counter_file="./counter_file.dat"
        SDPM_counter=0
        HARD_counter=0
        HARD5_counter=0
        HARD6_counter=0
        HARD7_counter=0
        HARD8_counter=0
        HARD7_bin(:)=0
        counter_file_id=102
        open(Unit=counter_file_id,File=counter_file,Format="formatted")
c       SDPM内的初始化
        integer :: ELABN_counter=0
c ELABN_counter = projectile的能量
c------------------------------------------------------------------------
```
