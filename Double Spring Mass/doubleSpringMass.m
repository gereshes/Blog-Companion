function [xDot] = doubleSpringMass(t,X,args)
%State space fucntion of Double Spring Mass System
%Made for https://gereshes.com/2019/01/07/double-spring-mass-systems-matlabs-ode-45
%Ari Rubinsztejn
%2018.12.22

%Unpacking the variables
x1=X(1);
x2=X(2);
k1=args(1);
m1=args(2);
k2=args(3);
m2=args(4);

%Calculating Forces
F1=(-k1*x1)+(k2*(x2-x1));
F2=(-k2*x2)+(k2*x1);

%Newtons Second law
x1DD=F1/m1;
x2DD=F2/m2;

%Restructuring as a vector
xDot=[X(3),X(4),x1DD,x2DD]';
end

