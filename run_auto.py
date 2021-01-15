#!/usr/bin/env python
# coding: utf-8

# import ngspicedata module
from ngspicedata import *
#from pylab import *
import matplotlib.pyplot as plt


# In[23]:


def replace_param(open_filex,processx,tempx):
    #print('...........Function_Started..........\n')
    with open(open_filex,'r') as spice_user:
        with open('simrun_test.sp','w') as spice_gen:
            for line in spice_user:
                if '$processx' in line:
                    line = line.replace("$processx",processx)
                if '$tempx' in line:
                    line = line.replace("$tempx",tempx)
                spice_gen.write(line)
    #print('..........Functon Closed ...........')
                


# In[25]:


# choose w_nmos values for parameter sweep
temp_vals = ['-40','25','125']
#proc_vals = ['nom','ff','ss']
proc_vals = ['nom','ff','ss']
# choose hspc sim file to modify
hspc_filename = 'test.hspc'
# create figure or clear existing one
#fig = figure(1)
#fig.clf()
color_vals = ['r','g','b']

# perform multiple ngspice simulations and plot results
count = 0
for process in proc_vals:
    for temp in temp_vals:
        print ('Process : ',process,' * Tempararture : ',temp,sep=' ')
        #CMD commands
        os.system('hspc netlist.ngsim simrun.sp test.hspc')
        replace_param('simrun.sp',process,temp)
        os.system('ngspice_con -b -r simrun.raw -o out.log simrun_test.sp')
        #Simrun Files Simulation
        data = NgspiceData('simrun.raw')
        x = data.evalsig('in')
        y= data.evalsig('out')
        plt.plot(x,y,color_vals[count])
        #plot(x,y)
    count = count + 1

        
# add grid and label plot axis
plt.xlabel('v(in)')
plt.ylabel('v(out)')
plt.grid(True)
plt.show()





