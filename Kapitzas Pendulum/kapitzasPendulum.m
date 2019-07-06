function [xDot] = kapitzasPendulum(t,x,args)
%State-Space form of Kapitza's pednulum EOM
%
% Ari Rubinsztejn
% www.gereshes.com

%Unpacking the states
phi=x(1);
phiD=x(2);

%Unpacking the arguemnts
g=args(1);
a=args(2);
nu=args(3);
l=args(4);


phiDD=-1*(g+(a*nu*nu*cos(nu*t)))*sin(phi)/l;%Equation of motion
phiDD=phiDD-(1*phiD); %Adding in a dampening term

xDot=[phiD,phiDD]';
end

