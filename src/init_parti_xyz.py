from numpy import *
import sys
#to run this script in commandline:
# python init_parti_xyz.py



def case001(npts):
    xyz=zeros((npts,3))
    xyz[:,0]= [100-.5,110] # x index 100 points
    xyz[:,1]= [100-.5,110] #constant y
    xyz[:,2]=66 # at k=0 level, z level will be overwritten if the target_density in the namelist is larger than 0.

    xyz.T.astype('>f8').tofile('particle_init.bin') #the saving sequence should be x[:], y[:], z[:], not [x1,y1,z1],[x2,y2,z2]...

    return


def case_test(npts=2):
    xyz=zeros((npts,3))
    xyz[:,0]= [100-.5,110] # x index 100 points
    xyz[:,1]= [100-.5,110] #constant y
    xyz[:,2]=66 # at k=0 level, z level will be overwritten if the target_density in the namelist is larger than 0.

    xyz.T.astype('>f8').tofile('particle_init.bin') #the saving sequence should be x[:], y[:], z[:], not [x1,y1,z1],[x2,y2,z2]...

    return


if __name__=='__main__':
    case_test(npts=2)
