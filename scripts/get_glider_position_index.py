
def get_index():
    from pylab import *
    import popy
    from scipy.interpolate import LinearNDInterpolator as interp2d
    import scipy.interpolate
    import paths
    
    pthd='/nobackup/jwang23/llc4320_stripe/calval_california/diamond/diamond_california_swath_i13.h5'
    d=popy.io.loadh5(pthd)
    lats=d['YC'][130:300]
    lons=d['XC'][130:300]+360

    nx,ny=607,439
    dd=popy.io.loadnc(paths.grid_fn)
    lon0,lat0= dd['lon_u'][-ny:,-nx:],dd['lat_v'][-ny:,-nx:]
    print lon0.shape,lat0.shape
    
    i,j=meshgrid(arange(nx),arange(ny))
    
    itpi=interp2d((lon0.ravel(),lat0.ravel()),i.flatten())
    itpj=interp2d((lon0.ravel(),lat0.ravel()),j.flatten())

     
    scatter(lon0,lat0,s=2,marker='+')
    plot(lons,lats,'ro')
    show()

    d=c_[lons.reshape(-1,1),lats.reshape(-1,1)]
    x1=arange(lons.size)*2.0
    x2=arange(0,lons.size*2,7.5)
    itp=scipy.interpolate.interp1d(x1,d,axis=0)
    dd=itp(x2)
    
    clf()
    pcolor(lon0)
    lons,lats=dd[:,0],dd[:,1]
    print lons,lats
    
    ijk=zeros((3,len(lons)))
    for i in range(lons.size):
        lon,lat=lons[i],lats[i]
        ijk[0,i]=itpi(lon,lat)
        ijk[1,i]=itpj(lon,lat)
        plot(ijk[0,i],ijk[1,i],'bo')
    show() 

    ijk[2,:]=66
    ijk.astype('>f8').tofile('swot_calval_glider_%i.bin'%len(lons))

    return


if __name__=='__main__':
    get_index()
