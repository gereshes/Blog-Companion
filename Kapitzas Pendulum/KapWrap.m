close all
clear all
clc
%Script for visualizing the kapitza pendulum
% Ari Rubinsztejn
% www.gereshes.com


%% Simulating Kapitzas Pendulum
ts=[0,10];
ic=[pi*.75,1];

g=9.8;
a=.1;
nu=100;
l=1;
nu=70
args=[g,a,nu,l];

sol=ode45(@(t,x) kapitzasPendulum(t,x,args),ts,ic);

%% Visualizations
fps = 20;
time=5;
frames=fps*time;
opacity=.8;
t=linspace(0,ts(end),frames);
y=deval(sol,t)';
figure()
plot(t,y(:,1))
hold on
plot(ts,[pi,pi])

h = figure;
h.Color=[1,1,1];
h.Position=[3,297,678.500000000000,538];
%This chunk visualizes the pendulum's motion in space
%{
filename = 'kapPend.gif';
for n = 1:frames
    
    X=l*sin(y(n,1));
    Y=-l*cos(y(n,1))-a*cos(nu*t(n));
    ax1=subplot(2,1,1);
    %ax1.Position=[0.130000000000000,0.4,0.775000000000000,0.335765179216356];
    %ax1.Position=[0.13,0.43,0.775000000000000,0.5];
    ax1.Position=[0.13,0.5,0.775000000000000,0.4];
    plot([0,X],[-a*cos(nu*t(n)),Y])
    hold on
    plot([.5,.5],[-a*1.1,1.1*a],'b','LineWidth',7)
    plot([0,1],[-a*cos(nu*t(n)),0],'LineWidth',4)
    scatter([0,X],[-a*cos(nu*t(n)),Y],'r','filled')
    scatter(.5,-a*cos(nu*t(n))/2,'r','filled')
    daspect([1,1,1])
    axis([-1,1,-a*2,a+l+.2])
    %hold off
    ax2=subplot(2,1,2);
    %ax2.Position=[0.130000000000000,0.108259665827768,0.775000000000000,0.15];
    plot(t(1:n),pi-y(1:n,1));
    axis([0,ts(end),-1,1])
    ylabel('Error (Radians)')
    xlabel('Time (Seconds)')
    
    grid on
    hold off
    annotation(h,'textbox',[.03,.08 ,.1,0],'String','www.Gereshes.com','EdgeColor','none','FitBoxToText','on','FontSize',20,'Color',opacity*[1,1,1])
    
    drawnow
    sgtitle('Kapitza''s Pendulum')
    n/frames
    % Capture the plot as an image 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    if n == 1 
      imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else 
      imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime', 1/fps); 
    end 
end
%}

%This chunk visualizes the pendulums phase portrait
%{
%% Phase Portrait
entriesX=10;
entriesY=10;
xVec=linspace(-2*pi,2*pi,entriesX)
yVec=linspace(-2,2,entriesY)
fps = 15;
time=5;
frames=fps*time;
tSpan=linspace(0,2*pi/nu,frames);
holderYD=zeros(entriesY,entriesX);
holderC=cell(frames,1);
t=0;
figure()
hold on

z = figure;
z.Color=[1,1,1];
z.Position=[3,297,678.500000000000,538];
% this ensures that getframe() returns a consistent size

filename = 'kapPendPhase.gif';
for n=1:frames
    for c=1:entriesY
        for d=1:entriesX
            phi=xVec(d);
            phiD=yVec(c);
            phiDD=-1*(g+(a*nu*nu*cos(nu*tSpan(n))))*sin(phi)/l;
            %phiDD=phiDD-(1*phiD);
            %holderYD(c,d)=phiDD/492.2069;
            quiver(xVec(d),yVec(c),phiD/5,phiDD/(492.2069/2),'LineWidth',2)
            hold on
        end
        pctDone=(100*n/frames) + (c/(entriesY))
    end
    
    drawnow
    sgtitle('Kapitza''s Pendulum Phase space')
    axis([-2*pi*.99,.99*2*pi,-2,2])
    daspect([1,1,1])
    hold off
    %n/frames
    % Capture the plot as an image 
    frame = getframe(z); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    if n == 1 
      imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else 
      imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime', 1/fps); 
    end 
end
%}


%This chunk visualizes the potentail energy
theta=linspace(0,2*pi,100)
fps = 15;
time=10;
frames=fps*time;
tSpan=linspace(0,2*pi,frames);
m=1
nuHolder=linspace(0,90,frames);

figure()
hold on

z = figure;
z.Color=[1,1,1];
z.Position=[3,297,678.500000000000,538];
% this ensures that getframe() returns a consistent size

filename = 'kapPendEnergy.gif';
for n=1:frames
    nu=nuHolder(n);
    %peHolder=((l*cos(theta))+(a*sin(nu*tSpan(n))));
    peHolder=(-g*cos(theta)./l)+(a*a*nu*nu.*sin(theta).*sin(theta)./4);
    plot(theta,peHolder)
    n/frames;
    drawnow
    title(strcat('Kapitza''s Pendulum Effective Potential Energy \gamma=',num2str(nu),'','(Hz)'))
    axis([0,2*pi,-10,25])
    xlabel('Theta (Rad)')
    ylabel('Effective Potential Energy (J)')
    %daspect([1,1,1])
    hold off
    n/frames
    % Capture the plot as an image 
    frame = getframe(z); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    if n == 1 
      imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else 
      imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime', 1/fps); 
    end 
end
%}