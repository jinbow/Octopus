Argo simulation
########################

Steps to run:
===============

Most of the steps are the same as for Lagrangian particle simulation with few exceptions. 

1. Make sure **isArgo** is defined in **cpp_options.h**:  **#define isArgo**
1. Use *"make argo"*  to compile the code. 
1. You will get a executable **O.argo** after successfully compiling the code. 
1. Run the code using

   >./O.argo

If you run into the following error message: 
Fortran runtime error: File '../data/DXG.data, DYG.data, or DRF.data' does not exist
You will need to go into the data directory and change the dxg.bin, dyg.bin, drf.bin to DXG.data, DYG.data, DRF.data . 
