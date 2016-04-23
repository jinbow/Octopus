""" 
This file generates the binary files for reflective bottom boundary condition.

you only need to edit fn_hFacc to point to the correct hFacC file.

Jinbo Wang
<jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015 

"""

from numpy import *
from scipy.interpolate import NearestNDInterpolator as npi 
from pylab import *

nz,ny,nx=42,320,2160 #the model grid size


fn_hFacC='../data/hFacC.data'
hfac=fromfile(fn_hFacC,'>f4').reshape(nz,ny,nx)

y=arange(ny)
x=arange(-10,nx+10)
xx,yy=meshgrid(x,y)
xs=xx.flatten()
ys=yy.flatten()

newx=zeros((nz,ny,nx+20))
newy=zeros((nz,ny,nx+20))

for k in arange(nz):
    print k
    hfc=hfac[k,...]
    hf=c_[hfc[:,-10:],hfc,hfc[:,:10]]
    ip=(hf.flatten()>0)
    px = npi((xs[ip],ys[ip]),xs[ip])
    py = npi((xs[ip],ys[ip]),ys[ip])
    newx[k,...]=(px((xx,yy)).reshape(ny,-1))#[:,1:-1]
    newy[k,...]=(py((xx,yy)).reshape(ny,-1))#[:,1:-1]
    del hfc, hf, ip, py, px

newx[...,8:-8].astype('>f4').tofile('reflect_x.bin')
newy[...,8:-8].astype('>f4').tofile('reflect_y.bin')

#popy.io.saveh5('reflect_dy.h5','d',newy)
#popy.io.saveh5('reflect_dx.h5','d',newx)
#i0,i1,j0,j1=0,200,116,320
#pcolor(newx[20,...])
#show()
# i0,i1,j0,j1=0,180,0,80
# for i in range(i0,i1):
#     for j in range(j0,j1):
#         plot(r_[newx[15,j,i]+3.5,xx[j,i]+3.5],r_[newy[15,j,i]+0.5-j0,yy[j,i]+0.5-j0])
#dx=newx[38,...]-xx
#dy=newy[38,...]-yy
#print dy[:5,:]
#show()
