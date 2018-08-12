# Procedural model fitting (PMF)

Implementation (MATLAB source code) and discussion of the procedural model fitting (PMF) method described in our paper: Robust procedural model fitting with a new geometric similarity estimator.

### Citing this code
Please cite the following paper:

Zhang, Zongliang and Li, Jonathan and Guo, Yulan and Li, Xin and Lin, Yangbin and Xiao, Guobao and Wang, Cheng. Robust procedural model fitting with a new geometric similarity estimator. _Pattern Recognition_ (2018). https://doi.org/10.1016/j.patcog.2018.07.027

### Using the code
The code has been tested in MATLAB R2018a, and could aslo work in MATLAB R2016 or R2017.

To execute the code, in the main PMF directory type one of these three commands:
```matlab
fit_cylinder;

fit_character;

fit_building;
```

### Computing resources

Please be patient! Executing the code in a single CPU is quite slow. Take a Intel(R) Core(TM) i5-3470 CPU @3.20GHz for example, it would take tens of minutes, a couple of hours, and tens of hours to fit_cylinder, fit_building, and fit_character, respectively. Fortunatly, the code can be naturely run in parallel to achieve few-shot character recognition.


### A practical tip for implementing

Please make sure that at least two points can be sampled from the model. In other words, taking 1-dimensional case as example, every model defined by the input probabilistic program should at least have a length of 2*\delta_{min}. The reason is as follows. The proposed method requires the model to be a continuous point set. If only one point can be sampled from the model, then the model is practically not qualified as a continuous point set.


### Contact
E-mail address of the first author (Zongliang Zhang) is: zhangzongliang@stu.xmu.edu.cn
E-mail address of the corresponding author (Jonathan Li) is: junli@xmu.edu.cn
