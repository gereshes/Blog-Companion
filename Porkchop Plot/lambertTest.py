# -*- coding: utf-8 -*-
from jplephem.spk import SPK
import jdcal
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
    
mu=398600.4418
tof=30.*60.
x0 = np.array([6045,3490,0])
vC=np.array([-2.457,6.618,2.533])
x1=np.array([12214.839, 10249.467, 2000])
v1=np.array([-3.448, .924, 0])
vf=[.52, .8414, .1451]
r2=12282.
#v2=xf[3:6]
C= 7080.
S=(C+np.linalg.norm(x0[0:3])+(r2))/2
tMin=np.sqrt(2)*np.sqrt((S**3.)/mu)*(1-(((S-C)/S)**(3./2.)))/3.
aMin=S/2.0
aMax=S*2.0
alphaMax= 2.*np.arcsin(np.sqrt(S/(2.0*aMin)))
betaMax = 2.*np.arcsin(np.sqrt((S-C)/(2.0*aMin)))
tMax=np.sqrt((aMin**3)/mu)*(alphaMax-betaMax-(np.sin(alphaMax)-np.sin(betaMax)))
tol=60
p=0
while(error>tol and p<maxItt):
    a= (aMin+aMax)/2.0
    alpha= 2.*np.arcsin(np.sqrt(S/(2.*a)))
    beta=2.*np.arcsin(np.sqrt((S-C)/(2.*a)))
    deltaT=np.sqrt((a**3)/mu)*(alpha-beta-(np.sin(alpha)-np.sin(beta)))
    error=tof-deltaT
    if(error<0):
        aMin=a
        #aMax=a
    else:
        aMax=a
        #aMin=a
        
    p+=1
    #p+=-1
    error=np.abs(error)
    #print(error)
if(p>=maxItt):
    print('Stuck')
    z=1
else:
    u1=x0/np.linalg.norm(x0) #base vector from IC pos
    u2=                         #unit vec from rondevous pos
    uc=                     #(rF-r0)/c
    
    A=np.sqrt(mu/(4.0*a))*(1/np.tan(alpha/2))
    B=np.sqrt(mu/(4.0*a))*(1/np.tan(beta/2))
    v0=((B+A)*vC)+((B-A)*v1)
    vf=((B+A)*vC)-((B-A)*v2)
    deltaVec=v0-vf
    deltaV=np.linalg.norm(deltaVec)
    deltaVMat[c,d]=deltaV