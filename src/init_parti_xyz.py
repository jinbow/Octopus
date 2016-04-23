from numpy import *
import sys
#to run this script in commandline:
# python init_parti_xyz.py
def case_test():
    npts=100
    xyz=zeros((npts,3))
    xyz[:,0]= linspace(1500,1600,npts) # x index 100 points
    xyz[:,1]= 318 #constant y
    xyz[:,2]=20 # at k=20 level, z level will be overwritten if the target_density in the namelist is larger than 0.

    xyz.T.astype('>f8').tofile('particle_init.bin') #the saving sequence should be x[:], y[:], z[:], not [x1,y1,z1],[x2,y2,z2]...

    return


if __name__=='__main__':
    case_test()
