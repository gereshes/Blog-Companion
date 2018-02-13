function [ stateDot ] = standSquat( time,states )
%ODE fucntion for calculating the update for pumping
%a swing while standing 
%
% Ari Rubinsztejn
% www.gereshes.com
L0=2.5;
g=9.8;
dL=.2;
if ((states(1)*states(2))>0)
    L=L0+dL;%Squat
else
    L=L0-dL;%Stand
end
phiDotDot=-g*L*sin(states(1))/(L*L);
stateDot = [states(2),phiDotDot]';
end

