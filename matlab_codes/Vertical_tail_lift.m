N = 9; % (number of segments-1) 
Sv = 0.0150; % m ˆ 2 
ARv = 1.5; % Aspect ratio 
lambdav = 0.75; % Taper ratio 
alpha_twist = 0.00001; % Twist angle (deg) 
a_h = 0; % tail angle of attack (deg) 
Cl_alfa = 6.18; % Airfoil lift curve slope (1/rad)
a_2d = Cl_alfa/(1+(Cl_alfa/(3.142*ARv))); % tail lift curve slope (1/rad) 
alpha_0 = 0; % Airfoil zero-lift angle of attack (deg)
bv = sqrt(ARv*Sv); % tail span
Cvroot = 0.1099; % root chord
theta = pi/(2*N):pi/(2*N):pi/2;
alpha=a_h+alpha_twist:-alpha_twist/(N-1):a_h;% segment’s angle of attack
z = (bv/2)*cos(theta);
c = Cvroot * (1 - (1-lambdav)*cos(theta)); % Mean Aerodynamics chord at each segment
mu = c * a_2d / (4 * bv);
LHS = mu .* (alpha-alpha_0)/57.3; % Left Hand Side
% Solving N equations to find coefficients A(i):
for i=1:N
for j=1:N
B(i,j)=sin((2*j-1) * theta(i)) * (1+(mu(i) *(2*j-1))/sin(theta(i)));
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
CL_vtail = pi * ARv * A(1)