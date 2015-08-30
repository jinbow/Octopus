# Octopus
Offline calculation of particle trajectories

This model is in a development stage. Email me for questions.

Jinbo Wang <jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015


Steps to run:

1. The model is currently setup for the Southern Ocean State Estimate (SOSE). But it can be easily modified to fit any MITgcm output or any C-grid model output.

   To run the code, first make sure the model knows where to find your model output and correctly reads them. Edit the parameters in src/size.h to fit the data you have.

2. Set parameters in the namelist file. I include an example in the src/NML.TEST_0000. The parameters are explained line by line in src/NML.TEST_0000.explained.


3. Go to src/ folder. Compile the code using

     make

   You will get an excutable file named opt.ensemble.

4. Prepare the initialization file using scritps/init_particl_xyz.py. Copy the binary file to src/.

5. Download necessary binary files:

   bash download_data.sh

5. In the src/ folder, run the model

     ./opt.ensemble < NML.TEST_0000

6. Outputs are saved in the src/output folder.


Good luck!


Jinbo Wang
~                                                                                                                                                                                                           
~                                                                                                                                                                                                           
~                                                                                                                                                                                                           
~                          
