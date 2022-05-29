clear all, clc;

La = 0.658*10^-3;                   % Inductance
Va = 48;                            % Input Voltage
Ra = 1.76;                          % Resistance                                     
Kt = 68.3*10^-3;                    % Torque Constant
Ke = 68.3*10^-3;                    % Back EMF Constant
Jm  = 99.5*10^-2*10^-2*10^-3;       % Rotor Inertia 
Jg = 5 * 10^(-7);                   % Gear inertia
t = 3.76*10^-3;                     % Mechanical Time Constant
bm  = Jm/t;                         % Friction Coefficient(J/t) 
bg = Jg/t;                          % Gear Friction Coefficient
n = 81;                             % Gear Ratio
a = 0.72;                           % Gear Efficiency  

m_bar = 0;                      % [kg]
L_bar = 0.011;                        % [m]
H_bar = 0;                      % [m]
m_circle = 70;                   % [kg]
R_circle = 0.000001;                    % [m]
J_load ...                          % [kgm^2]
= m_bar*(L_bar^2 + 0.25*H_bar^2)/3 + 0.5*m_circle*R_circle^2 + m_circle*L_bar^2;
B_load = J_load/t;                  % Load's Friction Coefficient(J/t)

k = 1/a*(1/n)^2;

Jeq = Jm + k*Jg + k*J_load;         % Jeq
Beq = bm + k*bg + k*B_load;         % Jeq/tau;

% current controller
fcc = 200;
Wcc = fcc*2*pi;
Kp_cur = La * Wcc;
Ki_cur = Ra * Wcc;
Ka_cur = 1/Kp_cur;
i_rep = 25;
% speed controller
Wcs = Wcc / 10;
Kp_spd = 1.5042;
Ki_spd = 46.660104;
Ka_spd = 1/Kp_spd;
wm_rep = 5;
% position controller
Wcp = Wcs / 10;
Kp_pos = 4.5;
Kd_pos = 0.15;
deg_rep = 90;
%%
% out = sim('week4_2016741077_imseyeong_simul');
% x = out.simout.time;
% y = out.simout.signals.values;  
% 
% figure('units', 'pixels', 'pos',[100 100 700 300], 'Color', [1,1,1]);                         
% % Xmin = 0.0; XTick = 0.01; Xmax = 0.1;    % Xmin:X축 최소값parameter, XTick:X축 grid간격parameter, Xmax:X축 최대값parameter
% % Ymin =0; YTick = 0.000; Ymax = 1.5;         % Ymin:Y축 최소값parameter, YTick:Y축 grid간격parameter, Ymax:Y축 최대값parameter
% hold on;
% plot(x,y(:,1),'-k', 'LineWidth',2) ; 
% plot(x,y(:,2),'-r', 'LineWidth',2) ; 
% %plot(3/Wcp,deg_rep*0.95,"-o")
% %legend('Input deg','Output deg') %각 함수(그래프)에 대한 설명
% legend('limited speed','Output speed') %각 함수(그래프)에 대한 설명
%  grid on; %Grid on
% %          axis([Xmin Xmax Ymin Ymax])               % Graph 최대 최소 설정
% %          set(gca, 'XTick', [Xmin:XTick:Xmax]);     % X축 Grid 간격
% %          set(gca, 'YTick', [Ymin:YTick:Ymax]);     % Y축 Grid 간격
%      xlabel('time(s)',       'fontsize',20);       % X축 폰트20크기로 라벨링
%      ylabel('speed[rad/s]',     'fontsize',20);       % Y축 폰트20크기로 라벨링
%      title ('when degree = 90[deg]',   'fontsize',25);       % 폰트25 크기로 그래프 이름 설정