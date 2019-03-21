##########################################################################################
##########################################################################################
import os,netCDF4,numpy as np
import matplotlib.pyplot as plt
from pylab import figure

fileREF   = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control/output.rrtmg.nc'
file2Comp = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control/output.rrtmgp0.nc'

# Read in data
# Reference
dataREF                 = netCDF4.Dataset(fileREF,'r')
time                    = dataREF.variables['time'][:]
pres                    = dataREF.variables['pres'][:,:,:]
pres_i                  = dataREF.variables['pres_i'][:,:,:]
sigma                   = dataREF.variables['sigma'][:,:,:]
sigma_i                 = dataREF.variables['sigma_i'][:,:,:]
cldcov_REF              = dataREF.variables['cldcov'][:,:,:]
lw_rad_heating_rate_REF = dataREF.variables['lw_rad_heating_rate'][:,:,:]
sw_rad_heating_rate_REF = dataREF.variables['sw_rad_heating_rate'][:,:,:]
dT_dt_lwrad_REF         = dataREF.variables['dT_dt_lwrad'][:,:,:]
dT_dt_swrad_REF         = dataREF.variables['dT_dt_swrad'][:,:,:]
#
dataNEW             = netCDF4.Dataset(file2Comp,'r')
lw_rad_heating_rate = dataNEW.variables['lw_rad_heating_rate'][:,:,:]
sw_rad_heating_rate = dataNEW.variables['sw_rad_heating_rate'][:,:,:]
dT_dt_lwrad         = dataNEW.variables['dT_dt_lwrad'][:,:,:]
dT_dt_swrad         = dataNEW.variables['dT_dt_swrad'][:,:,:]
cldcov              = dataNEW.variables['cldcov'][:,:,:]

# Compute temporal mean of all profiles
mean_pres                    = np.sum(pres[:,:],axis=0)/len(time)
mean_lw_rad_heating_rate_REF = np.sum(lw_rad_heating_rate_REF[:,:],axis=0)/len(time)
mean_sw_rad_heating_rate_REF = np.sum(sw_rad_heating_rate_REF[:,:],axis=0)/len(time)
mean_dT_dt_lwrad_REF         = np.sum(dT_dt_lwrad_REF[:,:],        axis=0)/len(time)
mean_dT_dt_swrad_REF         = np.sum(dT_dt_swrad_REF[:,:],        axis=0)/len(time)
mean_lw_rad_heating_rate     = np.sum(lw_rad_heating_rate[:,:],    axis=0)/len(time)
mean_sw_rad_heating_rate     = np.sum(sw_rad_heating_rate[:,:],    axis=0)/len(time)
mean_dT_dt_lwrad             = np.sum(dT_dt_lwrad[:,:],            axis=0)/len(time)
mean_dT_dt_swrad             = np.sum(dT_dt_swrad[:,:],            axis=0)/len(time)

# Make plots
fig = figure(0, figsize=(12,12), dpi=80, facecolor='w', edgecolor='k')
#
plt.subplot(231)
plt.plot(mean_lw_rad_heating_rate_REF,mean_pres/100.,'-r')
plt.plot(mean_lw_rad_heating_rate,    mean_pres/100.,'-b')
plt.axis([-1e-4,1e-4,1000,0])
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('LW heating rate')
plt.subplot(232)
plt.plot(mean_lw_rad_heating_rate_REF-mean_lw_rad_heating_rate,mean_pres/100.,'-r')
plt.axis([-1e-4,1e-4,1000,0])
plt.xlabel('(K/s)')
plt.title('Absolute Difference')
plt.subplot(233)
plt.plot(100.*(1-mean_lw_rad_heating_rate_REF/mean_lw_rad_heating_rate),mean_pres/100.,'-r')
plt.axis([-20,20,1000,0])
plt.xlabel('(%)')
plt.title('Relative Difference')
#
plt.subplot(234)
plt.plot(mean_sw_rad_heating_rate_REF,mean_pres/100.,'-r')
plt.plot(mean_sw_rad_heating_rate,    mean_pres/100.,'-b')
plt.axis([-1e-4,1e-4,1000,0])
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('SW heating rate')
plt.subplot(235)
plt.plot(mean_sw_rad_heating_rate_REF-mean_sw_rad_heating_rate,mean_pres/100.,'-r')
plt.axis([-1e-4,1e-4,1000,0])
plt.xlabel('(K/s)')
plt.title('Absolute Difference')
#plt.subplot(236)
#plt.plot(100.*(1-mean_sw_rad_heating_rate_REF/mean_sw_rad_heating_rate),mean_pres/100.,'-r')
#plt.axis([-20,20,1000,0])
#plt.xlabel('(%)')
#plt.title('Relative Difference')


plt.show()
##########################################################################################
# END PROGRAM
##########################################################################################
