from numpy import *
import sys
#to run this script in commandline:
# python init_parti_xyz.py

def glider_target(npts=20):

    xyz=zeros((npts,2))
    xy[:,0]=400
    return


def case_test(npts=20):
    xyz=zeros((npts,3))
    xyz[:,0]= linspace(5,6,npts) # x index 100 points
    xyz[:,1]= 15 #constant y
    xyz[:,2]=2 # at k=20 level, z level will be overwritten if the target_density in the namelist is larger than 0.

    xyz[:,0] = 400.0
    xyz[:,1] = linspace(20,120,npts)
    xyz[:,2] = 0

    xyz.T.astype('>f8').tofile('particle_init.bin') #the saving sequence should be x[:], y[:], z[:], not [x1,y1,z1],[x2,y2,z2]...

    return


if __name__=='__main__':
    case_test()
