""" 
This file generates the binary files need to run Octopus based on MITgcm grid files.

You only need to specify the path to the folder containing grid files, including
RF.data, hFacF.data

Jinbo Wang
<jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015 

"""
import numpy as np
import pylab as plt
import os,sys

def reflective_boundary():
    from scipy.interpolate import NearestNDInterpolator as npi 
    
    nz,ny,nx=42,320,2160 #the model grid size
    
    
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
        print k
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
    return

def k2zbin():
    
    #edit fn_RF to point to the correct RF.data
    fn_RF=pth_data_in+'RF.data'
    try:
        z=np.fromfile(fn_RF,'>f4')
    except:
        sys.exit(' ^o^ '*20+'%s does not exist, please double check.'%fn_RF+
                ' ^p^ '*20)
        
    z=abs(z)
    z[0]=0
    print z
    print z.shape
    ff=np.interp1d(np.linspace(0,42,43),z,'cubic')
    newz = ff(np.linspace(0,42,421))
    newz.astype('>f4').tofile('k_to_z_lookup_table.bin')
    plt.plot(np.linspace(0,42,43),z,'o')
    plt.plot(np.linspace(0,42,421),newz,'-')
    plt.show()
    return
    
def check_folder_existence():
    if not os.path.exists(pth_data_out):
        os.popen('mkdir %s'%pth_data_out)
        print "%s does not exist, just created it for you."%pth_data_out
    if not os.path.exists(pth_data_in):
        sys.exit('%s does not exist, please double check.'%pth_data_in)
    return
    
if __name__=='__main__':
    '''change pth_data_out and pth_data_in according to your system,
       run the program using "python gen_data.py" '''
    pth_data_out='../data/' #path to Octopus grid data, sofe link works too
    pth_data_in='../data/' #path to MITgcm grid data, soft link works too
    check_folder_existence()
    reflective_boundary()
    k2zbin()
