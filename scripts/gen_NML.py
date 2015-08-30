"""
Batch generate namelist

Jinbo Wang
<jinbow@gmail.com>
Scripps Institution of Oceanography
August 26, 2015 """


from datetime import date

fn='NML.FTLE_vertical_x1500_diff'

f=open(fn,'r')

lns = f.readlines()
print lns
f.close()
app = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']

casename='Diff_vertical_x1500'
for m in range(12):
    fn=casename+'_t%i'%(m*30)
    print fn
    for i in range(len(lns)):
        if 'casename' in lns[i]:
            lns[i]="casename='%s_t%i',\n"%(casename,m*30)
        if 'tstart' in lns[i]:
            lns[i]="tstart=%i,\n"%(m*30*86400)
        if 'tend' in lns[i]:
            lns[i]="tend=%i,\n"%((m*30+200)*86400)
        if 'fn_parti' in lns[i]:
            lns[i]="fn_parti_init='DP_FTLE_particle_initial_xyz_vertical_x1500_diff.bin',\n"
        if 'dump' in lns[i]:
            lns[i]="dumpFreq=864000,\n"
    ff=open('NML.'+casename+'_t%i'%(m*30),'w')
    ff.writelines(lns)
    ff.close()
    ln = []
    ln.append("nDims = [   2 ];\n")
    ln.append("dimList = [\n")
    ln.append("    1799520,         1,    1799520,\n")
    ln.append("    20,         1,     20  ];\n    dataprec = [ 'float32' ];\n    nrecords = [     1 ];\n" )
    print ln
    ff=open(casename+'.meta','w')
    ff.writelines(ln)
    ff.close()
