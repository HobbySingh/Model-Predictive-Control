clc; close all; clear all;

w1_x = 0; w1_y = 0;
w2_x = 6000; w2_y = 6000;

lw = 1;
tspan = 0:0.1:50;

% Straight Line Initial Condition
y0 = [0 0 0.754 0];

y1 = [0 0 0.754];

% odeFuncSLine
[t,y] = ode45(@(t,y) odeFuncSLineWind(t,y,0.2), tspan, y0);
[t1,y1] = ode45(@(t,y) NLGL_Line(t,y,w1_x,w1_y,w2_x,w2_y), tspan, y1);
% [t2,y2] = ode45(@(t,y) odeFuncSLineWind(t,y,0.35), tspan, y0);
% [t3,y3] = ode45(@(t,y) odeFuncSLineWind(t,y,0.45), tspan, y0);


%% Trajectory Plots
% Line Trajectory
arr_x = (0:1:300);
arr_y = (0:1:300);

plot(arr_x(1,:),arr_y(1,:),'--k'); 

hold on
grid on
for i = 1:length(y(:,1))-1
    plot(y(i:i+1,1),y(i:i+1,2),'-m','LineWidth',lw);
    plot(y1(i:i+1,1),y1(i:i+1,2),'-b','LineWidth',lw);
%     plot(y2(i:i+1,1),y2(i:i+1,2),'b','LineWidth',lw);
    
    pause(0.01)
end

legend ('Path','AOGL with wind','NLGL with wind','Location','northwest');
xlabel('X(m)') % x-axis label
ylabel('Y(m)') % y-axis label

%% multiple wind plots line
% d_arr = [];  
% for i = 1:length(y1(:,1))
%     pt = [y1(i,1),y1(i,2), 0];
%     v1 = [w1_x w1_y,0];
%     v2 = [w2_x w2_y,0];
%     d = point_to_line(pt,v1,v2);
%     d_arr = [d_arr,d];
% end
% 
% d_arr2 = [];  
% for i = 1:length(y2(:,1))
%     pt = [y2(i,1),y2(i,2), 0];
%     v1 = [w1_x w1_y,0];
%     v2 = [w2_x w2_y,0];
%     d = point_to_line(pt,v1,v2);
%     d_arr2 = [d_arr2,d];
% end
% 
% d_arr3 = [];  
% for i = 1:length(y3(:,1))
%     pt = [y3(i,1),y3(i,2), 0];
%     v1 = [w1_x w1_y,0];
%     v2 = [w2_x w2_y,0];
%     d = point_to_line(pt,v1,v2);
%     d_arr3 = [d_arr3,d];
% end
% 
% figure
% hold on
% plot(t1(:,1),d_arr(1,:),'b','LineWidth',lw);
% plot(t2(:,1),d_arr2(1,:),'m','LineWidth',lw);
% plot(t3(:,1),d_arr3(1,:),'k','LineWidth',lw);
% % ylim([-5,12])
% grid on
% xlabel('Time(sec)') % x-axis label
% ylabel('Position Error: d(m)') % y-axis label
% legend ('vw = 0.25','vw = 0.35','vw = 0.45');
