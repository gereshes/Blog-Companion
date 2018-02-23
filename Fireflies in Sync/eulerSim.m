% This code simulates the Kuramoto model using a foward Euler equation. It
% was written in conjunction with the document "Kuramoto model - Firefly Demo"
%
% Ari Rubinsztejn
% a.rubin1225@gmail.com
% www.gereshes.com
%%
close all
clear all
clc
%% Initialize items
k=.1; %A coupling factor
numFireFlies=7; %Number of oscillators
simFreq = 1 ; %Frequency in Hz
dt=1/simFreq;
t=0:dt:100;
theta=zeros(numFireFlies,length(t));
theta(:,1)=abs(2*pi*rand(numFireFlies,1));
dTheta=zeros(numFireFlies,1);
omega=20*ones(numFireFlies,1);%Set the frequency of the oscillators
y=zeros(size(theta));
%% Calculations
for c=2:length(t)
    dTheta=omega;
    for i=1:numFireFlies
        for j=1:numFireFlies
            dTheta(i)=dTheta(i)+((k/numFireFlies)*sin(theta(j,c-1)-theta(i,c-1))); %Genereate delta theta. Eqn 1
            
        end
    end
    theta(:,c)=theta(:,c-1)+(dTheta*dt); %Euler forward step
    c/length(t)
end

for c=1:length(t)
   y(:,c)=sin((5*t(c))+theta(:,c)); %Generate the y. Eqn 2
end


%% Plotting
figure()
for c=1:numFireFlies
 hold on
 plot(t,y(c,:))
end
ylabel('y')
xlabel('Time (s)')
title('Oscillators coming into sync')