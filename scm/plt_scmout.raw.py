##########################################################################################
##########################################################################################
import os,netCDF4,numpy as np
import matplotlib.pyplot as plt
from pylab import figure
clouds=0

if clouds == 1:
    fileREF   = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control/output_cloud.nc'
    file2Comp = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control_RRTMGP/output_cloud.nc'
if clouds == 0:
    fileREF   = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control/output.nc'
    file2Comp = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control_RRTMGP/output.nc'

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
ntime = len(time)

# Compute temporal mean of all profiles
mean_pres                    = np.sum(pres[:,:],axis=0)/ntime
mean_lw_rad_heating_rate_REF = np.sum(lw_rad_heating_rate_REF[:,:],axis=0)/ntime
mean_sw_rad_heating_rate_REF = np.sum(sw_rad_heating_rate_REF[:,:],axis=0)/ntime
mean_dT_dt_lwrad_REF         = np.sum(dT_dt_lwrad_REF[:,:],        axis=0)/ntime
mean_dT_dt_swrad_REF         = np.sum(dT_dt_swrad_REF[:,:],        axis=0)/ntime
mean_lw_rad_heating_rate     = np.sum(lw_rad_heating_rate[:,:],    axis=0)/ntime
mean_sw_rad_heating_rate     = np.sum(sw_rad_heating_rate[:,:],    axis=0)/ntime
mean_dT_dt_lwrad             = np.sum(dT_dt_lwrad[:,:],            axis=0)/ntime
mean_dT_dt_swrad             = np.sum(dT_dt_swrad[:,:],            axis=0)/ntime

# Loop over all time until we find a column with a cloud.
for itime in range(0,ntime):
    if (sum(cldcov_REF[itime,:,0] > 0)):
        time_of_first_cloud = itime
        #print cldcov_REF[itime,:,0],cldcov[itime,:,0]
        break
print time_of_first_cloud
# First time step in file either has cloud or not, so use that timestep
time_of_first_cloud=1

# Make plots
fig = figure(0, figsize=(14,10), dpi=80, facecolor='w', edgecolor='k')
#for itime in range(0,3):

cldlay = np.where(cldcov_REF[time_of_first_cloud-1,:,0] > 0)
for ip in range(0,len(mean_pres)):
    print pres[time_of_first_cloud-1,ip],cldcov[time_of_first_cloud-1,ip,0],sw_rad_heating_rate_REF[time_of_first_cloud,ip,0],sw_rad_heating_rate[time_of_first_cloud,ip,0]

# Plot heating-rate profiles
# 1) LW
plt.subplot(221)    
plt.plot(lw_rad_heating_rate_REF[time_of_first_cloud,:,0],pres[time_of_first_cloud,:]/100.,'-r')
plt.plot(lw_rad_heating_rate[time_of_first_cloud,:,0],    pres[time_of_first_cloud,:]/100.,'-b')
plt.scatter(lw_rad_heating_rate[time_of_first_cloud,cldlay,0],    pres[time_of_first_cloud,cldlay]/100., marker='o',)
plt.axis([-1e-4,1e-4,1000,0])
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('LW heating rate')
# 2) SW
plt.subplot(222)    
plt.plot(sw_rad_heating_rate_REF[time_of_first_cloud,:,0],pres[time_of_first_cloud,:]/100.,'-r')
plt.plot(sw_rad_heating_rate[time_of_first_cloud,:,0],    pres[time_of_first_cloud,:]/100.,'-b')
plt.scatter(sw_rad_heating_rate[time_of_first_cloud,cldlay,0],    pres[time_of_first_cloud,cldlay]/100., marker='o',)
plt.axis([-1e-4,1e-4,1000,0])
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('SW heating rate')
# 3) LW Difference
plt.subplot(223)    
plt.plot(lw_rad_heating_rate_REF[time_of_first_cloud,:,0] - lw_rad_heating_rate[time_of_first_cloud,:,0],
         pres[time_of_first_cloud,:]/100.,'-r')
plt.axis([-1e-4,1e-4,1000,0])
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title(' ')
# 4) SW Difference
plt.subplot(224)    
plt.plot(sw_rad_heating_rate_REF[time_of_first_cloud,:,0] - sw_rad_heating_rate[time_of_first_cloud,:,0],
         pres[time_of_first_cloud,:]/100.,'-r')
plt.axis([-1e-4,1e-4,1000,0])
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title(' ')

plt.show()
##########################################################################################
# END PROGRAM
##########################################################################################
