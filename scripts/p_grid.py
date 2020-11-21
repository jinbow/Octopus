"""
plot the grid layout
"""

import pylab as plt
import numpy as np

if __name__=='__main__':

    Nx=2
    Ny=2

    x_u=np.arange(0,Nx+1)
    x_v=np.arange(0.5,Nx+1)
    y_u=np.arange(0.5,Ny+1)
    y_v=np.arange(0,Ny+1)

    for i in range(Nx+4):
        plt.vlines(i-2,-2,Ny+1,ls='--',lw=1)
    for j in range(Ny+4):
        plt.hlines(j-2,-2,Nx+1,ls='--',lw=1)
    plt.plot([0,Nx,Nx,0,0],[0,0,Ny,Ny,0],lw=4,alpha=0.4,color='b')

    
    for i in range(2,Nx+2):
        for j in range(2,Ny+2):
            plt.text(i-2,j-2+0.5,'u')
            plt.text(i-2+0.5,j-2,'v')
    for i in [0,1,Ny+2,Ny+3]:
        for j in range(Ny+4):
            plt.text(i-2,j-2+0.5,'u',color='r')
            plt.text(i-2+0.5,j-2,'v',color='r')
    for i in range(Nx+4):
        for j in [0,1,Nx+2,Nx+3]:
            plt.text(i-2,j-2+0.5,'u',color='r')
            plt.text(i-2+0.5,j-2,'v',color='r')

    plt.text(-2,-2.3,'i=-2')
    plt.text(-2.5,-2,'j=-2')
    plt.text(-1,-2.3,'i=-1')
    plt.text(-2.5,-1,'j=-1')
    plt.text(0,-2.3,'i=0')
    plt.text(-2.5,0,'j=0')
    plt.text(Nx,-2.3,'i=Nx')
    plt.text(-2.5,Ny,'j=Ny')
    plt.hlines(0,-2,Nx+1,color='orange')
    plt.vlines(0,-2,Ny+1,color='orange')

    plt.text(-2,-3,'solid boundary',color='b',fontsize=12)
    plt.text(0,-3,'ghost points',color='r',fontsize=12)
    plt.text(2,-3,'model output',color='k',fontsize=12)
    plt.text(-1,-4,'Octopus horizontal grid layout')
    plt.axis('off')
    plt.tight_layout()
    plt.savefig('../docs/source/horizontal_grid_layout.png',dpi=150)
