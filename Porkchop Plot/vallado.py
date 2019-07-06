# -*- coding: utf-8 -*-

import numpy as np

def lambertUniversal(initPos,targetPos,deltaT,direction,mu):
    """
    An imlpementation of the lambert universal solver, Algorithem 58 in Vallado
    """
    
    initMag=np.linalg.norm(initPos)
    targetMag=np.linalg.norm(targetPos)
    
    cosDV=np.dot(initPos,targetPos)/(initMag*targetMag)
    sinDV=direction*np.sqrt(1-(cosDV*cosDV))
    
    A=direction*np.sqrt(initMag*targetMag*(1+cosDV))
    
    assert(np.abs(A) > 1e-5)
    
    psiN=0
    c2=.5
    c3=1/6
    psiUp=4.*np.pi*np.pi
    psiLow=-4.*np.pi
    run=True
    timeOut=False
    p=0
    maxItt=15
    while(run):
        yn=initMag+targetMag+(A*((psiN*c3)-1)/np.sqrt(c2))
        if((A>0.0)and(yn<0.0)):
            psiLow+=1.
        else:
            xn=np.sqrt(yn/c2)
            deltaTn=(((xn**3)*c3)+(A*np.sqrt(yn)))/np.sqrt(mu)
            if(deltaTn<deltaT):
                psiLow=psiN
            else:
                psiUp=psiN
        psiN1=(psiUp+psiLow)/2.
        c2,c3=findC2C3(psiN1)
        psiN=psiN1
        timeE=deltaTn-deltaT
        if(np.abs(timeE)<1e-6):
            run=False
        elif(p>maxItt):
            run=False
            timeout=True
        p+=1
    if(timeOut):
        v0Vec=np.array([np.nan,np.nan,np.nan])
        vVec=np.array([np.nan,np.nan,np.nan])
    else:
        f=1.0-(yn/initMag)
        gDot=1.0-(yn/targetMag)
        g=A*np.sqrt(yn/mu)
        
        v0Vec= (targetPos-(f*initPos))/g
        vVec=((gDot*targetPos)-initPos)/g
    return v0Vec,vVec,c3


def lambertTarget(initPos,targetPos,initVel,targetVel,deltaT,mu):
    direction=1
    v0Vec,vVec,c3=lambertUniversal(initPos,targetPos,deltaT,direction,mu)
    deltaVaVec=v0Vec-initVel
    deltaVbVec=targetVel-vVec
    return deltaVaVec,deltaVbVec,c3
    

    
def findC2C3(psi):
    """
    An omplementaiton of Algorithenm 1 in Vadello
    
    """
    if(psi>1e-6):
        c2=(1.-np.cos(np.sqrt(psi)))/psi
        c3=(np.sqrt(psi)-np.sin(np.sqrt(psi)))/np.sqrt((psi**3))
    elif(psi<1e-6):
        c2=(1.-np.cosh(np.sqrt(psi)))/psi
        c3=(np.sinh(np.sqrt(psi))-np.sqrt(psi))/np.sqrt((psi**3))
    else:
        c2=1./2.
        c3=1./6.
    return c2,c3