"""
Jinbo Wang
<jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015 
"""

from numpy import *
import sys

def test():
    fn='/nobackup/jwang23/llc4320_stripe/calval_california/diamond/diamond_california_swath_i13.h5'
    d=popy.io.loadh5(fn)
    lon,lat=d['XC'][:300],d['YC'][:300]

    xyz = random.random((npts,3)) - 0.5
    xyz = xyz*2*delta+center
    fn = 'particle_initial_xyz.bin'
    xyz.T.astype('>f8').tofile(fn)
    print "write particle initial positions to file "+fn
    return


if __name__=='__main__':
    npts=100  #the number of particles
    test()
