# pmf
Implementation (MATLAB code) and discussion of the procedural model fitting method described in our paper: Robust procedural model fitting with a new geometric similarity estimator. 


A useful tip for implementing:

Please make sure that at least two points can be sampled from the model. In other words, taking 1-dimensional case as example, every model defined by the input probabilistic program should at least have a length of 2*\delta_{min}. The reason is as follows. The proposed method requires the model to be a continuous point set. If only one point can be sampled from the model, then the model is practically not qualified as a continuous point set.


BibTex of the paper:

@article{zhang2018robust,

  title={Robust procedural model fitting with a new geometric similarity estimator},
  
  author={Zhang, Zongliang and Li, Jonathan and Guo, Yulan and Li, Xin and Lin, Yangbin and Xiao, Guobao and Wang, Cheng},
  
  journal={Pattern Recognition},
  
  year={2018},
  
  publisher={Elsevier},
  
  doi={https://doi.org/10.1016/j.patcog.2018.07.027}
  
}
