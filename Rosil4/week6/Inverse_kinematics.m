
clear all
clc
l1 = 0.5;
l2 = 0.45;
position1 = 'x ';
position2 = 'y ';
x = input(position1);
y = input(position2);

cos_q2 = 0.5 *(x^2 + y^2 -l1^2 -l2^2) / (l1 * l2);
up_sin_q2 = -abs(sqrt(1-cos_q2^2));
down_sin_q2 = abs(sqrt(1-cos_q2^2));
up_q2 = atan2(up_sin_q2,cos_q2);
down_q2 = atan2(down_sin_q2,cos_q2);

up_cos_q1 = ((l1+l2*cos_q2)*x + (l2*up_sin_q2*y)) / ((l1+l2*cos_q2)^2 + (l2*up_sin_q2)^2);
down_cos_q1 = ((l1+l2*cos_q2)*x + (l2*down_sin_q2*y)) / ((l1+l2*cos_q2)^2 + (l2*down_sin_q2)^2);
up_sin_q1 = ((l1+l2*cos_q2)*y - (l2*up_sin_q2*x))/((l1+l2*cos_q2)^2 + (l2*up_sin_q2)^2);
down_sin_q1 = ((l1+l2*cos_q2)*y - (l2*down_sin_q2*x))/((l1+l2*cos_q2)^2 + (l2*down_sin_q2)^2);
up_q1 = atan2(up_sin_q1,up_cos_q1);
down_q1 = atan2(down_sin_q1,down_cos_q1);

if(abs(up_q1 - down_q1) < 0.0001 && abs(up_q2 - down_q2) < 0.0001) 
    disp('singularity(degree)');
    disp(rad2deg(up_q1));
    disp(rad2deg(up_q2));
else
    disp('elbow up(degree)');
    disp(rad2deg(up_q1));
    disp(rad2deg(up_q2));

    disp('elbow down(degree)');
    disp(rad2deg(down_q1));
    disp(rad2deg(down_q2));
end
