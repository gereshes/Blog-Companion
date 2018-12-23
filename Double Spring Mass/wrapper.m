close all
clear all
clc

%% Numerical Simualtion

ic = [-1,3,0,0]; % Initial Conditions
args=[4,1,4,1];  % [K1,M1,K2,M2]
ts=[0,33];       % Initial and final time
sol=ode45(@(t,X) doubleSpringMass(t,X,args),ts,ic); %Calling ODE45


%% GIF Creation
fps=20  %Speed of Gif
time=25 %Length of Gif
frames = fps*time*4;
t=linspace(ts(1),ts(end),frames);
y=deval(sol,t)'; %
h=.5; %Size of box
hMain=figure()
set(hMain,'color','w')
ne = 10; a = 1; ro = 0.1;
filename = 'C:\Ari\Gereshes\Content\Dynamics\Spring mass system\SpringMassSystem.gif';
for n=1:4:frames
    
    % Draws the image
    h1=subplot(2,1,1);
    h1.Position=[  0.075    0.7544    .85    0.1706];
    [xs1 ys1] = spring(0,0,y(n,1),0,ne,a,ro);
    [xs2 ys2] = spring(y(n,1),0,y(n,2),0,ne,a,ro);
    plot(xs1,ys1,'b','LineWidth',2)
    hold on
    plot(xs2,ys2,'r','LineWidth',2)
    r1=rectangle('Position',[y(n,1)-h,-h,2*h,2*h],'FaceColor','b');

    r2=rectangle('Position',[y(n,2)-h,-h,2*h,2*h],'FaceColor','r');
    hold off
    axis([min([y(:,1);y(:,2)])-2*h,max([y(:,1);y(:,2)])+2*h,-0.75,0.75])
    daspect([1,1,1])
    h2=subplot(2,1,2);
    h2.Position = [0.077    0.13    .848    0.55];
    plot(y(1:n,1),y(1:n,2),'LineWidth',2)
    xlabel('d_1')
    ylabel('d_2')
    axis([min(y(:,1)),max(y(:,1)),min(y(:,2)),max(y(:,2))]);
    %daspect([1,1,1])
    sgtitle('Double Spring Mass System')
    drawnow

    % Capture the plot as an image 
    frame = getframe(hMain); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    if n == 1 
      imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else 
      imwrite(imind,cm,filename,'gif','WriteMode','append', 'DelayTime', 1/fps); 
    end 
      
      
    delete(r1)
    delete(r2)
end