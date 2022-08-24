""" 
This file generates the binary files need to run Octopus based on MITgcm grid files.

You only need to specify the path to the folder containing grid files, including
DRF.data, hFacF.data

Jinbo Wang
<jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015 

"""
import numpy as np
import scipy as sp
import pylab as plt
import os,sys
from scipy import interpolate

def reflective_boundary():
    from scipy.interpolate import NearestNDInterpolator as npi 
    
    
    
    fn_hFacC=pth_data_in+'hFacC.data'
    try:
        hfac=np.fromfile(fn_hFacC,'>f4').reshape(nz,ny,nx)
    except:
        sys.exit(' ^o^ '*20+'\n%s does not exist, please double check.\n'%fn_hFacC+
                 ' ^p^ '*20)
            
    
    
    y=np.arange(ny)
    x=np.arange(-10,nx+10)
    xx,yy=np.meshgrid(x,y)
    xs=xx.flatten()
    ys=yy.flatten()
    
    newx=np.zeros((nz,ny,nx+20))
    newy=np.zeros((nz,ny,nx+20))
    
    for k in np.arange(nz):
        print("calculating reflective boundary condition for model level",k)
        hfc=hfac[k,...]
        hf=np.c_[hfc[:,-10:],hfc,hfc[:,:10]]
        ip=(hf.flatten()>0)
        px = npi((xs[ip],ys[ip]),xs[ip])
        py = npi((xs[ip],ys[ip]),ys[ip])
        newx[k,...]=(px((xx,yy)).reshape(ny,-1))#[:,1:-1]
        newy[k,...]=(py((xx,yy)).reshape(ny,-1))#[:,1:-1]
        del hfc, hf, ip, py, px
    
    newx[...,8:-8].astype('>f4').tofile(pth_data_out+'/reflect_x.bin')
    newy[...,8:-8].astype('>f4').tofile(pth_data_out+'/reflect_y.bin')
    print("+"*40)
    print("  Saved files reflect_x.bin reflect_y.bin to %s "%pth_data_out)
    print("+"*40)
    
    return

def z2kbin(saveplot=False):
    
    #edit fn_RF to point to the correct RF.data
    fn_RF=pth_data_in+'RF.data'
    try:
        z=np.fromfile(fn_RF,'>f4')
        print("There are %i values in RF.data"%z.size)
    except:
        sys.exit(' ^o^ '*20+'%s does not exist, please double check.'%fn_RF+
                ' ^p^ '*20)
        
    z=abs(z)

    ff=interpolate.interp1d(z,np.linspace(0,nz,nz+1),'linear',
                               bounds_error=False,fill_value=nz)
    newz = ff(np.arange(6500))
    newz.astype('>f4').tofile(pth_data_out+'z_to_k_lookup_table.bin')

    if saveplot:
        plt.plot(np.linspace(0,nz,nz+1),z,'o')
        plt.plot(newz,np.arange(6500),'-')
        plt.savefig(pth_data_out+'z_to_k_lookup_table.bin.png')
    return

def k2zbin(saveplot=False):
    
    #edit fn_RF to point to the correct RF.data
    fn_RF=pth_data_in+'RF.data'
    try:
        z=np.fromfile(fn_RF,'>f4')
    except:
        sys.exit(' ^o^ '*20+'%s does not exist, please double check.'%fn_RF+
                ' ^p^ '*20)
        
    z=abs(z)
    ff=interpolate.interp1d(np.linspace(0,nz,nz+1),z,'linear')
    newz = ff(np.linspace(0,nz,nz*10+1))
    newz.astype('>f4').tofile(pth_data_out+'k_to_z_lookup_table.bin')
    if saveplot:
        plt.plot(np.linspace(0,nz,nz+1),z,'o')
        plt.plot(np.linspace(0,nz,nz*10+1),newz,'-')
        plt.savefig(pth_data_out+'k_to_z_lookup_table.bin.png')
    return
    
def check_folder_existence():
    if not os.path.exists(pth_data_out):
        os.popen('mkdir %s'%pth_data_out)
        print("%s does not exist, just created it for you."%pth_data_out)
    if not os.path.exists(pth_data_in):
        sys.exit('%s does not exist, please double check.'%pth_data_in)
    return
    
if __name__=='__main__':
    '''change pth_data_out and pth_data_in according to your system,
       run the program using "python gen_data.py" '''

    nz,ny,nx=104,1024,1801 #the model grid size

    pth_data_out='/home/jiw097/sose.grid/' 

    #path to MITgcm grid data, i.e., DXG.data,DYG.data etc.
    #this script will look for hFacC.data and RF.data in this folder to
    #generate necessary binary files for Ocotpus

    pth_data_in='/home/jiw097/sose.grid/' 

    check_folder_existence()
 
    #generate reflect_x.bin and reflect_y.bin
    # reflective_boundary()

    #generate k_to_z_lookup_table.bin and 
    k2zbin()
    #generate z_to_k_lookup_table.bin and 
    z2kbin()

