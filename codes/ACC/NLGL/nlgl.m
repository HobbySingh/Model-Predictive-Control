clc; clear all;
close all;

%% Initialization of params
% waypoints = [[0, 0, 0]; [600, 0, 100]; [600, 600, 100];[0,600,100]; [0, 0, 100]; [600,0,0]; [0,0,0]];
waypoints = [[0, 0, 100]; [600, 0, 150]; [600, 400, 150];[0,400,100]; [0, 800, 100]; [600,800,150]; [600,1200,150]; [0,1200,100]; [0,0,0]];

% ------------ intermediate variables o/p func--------------
global u_xy_arr;
u_xy_arr = [];
global u_z_arr;
u_z_arr = [];
global d_xy_arr;
d_xy_arr = [];
global d_z_arr;
d_z_arr = [];
global vtp;
vtp = [0,0,0];
global si_z_p;
si_z_p = 0;
% --------------------------------------------------

lw = 1;
tspan = 0:0.05:0.2;

% Straight Line Initial Condition

delta = 25;

d_xy_arr1 = [];
d_xy_arr2 = [];
d_xy_arr3 = [];

time_arr1 = [];
time_arr2 = [];
time_arr3 = [];

d_z_arr1 = [];
d_z_arr2 = [];
d_z_arr3 = [];

u_xy_arr1 = [];
u_xy_arr2 = [];
u_xy_arr3 = [];

u_z_arr1 = [];
u_z_arr2 = [];
u_z_arr3 = [];


%% Plotting Reference Trajectory
fprintf("Plotting trajectories\n");

%% -------------------- 0.2v winds ----------------------------
wp_1 = waypoints(1,:);
w1_x = wp_1(1); w1_y = wp_1(2); w1_z = wp_1(3);

wp_2 = waypoints(2,:);
w2_x = wp_2(1); w2_y = wp_2(2); w2_z = wp_2(3);

curr_x = 0;
curr_y = 0;
curr_si =0;
curr_d = 0;
curr_z = 100;
curr_si_z = 0;
curr_dz = 0;    
curr_integral_xy = 0;
curr_integral_z = 0;

curr_u_xy = 0;
curr_u_z = 0;
curr_d_xy = 0;
curr_d_z = 0;

last_time = 0;
dist_wp = sqrt((w2_x - curr_x)^2 + (w2_y - curr_y)^2 + (w2_z - curr_z)^2);

last_wp = 8;
wp = 2;
arrow_plot = 0;
while ( dist_wp > delta && wp <= last_wp)
    arrow_plot = arrow_plot + 1;
    w_spd_ratio = 0.3;
    y0 = [curr_x curr_y curr_si curr_z curr_si_z] ;
    options = odeset('OutputFcn',@(t,y,flag) sl_op_fx_nlgl(t,y,flag,w1_x,w1_y,w1_z,w2_x,w2_y,w2_z,w_spd_ratio,curr_u_xy,curr_u_z,curr_d_xy,curr_d_z));
    [t,y] = ode45(@(t,y) odeFuncSLine3d_NLGL(t,y,w1_x,w1_y,w1_z,w2_x,w2_y,w2_z,w_spd_ratio), tspan, y0, options);

    curr_x = y(end,1);
    curr_y = y(end,2);
    curr_si = y(end,3);
    curr_z = y(end,4);
    curr_si_z = y(end,5);    
    
    curr_u_xy = u_xy(end);
    curr_u_z = u_z(end);
    curr_d_xy = d_xy(end);
    curr_d_z = d_z(end);

    dist_wp = sqrt((w2_x - curr_x)^2 + (w2_y - curr_y)^2 + (w2_z - curr_z)^2);
    
    if(dist_wp < delta)
        fprintf("waypoint reached: %d \n", wp);
        wp_1 = waypoints(wp,:);
        w1_x = wp_1(1); w1_y = wp_1(2); w1_z = wp_1(3);

        wp_2 = waypoints(wp+1,:);
        w2_x = wp_2(1); w2_y = wp_2(2); w2_z = wp_2(3);
        
        pt = [curr_x,curr_y, 0];
        v1 = [w1_x w1_y 0];
        v2 = [w2_x w2_y 0];
        d = point_to_line(pt,v1,v2);

        pt = [curr_x,curr_y, curr_z];
        v1 = [w1_x w1_y w1_z];
        v2 = [w2_x w2_y w2_z];
        d_3d = point_to_line(pt,v1,v2);

        dz = sqrt((d_3d)^2 - d^2);
        dist_wp = sqrt((w2_x - curr_x)^2 + (w2_y - curr_y)^2 + (w2_z - curr_z)^2);
        wp = wp + 1;
        curr_si_z = y(end,5);
        curr_si = y(end,3);
    end    
    plot3(y(:,1),y(:,2),y(:,4),'-m','LineWidth',lw);
%     plot3(vtp(1),vtp(2),vtp(3),'-ko', 'LineWidth',lw);
%     plot(vtp(1),vtp(3),'r.', 'LineWidth',5);
%     plot(y(:,1),y(:,4),'-m','LineWidth',lw);
    hold on
    
    if(rem(arrow_plot,4) == 0)
        arrow_x = y(end,1);
        arrow_z = y(end,4);
        arrow_u = 25*cos(curr_si)*cos(curr_si_z);
        arrow_v = 25*sin(si_z_p);
        arrow_v2 = 25*sin(curr_si_z);
%         quiver(arrow_x,arrow_z,arrow_u,arrow_v,0,'Color','k');
%         quiver(arrow_x,arrow_z,arrow_u,arrow_v2,0,'Color','b');    
    end
    time_arr1 = [time_arr1;t(:,1) + last_time];

    last_time = last_time + t(end);
    
    if(wp <= last_wp)
        p1 = [waypoints(wp-1,1),waypoints(wp,1)];
        p2 = [waypoints(wp-1,2),waypoints(wp,2)];
        p3 = [waypoints(wp-1,3),waypoints(wp,3)];
        plot3(p1,p2,p3,'--k');
%         plot(p1,p3,'--k');
    end
    pause(0.1);
    grid on

end

u_xy_arr1 = u_xy_arr;
u_z_arr1 = u_z_arr;
u_xy_arr = [];
u_z_arr = [];

d_xy_arr1 = d_xy_arr;
d_z_arr1 = d_z_arr;
d_xy_arr = [];
d_z_arr = [];


%% ------------------------0.3 wind Plot---------------------------
wp_1 = waypoints(1,:);
w1_x = wp_1(1); w1_y = wp_1(2); w1_z = wp_1(3);

wp_2 = waypoints(2,:);
w2_x = wp_2(1); w2_y = wp_2(2); w2_z = wp_2(3);

curr_x = 0;
curr_y = 0;
curr_si =0;
curr_d = 0;
curr_z = 100;
curr_si_z = 0;
curr_dz = 0;    
curr_integral_xy = 0;
curr_integral_z = 0;

curr_u_xy = 0;
curr_u_z = 0;
curr_d_xy = 0;
curr_d_z = 0;

last_time = 0;
dist_wp = sqrt((w2_x - curr_x)^2 + (w2_y - curr_y)^2 + (w2_z - curr_z)^2);

last_wp = 8;
wp = 2;
while ( dist_wp > delta && wp <= last_wp)

    w_spd_ratio = 0.3;
    y0 = [curr_x curr_y curr_si curr_d curr_z curr_si_z curr_dz curr_integral_xy curr_integral_z] ;
    options = odeset('OutputFcn',@(t,y,flag) sl_op_fx_lqr_integral_state(t,y,flag,w1_x,w1_y,w1_z,w2_x,w2_y,w2_z,w_spd_ratio,curr_u_xy,curr_u_z,curr_d_xy,curr_d_z));
    [t,y] = ode45(@(t,y) odeFuncSLine3d_lqrIntegral(t,y,w1_x,w1_y,w1_z,w2_x,w2_y,w2_z,w_spd_ratio), tspan, y0, options);

    curr_x = y(end,1);
    curr_y = y(end,2);
    curr_si = y(end,3);
    curr_d = y(end,4);
    curr_z = y(end,5);
    curr_si_z = y(end,6);
    curr_dz = y(end,7);    

    curr_integral_xy = y(end,8);
    curr_integral_z = y(end,9);
    
    curr_u_xy = u_xy(end);
    curr_u_z = u_z(end);
    curr_d_xy = d_xy(end);
    curr_d_z = d_z(end);


    dist_wp = sqrt((w2_x - curr_x)^2 + (w2_y - curr_y)^2 + (w2_z - curr_z)^2);
    
    if(dist_wp < delta)
        fprintf("waypoint reached: %d \n", wp);
        wp_1 = waypoints(wp,:);
        w1_x = wp_1(1); w1_y = wp_1(2); w1_z = wp_1(3);

        wp_2 = waypoints(wp+1,:);
        w2_x = wp_2(1); w2_y = wp_2(2); w2_z = wp_2(3);
        
        pt = [curr_x,curr_y, 0];
        v1 = [w1_x w1_y 0];
        v2 = [w2_x w2_y 0];
        d = point_to_line(pt,v1,v2);

        pt = [curr_x,curr_y, curr_z];
        v1 = [w1_x w1_y w1_z];
        v2 = [w2_x w2_y w2_z];
        d_3d = point_to_line(pt,v1,v2);

        dz = sqrt((d_3d)^2 - d^2);
        dist_wp = sqrt((w2_x - curr_x)^2 + (w2_y - curr_y)^2 + (w2_z - curr_z)^2);
        wp = wp + 1;
        curr_si_z = y(end,6);
        curr_dz =  dz;
        curr_si = y(end,3);
        curr_d = d;
    end    
    plot3(y(:,1),y(:,2),y(:,5),'-b','LineWidth',lw);
%     hold on
    
    time_arr2 = [time_arr2;t(:,1) + last_time];

    last_time = last_time + t(end);
    
    if(wp <= last_wp)
        p1 = [waypoints(wp-1,1),waypoints(wp,1)];
        p2 = [waypoints(wp-1,2),waypoints(wp,2)];
        p3 = [waypoints(wp-1,3),waypoints(wp,3)];
        plot3(p1,p2,p3,'--k'); 
    end
    
    pause(0.1);
    grid on
end

u_xy_arr2 = u_xy_arr;
u_z_arr2 = u_z_arr;
u_xy_arr = [];
u_z_arr = [];

d_xy_arr2 = d_xy_arr;
d_z_arr2 = d_z_arr;
d_xy_arr = [];
d_z_arr = [];

u_xy_arr = [];
u_z_arr = [];

% d_xy_arr3 = d_xy_arr;
% d_z_arr3 = d_z_arr;
d_xy_arr = [];
d_z_arr = [];

figure
%% Error plot
subplot(2,1,1);

plot(time_arr1(:,1),d_xy_arr1(:,1),'-.m','LineWidth',lw);
hold on;
plot(time_arr2(:,1),d_xy_arr2(:,1),'--b','LineWidth',lw);
% plot(time_arr3(:,1),d_xy_arr3(:,1),'-r','LineWidth',lw);

grid on
xlabel('Time (s)') % x-axis label
ylabel('Cross Track Error : d_{xy}(m)') % y-axis label
title('(a)')
subplot(2,1,2);

plot(time_arr1(:,1),d_z_arr1(:,1),'-.m','LineWidth',lw);
hold on;
plot(time_arr2(:,1),d_z_arr2(:,1),'--b','LineWidth',lw);
% plot(time_arr3(:,1),d_z_arr3(:,1),'-r','LineWidth',lw);

grid on

% legend ('v_{w} = 0v','v_{w} = 0.2v','v_{w} = 0.4v','Location','northwest');
legend ('NLGL','LQR','Location','northwest');

xlabel('Time (s)') % x-axis label
ylabel('Altitude Error : d_{z}(m)') % y-axis label
title('(b)')
% ylim([-0.25 0.15])

%% CONTROL EFFORT PLOT

% u_xy_arr1 = u_xy_arr1.^2;
% u_xy_arr2 = u_xy_arr2.^2;
% u_xy_arr3 = u_xy_arr3.^2;
% u_z_arr1 = u_z_arr1.^2;
% u_z_arr2 = u_z_arr2.^2;
% u_z_arr3 = u_z_arr3.^2;

u_xy_arr1 = abs(u_xy_arr1);
u_xy_ce1 = sum(u_xy_arr1());

u_xy_arr2 = abs(u_xy_arr2);
u_xy_ce2 = sum(u_xy_arr2());

% u_xy_arr3 = abs(u_xy_arr3);
% u_xy_ce3 = sum(u_xy_arr3());

u_z_arr1 = abs(u_z_arr1);
u_z_ce1 = sum(u_z_arr1());

u_z_arr2 = abs(u_z_arr2);
u_z_ce2 = sum(u_z_arr2());

% u_z_arr3 = abs(u_z_arr3);
% u_z_ce3 = sum(u_z_arr3());

figure
subplot(2,1,1);

plot(time_arr1(:,1),u_xy_arr1(:,1),'-.m','LineWidth',lw);
hold on;
plot(time_arr2(:,1),u_xy_arr2(:,1),'--b','LineWidth',lw);
% plot(time_arr3(:,1),u_xy_arr3(:,1),'-r','LineWidth',lw);

grid on
xlabel('Time (s)') % x-axis label
ylabel('Control Effort : |u_{xy}| (m/sec^{2})') % y-axis label
title('(a)')
subplot(2,1,2);

plot(time_arr1(:,1),u_z_arr1(:,1),'-.m','LineWidth',lw);
hold on;
plot(time_arr2(:,1),u_z_arr2(:,1),'--b','LineWidth',lw);
% plot(time_arr3(:,1),u_z_arr3(:,1),'-r','LineWidth',lw);

grid on

legend ('NLGL','LQR','Location','northwest');

xlabel('Time (s)') % x-axis label
ylabel('Control Effort : |u_{z}| (m/sec^{2})') % y-axis label
title('(b)')
% ylim([-0.25 0.15])