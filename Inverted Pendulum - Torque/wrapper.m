%invertedPendulumWrapper
close all
clear all
clc

time=12
fps=20
frames=time*fps

ic=[0,0];
thetaDes=pi;
ts=[0,12];
sol=ode45(@invertP,ts,ic);
t=linspace(ts(1),ts(2),frames);
y=deval(sol,t)';
plot(y(:,1))
hold on
plot(y(:,2))

h = figure;
h.Position=[1 356 1.2095e+03 479.5000];
h.Color=[1,1,1]
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'overSwing.gif';
for n = 1:frames
    % Draw plot for y = x.^n
    subplot(1,2,1)
    hold off
    plot([0,sin(y(n,1))],[0,-cos(y(n,1))])
    hold on
    scatter(sin(y(n,1)),-cos(y(n,1)),'filled')
    title('Pendulum')
    xlabel('X-Position')
    ylabel('Y-Position')

    daspect([1,1,1])
    axis([-1,1,-1,1])
    subplot(1,2,2)
    hold off
    
    plot(t(1:n),y(1:n,1),'DisplayName','Position')
    hold on
    plot(t(1:n),y(1:n,2),'DisplayName','Veolcity')
    title('States')
    axis([0,t(end),min([y(:,1);y(:,2)]),max([y(:,1);y(:,2)])])
    ylabel('Time (s)')
    legend
    sgtitle('Inverted Pendulum')
    drawnow
      % Capture the plot as an image 
      frame = getframe(h); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
      if n == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',1/fps); 
      end 
  end