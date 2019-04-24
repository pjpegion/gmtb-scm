##########################################################################################
##########################################################################################
import os,netCDF4,numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
from pylab import figure
clouds=01

if clouds == 1:
    fileREF   = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control/output_cloud.nc'
    file2Comp = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control_RRTMGP/output_cloud.nc'
if clouds == 0:
    fileREF   = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control/output.nc'
    file2Comp = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control_RRTMGP/output.nc'

# Read in data
# RRTMG
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
# RRTMGP
dataNEW             = netCDF4.Dataset(file2Comp,'r')
lw_rad_heating_rate = dataNEW.variables['lw_rad_heating_rate'][:,:,:]
sw_rad_heating_rate = dataNEW.variables['sw_rad_heating_rate'][:,:,:]
dT_dt_lwrad         = dataNEW.variables['dT_dt_lwrad'][:,:,:]
dT_dt_swrad         = dataNEW.variables['dT_dt_swrad'][:,:,:]
cldcov              = dataNEW.variables['cldcov'][:,:,:]
ntime = len(time)
nlay = len(pres[0,:])

# Loop over all time until we find a column with a cloud.
#for itime in range(0,ntime):
#    if (sum(cldcov_REF[itime,:,0] > 0)):
#        time_of_first_cloud = itime
#        break
# First time step in file either has cloud or not, so use that timestep regardless.
time_of_first_cloud=1

# Which layers contain a cloud?
cldlay = np.where(cldcov_REF[time_of_first_cloud,:,0] > 0)

for ilev in range(0,nlay):
    print pres[0,ilev],sw_rad_heating_rate_REF[time_of_first_cloud,ilev,0],sw_rad_heating_rate[time_of_first_cloud,ilev,0]

############################################################################
# Make plots
fig = plt.figure(0, figsize=(10,14), dpi=80, facecolor='w', edgecolor='k')

# Plot heating-rate profiles
# 1) LW
plt.subplot(221)    
plt.plot(lw_rad_heating_rate_REF[time_of_first_cloud,:,0],pres[time_of_first_cloud,:]/100.,'-r')
plt.plot(lw_rad_heating_rate[time_of_first_cloud,:,0],    pres[time_of_first_cloud,:]/100.,'-b')
plt.scatter(lw_rad_heating_rate_REF[time_of_first_cloud,cldlay,0],    pres[time_of_first_cloud,cldlay]/100., marker='x',color='r')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.legend(('RRTMG', 'RRTMGP','Cloudy-layers'),loc='upper right')
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('LW heating rate')
# 2) SW
plt.subplot(222)    
plt.plot(sw_rad_heating_rate_REF[time_of_first_cloud,:,0],pres[time_of_first_cloud,:]/100.,'-r')
plt.plot(sw_rad_heating_rate[time_of_first_cloud,:,0],    pres[time_of_first_cloud,:]/100.,'-b')
plt.scatter(sw_rad_heating_rate_REF[time_of_first_cloud,cldlay,0],    pres[time_of_first_cloud,cldlay]/100., marker='x',color='r')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('SW heating rate')
# 3) LW Difference
plt.subplot(223)    
plt.plot(lw_rad_heating_rate_REF[time_of_first_cloud,:,0] - lw_rad_heating_rate[time_of_first_cloud,:,0],
         pres[time_of_first_cloud,:]/100.,'-k')
plt.plot(np.zeros(len(pres[0,:])),pres[time_of_first_cloud,:]/100.,color='lightgray',linestyle='dashed')
plt.scatter(lw_rad_heating_rate_REF[time_of_first_cloud,cldlay,0] - lw_rad_heating_rate[time_of_first_cloud,cldlay,0],
         pres[time_of_first_cloud,cldlay]/100.,marker='x',color='red')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title(' ')
# 4) SW Difference
plt.subplot(224)    
plt.plot(sw_rad_heating_rate_REF[time_of_first_cloud,:,0] - sw_rad_heating_rate[time_of_first_cloud,:,0],
         pres[time_of_first_cloud,:]/100.,'-k')
plt.plot(np.zeros(len(pres[0,:])),pres[time_of_first_cloud,:]/100.,color='lightgray',linestyle='dashed')
plt.scatter(sw_rad_heating_rate_REF[time_of_first_cloud,cldlay,0] - sw_rad_heating_rate[time_of_first_cloud,cldlay,0],
         pres[time_of_first_cloud,cldlay]/100.,marker='x',color='red')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.ylabel('Pressure (hPa)')
plt.xticks(rotation=45)
plt.xlabel('(K/s)')
plt.title(' ')

plt.show()
##########################################################################################
# END PROGRAM
##########################################################################################
