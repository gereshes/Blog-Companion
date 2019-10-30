function [statesDot] = invertP(t,states)
theta=states(1);
thetaDot=states(2);

%Hardcoded constants
g=-9.8;
l=1;
thetaD=pi;

torque=-(.6*thetaDot)+1*(thetaD-theta); %Calculate Torque

thetaDotDot=-(g*sin(theta)/l)+torque;

statesDot=[thetaDot;thetaDotDot];
end

