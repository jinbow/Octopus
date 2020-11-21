"""Calculate the lookup table for k to z conversion
Jinbo Wang
<jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015 """

from numpy import *
import sys

def test():
    center=r_[1500,107,25].reshape(-1,3)
    delta=r_[10,10,0.1].reshape(-1,3)
    xyz = random.random((npts,3)) - 0.5
    xyz = xyz*2*delta+center
    fn = 'particle_initial_xyz.bin'
    xyz.T.astype('>f8').tofile(fn)
    return

def test_transport():
    """
    xyz: array_like(npts,ndims)
       npts: number of particles
       ndims: number of dimensions (fixed to be 3 for x,y,z)
    """

    xyz=ones((4,3))
    
    #the first particle location: x=1, y=5
    xyz[0,0]=1
    xyz[0,1]=5

    #the second particle location: x=5, y=5
    xyz[1,0]=5
    xyz[1,1]=5

    #the third particle location: x=10, y=5
    xyz[2,0]=10
    xyz[2,1]=5
    
    #the fourth particle location: x=19.5, y=5
    xyz[3,0]=19.5
    xyz[3,1]=5

    fn='test_transport.4npts.bin'
    xyz.T.astype('>f8').tofile(fn)


if __name__=='__main__':
    npts=100  #the number of particles
    test_transport()
