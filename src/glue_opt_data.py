"""
Glue outputs into a single binary file

Jinbo Wang
<jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015 """


import glob,os,sys
import numpy as np

#change this to the path of the data output
folder='test_grid/'

#you can glue one case or multi-cases at the same time, 'DIMES_0001' etc. are casenames
casenames=['test']

#specify particle numbers and case numbers (the NPP value in the namelist) here:
npts=40
npp=1

#you don't need to change the following.
varn=['XYZ','MLD','TSG','GRAD']
varn=['XYZ']
nn = [3,1,4,4]
for cn in casenames:
    for i in range(1,npp+1):
        casename='%s_%04i'%(cn,i)
        for iv,var in enumerate(varn):
            fns=sorted(glob.glob(folder+casename+'.%s.??????????.data'%var))
            if len(fns)!=0:
                print(casename,var,"total %i files"%len(fns))
                f=open('filenames_%s'%casename,'w')
                n=nn[iv]
                d=np.fromfile(fns[0],'>f4')
                d=d.reshape(n,npts)
                nxy,nopt=d.shape
                del d
                t0=fns[0].split('.')[-2]
                t1=fns[-1].split('.')[-2]
                dds=np.memmap(folder+casename+'.data',dtype='>f4',shape=(len(fns),n,nopt),mode='write')
                for i in range(len(fns)):
                    d=np.fromfile(fns[i],'>f4').reshape(n,-1)
                    f.writelines(fns[i])
                    dds[i,...]=d
                    del d
                    os.remove(fns[i])
                f.close()
                del dds,
