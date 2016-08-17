import numpy as np
import scipy as sp
import pylab as plt


def gen_grid(nx,ny,nz):
    i_f=np.arange(nx)
    i_c=np.arange(nx)+0.5
    j_f=np.arange(ny)
    j_c=np.arange(ny)+0.5
    dxx=dyy=2e3
    dx=np.ones((ny,nx))*dxx
    dy=np.ones((ny,nx))*dyy

    x_f=i_f*dxx
    x_c=i_c*dxx

    y_f=j_f*dxx
    y_c=j_c*dxx

    psi0=1e4

    x0=nx/2.0*dxx
    y0=ny/2.0*dyy
    r = dxx * 10
    xu,yu=np.meshgrid(x_f,y_c)
    xv,yv=np.meshgrid(x_c,y_f)

    u=psi0/r**2*(yu-x0)*np.exp((-(xu-x0)**2-(yu-y0)**2)/r**2)
    v=-psi0/r**2*(xv-y0)*np.exp((-(xv-x0)**2-(yv-y0)**2)/r**2)

    w=np.zeros((nz,ny,nx))

    u=u*np.ones_like(w)
    v=v*np.ones_like(w)

    hfacc=np.ones_like(w)

    drf=np.ones((nz))*10.0

    hfacc.astype('>f4').tofile('hFacC.data')
    dx.astype('>f4').tofile('DYC.data')
    dy.astype('>f4').tofile('DYC.data')
    drf.astype('>f4').tofile('DRF.data')

    for i in range(20):
        app='_%04i.data'%i
        u.astype('>f4').tofile('UVEL'+app)
        v.astype('>f4').tofile('VVEL'+app)
        w.astype('>f4').tofile('WVEL'+app)
    print u.max()

    plt.quiver(u[0,...],v[0,...])
    plt.show()

    return

gen_grid(30,30,10)
