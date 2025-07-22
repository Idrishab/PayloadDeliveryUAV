clc
clear
N = 9; % (number of segments-1)
S = 0.1878; % m^2
AR = 7; % Aspect ratio
lambda = 1; % Taper ratio
alpha_twist = -1e-10; % Twist angle (deg)
i_w = 8.07; % wing setting angle (deg)
a_2d = 6.1852; % lift curve slope (1/rad)
a_0 = -3.1264; % flap up zero-lift angle of attack (deg)
cf_c=0.2; %flap to wing chord ratio
df=13; %flap deflection(deg)
a_0_fd = 2*(-1.15*cf_c*df); % flap down zero-lift angle of attack (deg)
b = sqrt(AR*S); % wing span
bf_b=0.6; %flap-to-wing span ratio
MAC = S/b; % Mean Aerodynamic Chord
Croot = (1.5*(1+lambda)*MAC)/(1+lambda+lambda^2); % root chord
theta = pi/(2*N):pi/(2*N):pi/2;
alpha=i_w+alpha_twist:-alpha_twist/(N-1):i_w;
% segment’s angle of attack
for i=1:N
if (i/N)>(1-bf_b)
    alpha_0(i)=a_0_fd; %flap down zero lift AOA
else
alpha_0(i)=a_0; %flap up zero lift AOA
end
end
z = (b/2)*cos(theta);
c = Croot * (1 - (1-lambda)*cos(theta)); % MAC at each segment
mu = c * a_2d / (4 * b);
LHS = mu .* (alpha-alpha_0)/57.3; % Left Hand Side
% Solving N equations to find coefficients A(i):
for i=1:N
for j=1:N
B(i,j) = sin((2*j-1) * theta(i)) * (1 + (mu(i) * (2*j-1)) / sin(theta(i)));
end
end
A=B\transpose(LHS);
for i = 1:N
sum1(i) = 0;
sum2(i) = 0;
for j=1:N
sum1(i) = sum1(i) + (2*j-1) * A(j)*sin((2*j-1)*theta(i));
sum2(i) = sum2(i) + A(j)*sin((2*j-1)*theta(i));
end
end
CL_TO = pi * AR * A(1)