# corsikaUV

本模块是基于`corsika-77400`版本进行编写的添加外接口的程序,同时这一外接口接入`urqmd_vishnew`

## 安装方式

限于github上传容量以及coriska版权,这里并没有放入完整的corsika,如果想要具体编译的话,对于corsika部分,可以将此程序中的`src`目录中的`corsika.F HydroRun.F HydroLink.F HydroStore.F`放入完整的corsika的`src`目录中,然后使用原来的`./coconut`方法进行编译.注意,新的接口只有在选择`EPOS`模型时才会生效

对于`urqmd_vishnew`部分的编译,可以直接在程序根目录

- `mkdir build`
- `cd build`
- `cmake ..`
- `make install`

然后所有的程序文件就会被安装到`run`目录内对应位置,之后可以通过直接复制粘贴内部的`urqmd_vishnew`到对应的完整coriska的`run`目录中可以运行

## 程序说明

建于这一程序并不成熟,所以做一内部细节的说明,方面后来查错

### urqmd_vishnew

这一部分可以直接参考`https://github.com/AlphaNotKnows/urqmd_vishnew/blob/master/readme.md`

### corsika.F

这一部分的主要修改有两部分

- 使用`#include`预编译指令插入`HydroRun.F HydroLink.F HydroStore.F`同时把程序中`CALL NEXLNK`全部替换为`CALL HydroLink`,意味着所有预处理`EPOS`的部分全部被我的接口接管

### HydroLink.F

这一部分是判断是否进行`urqmd_vishnew`的演化,如果进行就进入后续流程,如果不进行则返回`EPOS`的运行,有如下判据

- 判断能量是否高于一个临界值,当前临界值为$1e7GeV$
- 判断粒子种类`urqmd_vishnew`是否能够识别,当前能够识别的有所有原子核,p,$\bar{p}$,$\pi^{\pm,0}$

但判断成功的时候,程序获取一个随机数`seedh`作为后续的随机数种子,这一随机数会决定后续的`urqmd_vishnew`进行的绝大部分信息,除了`iSS`sample时的随即数

### HydroRun.F

这一部分是接口的核心处理部分,负责完成和`urqmd_vishnew`的对接以及对数据的处理,如果之后更换其他的模型,接口需要修改的基本上主要是这一部分,其中完成如下指令

- HydroRun: 将输入的参数转化的urqmd的参数,从而调用`run.py`进行urqmd_vishnew的演化
- ReadHydro: 将urqmd_vishnew读入urqmd_vishnew的输入文件,判断运行过程中是否有QGP,对粒子的能动量,是否时spectator等信息进行记录,并将粒子从NN参考系变换到lab参考系.注意这里对于QGP的判断是通过存在的文件判断的.最后`urqmd_vishnew/urqmd`中可能会有两个文件`urqmd_QGP_19.txt`和`urqmd_spec_19.txt`,前者记录QGP内的粒子的信息,后者记录其余粒子信息.如果不存在前者,证明不存在QGP

### HydroStore.F

这一部分基本上就是对于原来的`NSTORE`的一点修改,不过这里有两个值得注意的点

- 这里所有corsika无法识别的粒子是全部被抛弃,而非转化成为其他种类粒子,不过鉴于这些粒子数目非常少,几乎没有影响
- 这里对于REMANENT的部分的处理按照HydroLink的spectator记录来进行重写

### run.py

这一文件位于`urqmd_vishnew`内,是运行urqmd_vishnew的主要脚本.不过有几个需要关注的点需要提醒

- urqmd运行完之后会立刻进行transform,通过transform返回的QGP判据来判断是否进行QGP演化,如果不进行QGP演化,后续HydroRun就会读取urqmd使用相同随机数种子和参数运行的一个t=8000的结果.
- 这里修改了urqmd的一些输出,使其会返回urqmd运行过程中的碰撞数.但碰撞数为0的时候,会重新运行urqmd,同时随机数种子会加1.由于对于urqmd输出修改并不完善,所以但urqmd没有正常运行的时候,有时会出现一些报错信息,这些信息会被打印到控制台输出,同时urqmd会被重新运行.
- 这里transform需要设置为`DEBUG 0`,这样transform才能返回需要的QGP的volume `volume`和energy `E_core`用于判断.当前的判据是`E_core>E_0`的时候认为产生QGP,进行后续演化
- 由于我们需要从2+1结果获取3维数据,所以我们需要进行eta cut,这一操作用`iSS_cut`可执行文件实现.由于即使通过前面的QGP判据,还是存在有一些误判,导致无法找出合适的eta cut,程序内认为最多重复进行`critical_depth`次`iSS_cut`操作,但重复这么多次还没有找到时,认为实际上没有QGP,返回之前无QGP的流程.

### iSS_cut

这一程序的作用是对oversample的QGP粒子进行截断,得到符合能量守恒和动量守恒的粒子分布,这个截断对守恒有一个偏差值的上限,这个上限越高,能够截断成功的sample就越多,从而能够产生的QGP就越多.但是如果accept error过高,可能导致能量偏差积累过高导致末态能量偏差比较大
