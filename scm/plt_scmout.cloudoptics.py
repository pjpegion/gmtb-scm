##########################################################################################
##########################################################################################

import os,netCDF4,numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
from pylab import figure

fileREF    = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control/output_cloud.nc'
file2Comp0 = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control_RRTMGP/output_cloud.lw_cld_phys0.nc'
file2Comp1 = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control_RRTMGP/output_cloud.lw_cld_phys1.nc'
file2Comp2 = '/home/dswales/Projects/CCPPdev/gmtb-scm/scm/bin/output_twpice_control_RRTMGP/output_cloud.lw_cld_phys2.nc'

# Read in data
# RRTMG
dataREF    = netCDF4.Dataset(fileREF,'r')
time       = dataREF.variables['time'][:]
pres       = dataREF.variables['pres'][:,:,:]
pres_i     = dataREF.variables['pres_i'][:,:,:]
sigma      = dataREF.variables['sigma'][:,:,:]
sigma_i    = dataREF.variables['sigma_i'][:,:,:]
cldcov_REF = dataREF.variables['cldcov'][:,:,:]
lwrad_REF  = dataREF.variables['lw_rad_heating_rate'][:,:,:]
swrad_REF  = dataREF.variables['sw_rad_heating_rate'][:,:,:]
#
# RRTMGP
# 1) RRTMGP using RRTMG cloud optics
data0   = netCDF4.Dataset(file2Comp0,'r')
lwrad0  = data0.variables['lw_rad_heating_rate'][:,:,:]
swrad0  = data0.variables['sw_rad_heating_rate'][:,:,:]
cldcov0 = data0.variables['cldcov'][:,:,:]
# 2) RRTMGP using RRTMGP LUT for cloud optics
data1   = netCDF4.Dataset(file2Comp1,'r')
lwrad1  = data1.variables['lw_rad_heating_rate'][:,:,:]
swrad1  = data1.variables['sw_rad_heating_rate'][:,:,:]
cldcov1 = data1.variables['cldcov'][:,:,:]
# 1) RRTMGP using RRTMGP
data2   = netCDF4.Dataset(file2Comp2,'r')
lwrad2  = data2.variables['lw_rad_heating_rate'][:,:,:]
swrad2  = data2.variables['sw_rad_heating_rate'][:,:,:]
cldcov2 = data2.variables['cldcov'][:,:,:]

ntime  = len(time)
nlay   = len(pres[0,:])

ti=1

# Which layers contain a cloud?
cldlay = np.where(cldcov_REF[ti,:,0] > 0)

############################################################################
# Make plots
fig = plt.figure(0, figsize=(16,10), dpi=80, facecolor='w', edgecolor='k')

# Plot heating-rate profiles
# 1) LW (RRTMG)
plt.subplot(2,6,1)    
plt.plot(lwrad_REF[ti,:,0],pres[ti,:]/100.,'-r')
plt.plot(lwrad0[ti,:,0],    pres[ti,:]/100.,'-b')
plt.scatter(lwrad_REF[ti,cldlay,0],    pres[ti,cldlay]/100., marker='x',color='r')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.legend(('RRTMG', 'RRTMGP','Cloudy-layers'),loc='upper right')
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('LW dT/dt (RRTMG)')
#
# 2) LW (LUT)
plt.subplot(2,6,2) 
plt.plot(lwrad_REF[ti,:,0],pres[ti,:]/100.,'-r')
plt.plot(lwrad1[ti,:,0],    pres[ti,:]/100.,'-b')
plt.scatter(lwrad_REF[ti,cldlay,0],    pres[ti,cldlay]/100., marker='x',color='r')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('LW dT/dt (LUT)')

#
# 3) LW (PADE)
plt.subplot(2,6,3)    
plt.plot(lwrad_REF[ti,:,0],pres[ti,:]/100.,'-r')
plt.plot(lwrad2[ti,:,0],    pres[ti,:]/100.,'-b')
plt.scatter(lwrad_REF[ti,cldlay,0],    pres[ti,cldlay]/100., marker='x',color='r')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('LW dT/dt (PADE)')
#
# 4) SW (RRTMG)
plt.subplot(2,6,4)    
plt.plot(swrad_REF[ti,:,0],pres[ti,:]/100.,'-r')
plt.plot(swrad0[ti,:,0],    pres[ti,:]/100.,'-b')
plt.scatter(swrad_REF[ti,cldlay,0],    pres[ti,cldlay]/100., marker='x',color='r')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('SW dT/dt (RRTMG)')
#
# 5) SW (LUT)
plt.subplot(2,6,5) 
plt.plot(swrad_REF[ti,:,0],pres[ti,:]/100.,'-r')
plt.plot(swrad1[ti,:,0],    pres[ti,:]/100.,'-b')
plt.scatter(swrad_REF[ti,cldlay,0],    pres[ti,cldlay]/100., marker='x',color='r')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('SW dT/dt (LUT)')
#
# 6) SW (PADE)
plt.subplot(2,6,6)    
plt.plot(swrad_REF[ti,:,0],pres[ti,:]/100.,'-r')
plt.plot(swrad2[ti,:,0],    pres[ti,:]/100.,'-b')
plt.scatter(swrad_REF[ti,cldlay,0],    pres[ti,cldlay]/100., marker='x',color='r')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title('SW dT/dt (PADE)')
#
#) 7 Difference (RRTMG-RRTMGP) RRTMG cloud optics
plt.subplot(2,6,7)    
plt.plot(lwrad_REF[ti,:,0] - lwrad0[ti,:,0],
         pres[ti,:]/100.,'-k')
plt.plot(np.zeros(len(pres[0,:])),pres[ti,:]/100.,color='lightgray',linestyle='dashed')
plt.scatter(lwrad_REF[ti,cldlay,0] - lwrad0[ti,cldlay,0],
         pres[ti,cldlay]/100.,marker='x',color='red')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title(' ')
#
#) 8 Difference (RRTMG-RRTMGP) RRTMGP LUT
plt.subplot(2,6,8)    
plt.plot(lwrad_REF[ti,:,0] - lwrad1[ti,:,0],
         pres[ti,:]/100.,'-k')
plt.plot(np.zeros(len(pres[0,:])),pres[ti,:]/100.,color='lightgray',linestyle='dashed')
plt.scatter(lwrad_REF[ti,cldlay,0] - lwrad1[ti,cldlay,0],
         pres[ti,cldlay]/100.,marker='x',color='red')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title(' ')
#
#) 9 Difference (RRTMG-RRTMGP) RRTMGP PADE
plt.subplot(2,6,9)    
plt.plot(lwrad_REF[ti,:,0] - lwrad2[ti,:,0],
         pres[ti,:]/100.,'-k')
plt.plot(np.zeros(len(pres[0,:])),pres[ti,:]/100.,color='lightgray',linestyle='dashed')
plt.scatter(lwrad_REF[ti,cldlay,0] - lwrad2[ti,cldlay,0],
         pres[ti,cldlay]/100.,marker='x',color='red')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title(' ')
#
#
#
#
#
#
#) 10 Difference (RRTMG-RRTMGP) RRTMG cloud optics
plt.subplot(2,6,10)    
plt.plot(swrad_REF[ti,:,0] - swrad0[ti,:,0],
         pres[ti,:]/100.,'-k')
plt.plot(np.zeros(len(pres[0,:])),pres[ti,:]/100.,color='lightgray',linestyle='dashed')
plt.scatter(swrad_REF[ti,cldlay,0] - swrad0[ti,cldlay,0],
         pres[ti,cldlay]/100.,marker='x',color='red')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title(' ')
#
#) 11 Difference (RRTMG-RRTMGP) RRTMGP LUT
plt.subplot(2,6,11)    
plt.plot(swrad_REF[ti,:,0] - swrad1[ti,:,0],
         pres[ti,:]/100.,'-k')
plt.plot(np.zeros(len(pres[0,:])),pres[ti,:]/100.,color='lightgray',linestyle='dashed')
plt.scatter(swrad_REF[ti,cldlay,0] - swrad1[ti,cldlay,0],
         pres[ti,cldlay]/100.,marker='x',color='red')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title(' ')
#
#) 12 Difference (RRTMG-RRTMGP) RRTMGP PADE
plt.subplot(2,6,12)    
plt.plot(swrad_REF[ti,:,0] - swrad2[ti,:,0],
         pres[ti,:]/100.,'-k')
plt.plot(np.zeros(len(pres[0,:])),pres[ti,:]/100.,color='lightgray',linestyle='dashed')
plt.scatter(swrad_REF[ti,cldlay,0] - swrad2[ti,cldlay,0],
         pres[ti,cldlay]/100.,marker='x',color='red')
plt.axis([-1e-4,1e-4,1000,0])
ax = plt.gca()
ax.xaxis.set_major_formatter(mtick.FormatStrFormatter('%.1e'))
plt.xticks(rotation=45)
plt.ylabel('Pressure (hPa)')
plt.xlabel('(K/s)')
plt.title(' ')

plt.show()
##########################################################################################
# END PROGRAM
##########################################################################################
