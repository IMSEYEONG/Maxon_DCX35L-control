clear all, clc   

La = 0.658*10^-3;                   % Inductance
Va5 = 5;                            % Input Voltage
Va12 = 12;                          % Input Voltage
Va24 =24;                           % Input Voltage
Va48 = 48;                          % Input Voltage
Ra = 1.76;                          % Resistance                                     
Tl = 0;                             % Load
Tl05 = 0.5;
Tl1 = 1;
Kt = 68.3*10^-3;                    % Torque Constant
Ke = 68.3*10^-3;                    % Back EMF Constant
J  = 99.5*10^-2*10^-2*10^-3;        % Rotor Inertia      
t = 3.76*10^-3;                     % Mechanical Time Constant
b  = J/t;                           % Friction Coefficient(J/t)     


%%
out = sim('week2_2016741077_ImSeYeong_simul');
x = out.simout5.time;                     % 시간성분 가져오기
y5 = out.simout5.signals.values;          % 전압:5V 로드토크 0[Nm] 일때 가져오기 
y12 = out.simout12.signals.values;        % 전압:12V 로드토크 0[Nm] 일때 가져오기 
y24 = out.simout24.signals.values;        % 전압:24V 로드토크 0[Nm] 일때 가져오기 
y48 = out.simout48.signals.values;        % 전압:48V 로드토크 0[Nm] 일때 가져오기 
y05 = out.simout05.signals.values;        % 전압:48V 로드토크 0.5[Nm] 일때 가져오기 
y1 = out.simout1.signals.values;          % 전압:48V 로드토크 1[Nm] 일때 가져오기 

figure('units', 'pixels', 'pos',[100 100 300 600], 'Color', [1,1,1]);  
%Time-Domain
subplot(2,1,1)                              

Xmin = 0.0; XTick = 0.01; Xmax = 0.1;    % Xmin:X축 최소값parameter, XTick:X축 grid간격parameter, Xmax:X축 최대값parameter
Ymin =0; YTick = 50; Ymax = 400;         % Ymin:Y축 최소값parameter, YTick:Y축 grid간격parameter, Ymax:Y축 최대값parameter
hold on;
plot(x,y5(:,1),'-r', 'LineWidth',2) ; 
plot(x,y12(:,1),'-b', 'LineWidth',2) ; 
plot(x,y24(:,1),'-k', 'LineWidth',2) ; 
plot(x,y48(:,1),'-m', 'LineWidth',2) ; 


legend('5V','12V','24V','48V') %각 함수(그래프)에 대한 설명
 grid on; %Grid on
         axis([Xmin Xmax Ymin Ymax])               % Graph 최대 최소 설정
         set(gca, 'XTick', [Xmin:XTick:Xmax]);     % X축 Grid 간격
         set(gca, 'YTick', [Ymin:YTick:Ymax]);     % Y축 Grid 간격
     xlabel('time(s)',       'fontsize',20);       % X축 폰트20크기로 라벨링
     ylabel('rad/s',     'fontsize',20);       % Y축 폰트20크기로 라벨링
     title ('Angular Velocity',   'fontsize',25);       % 폰트25 크기로 그래프 이름 설정

 subplot(2,1,2)                              

Xmin = 0.0; XTick = 0.01; Xmax = 0.1;    % Xmin:X축 최소값parameter, XTick:X축 grid간격parameter, Xmax:X축 최대값parameter
Ymin =0; YTick = 200; Ymax = 2000;         % Ymin:Y축 최소값parameter, YTick:Y축 grid간격parameter, Ymax:Y축 최대값parameter
hold on
plot(x,y5(:,2),'-r', 'LineWidth',2) ;
plot(x,y12(:,2),'-b', 'LineWidth',2) ;
plot(x,y24(:,2),'-k', 'LineWidth',2) ;
plot(x,y48(:,2),'-m', 'LineWidth',2) ;

legend('5V','12V','24V','48V') %각 함수(그래프)에 대한 설명
 grid on; %Grid on
         axis([Xmin Xmax Ymin Ymax])               % Graph 최대 최소 설정
         set(gca, 'XTick', [Xmin:XTick:Xmax]);     % X축 Grid 간격
         set(gca, 'YTick', [Ymin:YTick:Ymax]);     % Y축 Grid 간격
     xlabel('time(s)',       'fontsize',20);       % X축 폰트20크기로 라벨링
     ylabel('degree',     'fontsize',20);       % Y축 폰트20크기로 라벨링
     title ('Angle',   'fontsize',25);       % 폰트25 크기로 그래프 이름 설정
%% Load Torque
figure('units', 'pixels', 'pos',[100 100 300 600], 'Color', [1,1,1]);  % figure창 생성(측정단위(default),창 위치와 크기, 색(white))
%Time-Domain
subplot(2,1,1)                              

Xmin = 0.0; XTick = 0.01; Xmax = 0.1;    % Xmin:X축 최소값parameter, XTick:X축 grid간격parameter, Xmax:X축 최대값parameter
Ymin =0; YTick = 50; Ymax = 400;         % Ymin:Y축 최소값parameter, YTick:Y축 grid간격parameter, Ymax:Y축 최대값parameter
hold on;
plot(x,y48(:,1),'-r', 'LineWidth',2) ; 
plot(x,y05(:,1),'-b', 'LineWidth',2) ; 
plot(x,y1(:,1),'-k', 'LineWidth',2) ; 


legend('0[Nm]','0.5[Nm]','1[Nm]') %각 함수(그래프)에 대한 설명
 grid on; %Grid on
         axis([Xmin Xmax Ymin Ymax])               % Graph 최대 최소 설정
         set(gca, 'XTick', [Xmin:XTick:Xmax]);     % X축 Grid 간격
         set(gca, 'YTick', [Ymin:YTick:Ymax]);     % Y축 Grid 간격
     xlabel('time(s)',       'fontsize',20);       % X축 폰트20크기로 라벨링
     ylabel('rad/s',     'fontsize',20);       % Y축 폰트20크기로 라벨링
     title ('Angular Velocity(48V)(Load Torque)',   'fontsize',25);       % 폰트25 크기로 그래프 이름 설정

 subplot(2,1,2)                              

Xmin = 0.0; XTick = 0.01; Xmax = 0.1;    % Xmin:X축 최소값parameter, XTick:X축 grid간격parameter, Xmax:X축 최대값parameter
Ymin =0; YTick = 200; Ymax = 2000;         % Ymin:Y축 최소값parameter, YTick:Y축 grid간격parameter, Ymax:Y축 최대값parameter
hold on
plot(x,y48(:,2),'-r', 'LineWidth',2) ;
plot(x,y05(:,2),'-b', 'LineWidth',2) ;
plot(x,y1(:,2),'-k', 'LineWidth',2) ;


legend('0[Nm]','0.5[Nm]','1[Nm]') %각 함수(그래프)에 대한 설명
 grid on; %Grid on
         axis([Xmin Xmax Ymin Ymax])               % Graph 최대 최소 설정
         set(gca, 'XTick', [Xmin:XTick:Xmax]);     % X축 Grid 간격
         set(gca, 'YTick', [Ymin:YTick:Ymax]);     % Y축 Grid 간격
     xlabel('time(s)',       'fontsize',20);       % X축 폰트20크기로 라벨링
     ylabel('degree',     'fontsize',20);       % Y축 폰트20크기로 라벨링
     title ('Angle(48V)(Load Torque)',   'fontsize',25);       % 폰트25 크기로 그래프 이름 설정