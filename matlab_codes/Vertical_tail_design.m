
VV = 0.035; % VT volume coefficient
lv=0.3773; % VT moment arm
b = 1.146; % Wing span (m)
S = 0.1878; % Wing area (m^2)
Vc = 14.6154; hc = 15; % Cruise speed (m/s) and cruise altitude (m)
ARv = 1.5; % VT aspect ratio
lambdav = 0.75; % VT taper ratio
iv = 0; % VT incidence (deg)
VT_swp = 0; % VT tail sweep angle (deg)
Cl_alfa = 6.1076; % Airfoil lift curve slope (1/rad)
T = 1; % engine thrust (N)
Y = 0; % engine thrust line distance from CG along y axis (m)
Sv = S*b*VV/lv % VT area (m^2)
bv = sqrt(Sv *ARv) % VT span
MACv = bv/ARv % VT mean aerodynamic chord
Cv_root = (3/2)*MACv/((1+lambdav+(lambdav^2))/(1+lambdav)) % VT root chord
Cv_tip = lambdav*Cv_root % VT tip chord
x=hc;
x0=0; y0=1;
x1=305; y1=0.9711;
x2=610; y2=0.9428;
L0=((x-x1)*(x-x2))/((x0-x1)*(x0-x2));
L1=((x-x0)*(x-x2))/((x1-x0)*(x1-x2));
L2=((x-x0)*(x-x1))/((x2-x0)*(x2-x1));
y=(L0*y0)+(L1*y1)+(L2*y2);
rhoc=y*1.225;

% Lift Coefficient Calculation
N = 9; % (number of segments-1) 
alpha_twist = 0.00001; % Twist angle (deg) 
a_h = 0; % tail angle of attack (deg) 
a_2d = Cl_alfa/(1+(Cl_alfa/(3.142*ARv))); % tail lift curve slope (1/rad) 
alpha_0 = 0; % Airfoil zero-lift angle of attack (deg)
theta = pi/(2*N):pi/(2*N):pi/2;
alpha=a_h+alpha_twist:-alpha_twist/(N-1):a_h;% segment’s angle of attack
z = (bv/2)*cos(theta);
c = Cv_root * (1 - (1-lambdav)*cos(theta)); % Mean Aerodynamics chord at each segment
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
CL_vtail = pi * ARv * A(1) % VT lift coefficient at specified tail AOA

Lv = 0.5*rhoc*(Vc^2)*Sv*CL_vtail; % VT Lift
Summatio_Ncg = (T*Y)+ (Lv*lv) % Directional trim. This should be equal to zero