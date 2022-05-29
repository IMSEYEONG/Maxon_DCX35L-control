 clear all
 clc
%% Robot Parameter
l1 = 0.5;
l2 = 0.45;
alpha = [0 0 0];
a = [0 l1 l2];
d = [0 0 0];
syms theta1 theta2;

%% Transformation Matrix
T01 = [cos(theta1) -sin(theta1) 0 0
       sin(theta1) cos(theta1) 0 0
       0 0 1 0
       0 0 0 1];
T12 = [cos(theta2) -sin(theta2) 0 l1
       sin(theta2) cos(theta2) 0 0
       0 0 1 0
       0 0 0 1];
T23 = [1 0 0 l2
       0 1 0 0
       0 0 1 0
       0 0 0 1];
T03 = T01 * T12 * T23;

%% Forward Kinematics
x = T03(1,4)
y = T03(2,4)
z = T03(3,4)

%% 수
q1 = 'theta1(degree) ';  % Prompt 함: 대화 상자를 생성
q2 = 'theta2(degree) ';
theta1 = pi/180 *input(q1); % input 함수: 사용자가 입력한 값을 반환
theta2 = pi/180 *input(q2);

x = subs(T03(1,4))
y = subs(T03(2,4))
z = subs(T03(3,4))
