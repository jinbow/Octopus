""" Plot some trajectories
Jinbo Wang
<jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015 """


from numpy import *
from pylab import *

fn='/net/mazdata2/jinbo/mdata5-jinbo/Project_data/opt/DIMES_ensemble/glued/DIMES_0004_0033.XYZ.0000000166.0000002161.data' #put a glued XYZ data filename 
npts=35000 #specify particle numbers
opt=fromfile(fn,'>f4').reshape(-1,3,npts)

print "data has %i records"%(opt.shape[0])

#plot some trajectories
x,y=opt[:,0,:10],opt[:,1,:10] #this is in model grid index coordinate, convert to lat-lon using x=x/6.0;y=y/6.0-77.875
plot(x,y,'-')
xlabel('x')
ylabel('y')
show()
