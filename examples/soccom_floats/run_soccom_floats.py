"""
auto run soccom float simulation

Jinbo Wang
"""

import numpy as np
import os,sys

if __name__=='__main__':
    
    try:
        os.popen('cp %s parameter.py'%(sys.argv[1])
    except:
        sys.exit('use python run_soccom_floats.py your_parameter_file.txt')

    import parameter


