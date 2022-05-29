clear all, clc   

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

k = 1/a*(1/n)^2;

Jeq = Jm + k*Jg;                    % Jeq
Beq = bm + k*bg;                    % Jeq/tau;

m_bar = 0.175;                      % [kg]
L_bar = 0.3;                        % [m]
H_bar = 0.025;                      % [m]
m_circle = 0.340;                   % [kg]
R_circle = 0.05;                    % [m]
J_load ...                       % [kgm^2]
= m_bar*(L_bar^2 + 0.25*H_bar^2)/3 + 0.5*m_circle*R_circle^2 + m_circle*L_bar^2;
B_load = J_load/t;                % Load's Friction Coefficient(J/t)

%%
out = sim('week3_2016741077_imseyeong_simul');
x = out.simout1.time;
y1 = out.simout1.signals.values;        % simout voltage = 48[v], Non Geared, Non Load
y2 = out.simout2.signals.values;        % simout voltage = 48[v], Geared, Non Load
y3 = out.simout3.signals.values;        % simout voltage = 48[v], Geared, Load

%%
figure('units', 'pixels', 'pos',[100 100 300 600], 'Color', [1,1,1]);  % figure창 생성(측정단위(default),창 위치와 크기, 색(white))
%Time-Domain
subplot(3,1,1)                              
Xmin = 0.0; XTick = 0.01; Xmax = 0.1;    % Xmin:X축 최소값parameter, XTick:X축 grid간격parameter, Xmax:X축 최대값parameter
Ymin =0; YTick = 2; Ymax = 25;         % Ymin:Y축 최소값parameter, YTick:Y축 grid간격parameter, Ymax:Y축 최대값parameter
hold on;
plot(x,y1(:,1),'-r', 'LineWidth',2) ; 
plot(x,y2(:,1),'ob', 'LineWidth',2) ; 
legend('Non Geared','Geared') %각 함수(그래프)에 대한 설명
 grid on; %Grid on
         axis([Xmin Xmax Ymin Ymax])               % Graph 최대 최소 설정
         set(gca, 'XTick', [Xmin:XTick:Xmax]);     % X축 Grid 간격
         set(gca, 'YTick', [Ymin:YTick:Ymax]);     % Y축 Grid 간격
     xlabel('time(s)',       'fontsize',20);       % X축 폰트20크기로 라벨링
     ylabel('Current[A]',     'fontsize',20);       % Y축 폰트20크기로 라벨링
     title ('Current',   'fontsize',25);       % 폰트25 크기로 그래프 이름 설정

subplot(3,1,2)                              
Xmin = 0.0; XTick = 0.01; Xmax = 0.1;    % Xmin:X축 최소값parameter, XTick:X축 grid간격parameter, Xmax:X축 최대값parameter
Ymin =0; YTick = 500; Ymax = 3500;         % Ymin:Y축 최소값parameter, YTick:Y축 grid간격parameter, Ymax:Y축 최대값parameter
hold on
plot(x,y1(:,2),'-r', 'LineWidth',2) ; 
plot(x,y2(:,2),'-b', 'LineWidth',2) ; 

legend('Non Geared','Geared') %각 함수(그래프)에 대한 설명
 grid on; %Grid on
         axis([Xmin Xmax Ymin Ymax])               % Graph 최대 최소 설정
         set(gca, 'XTick', [Xmin:XTick:Xmax]);     % X축 Grid 간격
         set(gca, 'YTick', [Ymin:YTick:Ymax]);     % Y축 Grid 간격
     xlabel('time(s)',       'fontsize',20);       % X축 폰트20크기로 라벨링
     ylabel('RPM',     'fontsize',20);       % Y축 폰트20크기로 라벨링
     title ('Angular Velocity',   'fontsize',25);       % 폰트25 크기로 그래프 이름 설정
     
subplot(3,1,3)                              
Xmin = 0.0; XTick = 0.01; Xmax = 0.1;    % Xmin:X축 최소값parameter, XTick:X축 grid간격parameter, Xmax:X축 최대값parameter
Ymin =0; YTick = 200; Ymax = 2000;         % Ymin:Y축 최소값parameter, YTick:Y축 grid간격parameter, Ymax:Y축 최대값parameter
hold on
plot(x,y1(:,3),'-r', 'LineWidth',2) ; 
plot(x,y2(:,3),'-b', 'LineWidth',2) ; 
legend('Non Geared','Geared') %각 함수(그래프)에 대한 설명
 grid on; %Grid on
         axis([Xmin Xmax Ymin Ymax])               % Graph 최대 최소 설정
         set(gca, 'XTick', [Xmin:XTick:Xmax]);     % X축 Grid 간격
         set(gca, 'YTick', [Ymin:YTick:Ymax]);     % Y축 Grid 간격
     xlabel('time(s)',       'fontsize',20);       % X축 폰트20크기로 라벨링
     ylabel('Degree',     'fontsize',20);       % Y축 폰트20크기로 라벨링
     title ('Angle',   'fontsize',25);       % 폰트25 크기로 그래프 이름 설정
%% Load Torque
figure('units', 'pixels', 'pos',[100 100 300 600], 'Color', [1,1,1]);  % figure창 생성(측정단위(default),창 위치와 크기, 색(white))

subplot(3,1,1)                              
Xmin = 0.0; XTick = 0.01; Xmax = 0.1;    % Xmin:X축 최소값parameter, XTick:X축 grid간격parameter, Xmax:X축 최대값parameter
Ymin =0; YTick = 2; Ymax = 25;         % Ymin:Y축 최소값parameter, YTick:Y축 grid간격parameter, Ymax:Y축 최대값parameter
hold on;
plot(x,y2(:,1),'-b', 'LineWidth',2) ; 
plot(x,y3(:,1),'om', 'LineWidth',2) ; 
legend('Non Load','Load') %각 함수(그래프)에 대한 설명
 grid on; %Grid on
         axis([Xmin Xmax Ymin Ymax])               % Graph 최대 최소 설정
         set(gca, 'XTick', [Xmin:XTick:Xmax]);     % X축 Grid 간격
         set(gca, 'YTick', [Ymin:YTick:Ymax]);     % Y축 Grid 간격
     xlabel('time(s)',       'fontsize',20);       % X축 폰트20크기로 라벨링
     ylabel('Current[A]',     'fontsize',20);       % Y축 폰트20크기로 라벨링
     title ('Current',   'fontsize',25);       % 폰트25 크기로 그래프 이름 설정

subplot(3,1,2)   
Xmin = 0.0; XTick = 0.01; Xmax = 0.1;    % Xmin:X축 최소값parameter, XTick:X축 grid간격parameter, Xmax:X축 최대값parameter
Ymin =0; YTick = 5; Ymax = 50;         % Ymin:Y축 최소값parameter, YTick:Y축 grid간격parameter, Ymax:Y축 최대값parameter
hold on
plot(x,y2(:,2),'-b', 'LineWidth',2) ; 
plot(x,y3(:,2),'-m', 'LineWidth',2) ; 

legend('Non Load','Load') %각 함수(그래프)에 대한 설명
 grid on; %Grid on
         axis([Xmin Xmax Ymin Ymax])               % Graph 최대 최소 설정
         set(gca, 'XTick', [Xmin:XTick:Xmax]);     % X축 Grid 간격
         set(gca, 'YTick', [Ymin:YTick:Ymax]);     % Y축 Grid 간격
     xlabel('time(s)',       'fontsize',20);       % X축 폰트20크기로 라벨링
     ylabel('RPM',     'fontsize',20);       % Y축 폰트20크기로 라벨링
     title ('Angular Velocity',   'fontsize',25);       % 폰트25 크기로 그래프 이름 설정
     
subplot(3,1,3)     
Xmin = 0.0; XTick = 0.01; Xmax = 0.1;    % Xmin:X축 최소값parameter, XTick:X축 grid간격parameter, Xmax:X축 최대값parameter
Ymin =0; YTick = 5; Ymax = 25;         % Ymin:Y축 최소값parameter, YTick:Y축 grid간격parameter, Ymax:Y축 최대값parameter
hold on
plot(x,y2(:,3),'-b', 'LineWidth',2) ; 
plot(x,y3(:,3),'-m', 'LineWidth',2) ; 
legend('Non Load','Load') %각 함수(그래프)에 대한 설명
 grid on; %Grid on
         axis([Xmin Xmax Ymin Ymax])               % Graph 최대 최소 설정
         set(gca, 'XTick', [Xmin:XTick:Xmax]);     % X축 Grid 간격
         set(gca, 'YTick', [Ymin:YTick:Ymax]);     % Y축 Grid 간격
     xlabel('time(s)',       'fontsize',20);       % X축 폰트20크기로 라벨링
     ylabel('Degree',     'fontsize',20);       % Y축 폰트20크기로 라벨링
     title ('Angle',   'fontsize',25);       % 폰트25 크기로 그래프 이름 설정