%Pumping a swing while standing 
%
% Ari Rubinsztejn
% www.gereshes.com

close all
clear all
clc

%% Naive approach
  
%Pumping a swing while standing (Orig)
ic = [-.1,0];
timeEnd=10;
timespan = [0,timeEnd];
[tStand1,yStand1]=ode45( @standSquat,timespan,ic);


%Plotting
figure()
scatter(yStand1(:,1),yStand1(:,2))
set(groot,'defaulttextinterpreter','latex');  %Allows us to use full LaTeX
grid on
grid minor
ylabel('$\dot{\phi}$')
xlabel('$\phi$')
title('Standig Pump - Naive')


%% Using interrupts

%Initial conditions and setup. Mostly the same as before
ic = [-.1,0];
timeEnd=10;
lSquat=2.7
lStand=2.3;
timespan = [0,timeEnd+.0001];
tHolder=[0];
yHolder=ic;
options = odeset('Events',@theta0);%Breakout parameters

%Begin the integration 
while (tHolder(end)<timeEnd)
[tStand,yStand]=ode45( @standSquat,timespan,ic,options);
ic=yStand(end,:);
tHolder=[tHolder;tStand];
yHolder=[yHolder;yStand];
timespan=[tHolder(end),timeEnd+.0001];

%Add in the additional angular momentum from standing up
if(yHolder(end-2,1)*yHolder(end-2,2)<0)
    ic(2)=ic(2)*(lSquat/lStand)^2;
end

end

%Plotting
figure()

plot(yHolder(:,1),yHolder(:,2))
grid on
grid minor
ylabel('$\dot{\phi}$')
xlabel('$\phi$')
title('Standig Pump - Interupt')
yHolderStand=yHolder;


figure()
hold on
plot(yHolder(:,1),yHolder(:,2))
scatter(yStand1(:,1),yStand1(:,2))
grid on
grid minor
ylabel('$\dot{\phi}$')
xlabel('$\phi$')
title('Standig Pump - Overlay')
