function fireflyODEMain
%Main function for simulating fireflies using ODE45
%
% Ari Rubinsztejn
% a.rubin1225@gmail.com
% www.gereshes.com

close all
clear all
clc

%Set vars
K=.25;  %Coupling
N=10;   %Number of fireflies
omega=1;%Frequency of fireflies flashing 
tEnd=40;%End time of simulation

%Initialize
init = 2*pi*rand(N,1);
params=[K,N,omega];
tSpan = [0,tEnd];
sol=ode45(@(t,states) fireflyODEFun(t,states,params),tSpan,init)%Simulate

%Plotting
t=0:.1:tEnd;
y=deval(sol,t)';
for c=1:N
    hold on
plot(t,y(:,c));
end
title('Phase shift over time')
ylabel('Phase shift')
xlabel('Time (Seconds)')
grid on
grid minor
figure()
for c=1:N
hold on
plot(t,sin(t'+y(:,c)));
end
grid on
grid minor
title('Firefly signal')
ylabel('Signal strength')
xlabel('Time (Seconds)')



function [dotStates] = fireflyODEFun(t,states,params)
%ODE function for imulating fireflies
K=params(1);
N=params(2);
kn=K/N;
omega=params(3);
dotStates=states;
for i=1:N,
    dotStates(i) = 0;
    for j=1:N,
        dotStates(i) =  dotStates(i) +omega+ (kn*sin(states(j)-states(i)));
    end
end
