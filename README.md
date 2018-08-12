# Procedural model fitting (PMF)

Implementation (MATLAB source code) and discussion of the procedural model fitting (PMF) method described in our paper: Robust procedural model fitting with a new geometric similarity estimator.

### Citing this code
Please cite the following paper:

Zhang, Zongliang and Li, Jonathan and Guo, Yulan and Li, Xin and Lin, Yangbin and Xiao, Guobao and Wang, Cheng. Robust procedural model fitting with a new geometric similarity estimator. _Pattern Recognition_ (2018). https://doi.org/10.1016/j.patcog.2018.07.027

### Using the code
The code has been tested in MATLAB R2018a, and could aslo work in MATLAB R2016 or R2017. To run the code, in the main PMF directory type one of the following three commands:
```matlab
fit_cylinder;

fit_character;

fit_building;
```

### Computing resources

Please be patient! Running the code on a single CPU is quite slow. Taking a Intel(R) Core(TM) i5-3470 CPU @3.20GHz for example, it would consume tens of minutes, a couple of hours, and tens of hours to _fit_cylinder_, _fit_building_, and _fit_character_, respectively. Fortunatly, the code can be naturally run in parallel to achieve few-shot character recognition.


### A practical tip for implementing

Please make sure that at least two points can be sampled from the model. In other words, taking 1-dimensional case as example, every model defined by the input probabilistic program should at least have a length of 2*\delta_{min}. The reason is as follows. The proposed method requires the model to be a continuous point set. If only one point can be sampled from the model, then the model is practically not qualified as a continuous point set.


### Contacts
E-mail address of the first author (Zongliang Zhang) is: zhangzongliang@stu.xmu.edu.cn

E-mail address of the corresponding author (Jonathan Li) is: junli@xmu.edu.cn

### Licenses
The main code of PMF is under MIT license. PMF employs the code of the cuckoo search algorithm and the code of the Bayesian program learning model, which have their own licenses (can be found in the involved folders). PMF also employs four datasets including MNIST, noisy MNIST, Semantic3D, and SCSC. These datasets have their own licenses also (can be found in the involved folders).