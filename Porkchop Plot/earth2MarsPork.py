from jplephem.spk import SPK
import jdcal
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from scipy.integrate import odeint    
from vallado import *
'''
Dependancies

jdcal - https://anaconda.org/anaconda/jdcal
jplephem - https://anaconda.org/conda-forge/jplephem
'''

##try:
#    kernel.close()
#except:

    
kernel = SPK.open('de430.bsp')


def twoBodyDynamics(stateOld,t):
    x=stateOld[0]
    y=stateOld[1]
    z=stateOld[2]
    xDot=stateOld[3]
    yDot=stateOld[4]
    zDot=stateOld[5]
    r3=np.linalg.norm(stateOld[0:3])**3
    mu=132712440041.940
    xDotDot=-mu*x/r3
    yDotDot=-mu*y/r3
    zDotDot=-mu*z/r3
    statesDot=np.array([xDot,yDot,zDot,xDotDot,yDotDot,zDotDot])
    return statesDot

startYear=2018
startMonth=4
startDay=20

endYear=2018
endMonth=12
endDay=6


mu=132712440041.940
startJD=jdcal.gcal2jd(startYear,startMonth,startDay)
startJD=startJD[0]+startJD[1]
endJD=jdcal.gcal2jd(endYear,endMonth,endDay)
endJD=endJD[0]+endJD[1]
maxItt=200
span=100
timeArray=np.linspace(startJD,startJD+365.,span)

spread=360
startVec=np.linspace(startJD-spread,startJD+spread,span)
endVec=np.linspace(endJD-spread,endJD+spread,span)
#startVec=np.linspace(startJD-50,startJD+50,span)
#endVec=np.linspace(startJD+120.,startJD+400,span)
#jumpVec=np.linspace(100,365,span)
deltaVHolder=np.empty([span,span])
for c in range(span):
    for d in range(span):  
        t0=startVec[c]
        tf=endVec[d]
        #tf=t0+jumpVec[d]
        tof=(tf-t0)*24.*60.*60.
        xInit,vC=kernel[0,3].compute_and_differentiate(t0)#,1./(60.*60.*24.))
        vC*=1/(24.*60.*60.)
        
        xFinal,v2=kernel[0,4].compute_and_differentiate(tf)
        v2*=1/(24.*60.*60.)
        #v2=xf[3:6]
        deltaVa,deltaVb,c3 = lambertTarget(xInit,xFinal,vC,v2,tof,mu)
        deltaVHolder[c,d]=np.linalg.norm(vC+deltaVa)**2#+np.linalg.norm(deltaVb) #
        #deltaVHolder[c,d]=(np.linalg.norm(vC)+np.linalg.norm(deltaVa))#+np.linalg.norm(deltaVb) #
        #print(np.round(d/span))
    #print(np.round(c/span,3)*100)
    
    
    
    
ic=np.append(xInit,vC+deltaVa)
#ic=np.append(xInit,vC)
tSpan=np.linspace(0,tof,100)
tol=1e-11
yvec, info = odeint(twoBodyDynamics, ic, tSpan, full_output=True,rtol=tol,atol=tol)

   
fig1, ax1 = plt.subplots()

    
earthTraj=np.empty((1,3))
marsTraj =np.empty((1,3))
earthPeriod=365
marsPeriod=687
for c in range(earthPeriod+1):
    earthLoc = kernel[0,3].compute(t0+c+50)
    earthTraj=np.vstack((earthTraj,earthLoc))
earthTraj=earthTraj[1:-1,:]
for c in range(marsPeriod+1):
    marsLoc = kernel[0,4].compute(t0+c+50)
    marsTraj=np.vstack((marsTraj,marsLoc))
marsTraj=marsTraj[1:-1,:]




ax1.plot(earthTraj[:,0],earthTraj[:,1],'b',label='Earth Orbit')
ax1.plot(marsTraj[:,0],marsTraj[:,1],'r',label='Mars Orbit')
ax1.plot(yvec[:,0],yvec[:,1],label='Spacecraft Traj')


#ax1.scatter(yvec[1,0])
marsLocationContact,a = kernel[0,4].compute_and_differentiate(tf)
earthLocationStart,a = kernel[0,3].compute_and_differentiate(t0)



ax1.scatter(marsLocationContact[0],marsLocationContact[1],20,'r',label='Mars')
ax1.scatter(earthLocationStart[0] ,earthLocationStart[1],20,'b',label='Earth')
ax1.legend(loc='center left', bbox_to_anchor=(1, 0.5))
#print(flag)


fig2, ax2 = plt.subplots()
CS=ax2.contourf(startVec-startJD,endVec-startJD,deltaVHolder)
ax2.clabel(CS, fmt='%2.1f', colors='w', fontsize=14)
plt.xlabel('Launch Date')
plt.ylabel('Arrival Date')
