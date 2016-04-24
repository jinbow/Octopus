# Octopus
##Offline calculation of particle trajectories

This model is in a development stage. Email me for questions.

Jinbo Wang <jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015


There are two configurations: Lagrangian particle and Argo float. 

Use "make" to compile the code for Lagrangian particle simulation. Use "make argo" for simulating Argo float. 

Before running the model, go to scripts folder and run "python gen_data.py" to compute the necessary data needed by the code.


###Lagrangian particle simulation

#### Steps to run:

 1. The model is currently setup for the Southern Ocean State Estimate (SOSE). But it can be easily modified to fit any MITgcm output or any C-grid model output. To run the code, first make sure the model knows where to find your model output and correctly reads them. Edit the parameters in src/size.h to fit the data you have.
 1. Set parameters in the namelist file **data.nml**. The parameters are explained line by line in src/data.nml.explained.
 1. Go to src/ folder. Compile the code using

     make

   You will get an excutable file named **O.particle**.

 1. Prepare the initialization file using scritps/init_particl_xyz.py. Copy the binary file to src/.
 1. If you run particle with the SOSE 1/6th degree simulation, download necessary binary files:
    >bash sync_data.sh

    otherwise, go to scripts folder and run
    >python gen_data.py

    to generate the binary files.
    
    After running gen_data.py, you should get a list of binary files in your pth_data_out folder including

    1. reflect_x.bin
    1. reflect_y.bin
    1. z_to_k_lookup_table.bin
    1. k_to_z_lookup_table.bin.
    

 1. In the src/ folder, run the model

    >./O.particle

 1. Outputs are saved in the folder  **output_dir** specified in **data.nml**.


Good luck!


Jinbo Wang
~                                                                                                                                                                                                           
~                                                                                                                                                                                                           
~                                                                                                                                                                                                           
~                          
