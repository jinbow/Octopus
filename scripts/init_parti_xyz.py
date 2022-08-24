"""Calculate the lookup table for k to z conversion
Jinbo Wang
<jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015 """

from numpy import *
import sys

def test():
    center=r_[10,10,25].reshape(-1,3)
    delta=r_[1,1,0.1].reshape(-1,3)
    xyz = random.random((npts,3)) - 0.5
    xyz = xyz*2*delta+center
    fn = 'particle_initial_xyz.bin'
    xyz.T.astype('>f8').tofile(fn)
    print("write particle initial positions to file "+fn)
    return


if __name__=='__main__':
    npts=21  #  the number of particles
    test()
