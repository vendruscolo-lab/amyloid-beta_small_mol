import numpy as np
import sys
import math

def get_rmsd(x, y):
    rmsd = (( x - y ) ** 2).sum()
    rmsd = np.sqrt( rmsd / float(len(x)) )
    return rmsd

# load triplet file
data = np.load(sys.argv[1])

# open output log file
log=open(sys.argv[2], "w")

# first and last frame
k0 = int(sys.argv[3])
k1 = int(sys.argv[4])

# number of frames
n = len(data)

# cycle on pairs and write on a separate file
for k in range(k0, k1):
    # map one-dimensional index to two-dimensional indexes 
    i = int(n - 2 - math.floor(math.sqrt(-8*k + 4*n*(n-1)-7)/2.0 - 0.5))
    j = int(k + i + 1 - n*(n-1)/2 + (n-i)*((n-i)-1)/2) 
    # get rmsd
    rmsd = get_rmsd(data[i], data[j]) 
    # print on file
    log.write("%6d %6d %6.3f\n" % (i, j, rmsd)) 

# close file
log.close()
