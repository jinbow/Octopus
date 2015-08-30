"""Calculate the lookup table for k to z conversion
Jinbo Wang
<jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015 """


from sosepy import sose
from scipy.interpolate import interp1d
from numpy import *
from pylab import *

z=sose.loadparameter('RF').flatten()
z=abs(z)
z[0]=0
print z
print z.shape
ff=interp1d(linspace(0,42,43),z,'cubic')
print ff(r_[10,10.1])
newz = ff(linspace(0,42,421))
newz.astype('>f4').tofile('k_to_z_lookup_table.bin')
plot(linspace(0,42,43),z,'o')
plot(linspace(0,42,421),newz,'-')
show()
print newz.shape
print newz
