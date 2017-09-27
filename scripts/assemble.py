from pylab import *
import glob,os
import popy,sys

pth=sys.argv[1]
fns=sorted(glob.glob('%s/*G.IPP.000001.ip.*.cycle*'%pth))

for fn in fns:
    d=loadtxt(fn)
    vv=fn.split('.')
    var='%s/%s/%s/'%(vv[2][-3:],vv[4][-3:],vv[6][:])
    popy.io.saveh5('%s.h5'%pth,var,d.astype('>f4'))
    os.popen('rm %s'%fn)
    del d
