
clear
clc
m = 1.2; % Aircraft mass (Kg)
deltau = -25; % Up elevator deflection (deg)
deltad = 20; % Down elevator deflection (deg)
a = 0.486; % Linear acceleration during takeoff rotation (m/s)
Lwf = 10.327; % Wing fuselage lift force (N)
D = 1.046; % Drag force during takeoff (N)
T = 1.7045; % Trust force during takeoff (N)
Mac_wf = -0.1125; % Pitching moment (Nm)
Xmg_cg = 0.0506; % Distance between main gear and CG (m)
Xmg_acwf = 0.0424; % Distance between main gear and aerodynamic center (m)
Xach_mg = 0.3229; % Distance between HT aerodynamic center and main gear(m)
Zd_mg = 0.277; % Drag force distance from ground (m)
Zt_mg = 0.277; % Trust force distance from ground (m)
Zcg_mg = 0.2442; % CG distance from ground (m)
Iyymg = 0.1114; % Aircraft mass moment of inertial about main gear (Kgm^2)
theta = 12; % Takeoff rotation pitch angular acceleration (deg/s^2)
rho = 1.225; % Sea level air density (Kg/m^3)
Vr = 8.8; % Takeoff rotation speed (m/s)
Sh = 0.0245; % HT area (m^2)
CL_alfah = 4.3118; % HT lift curve slope (1/rad)
alfah = -5.12; % HT angle of attack (deg)
nh = 0.9; % HT Dynamic pressure ratio
VH = 0.3; % HT volume coefficient
taue = 0.4; % Elevator AOA effectiveness
S = 0.1878; % Wing area (m^2)


% LIFTING LINE THEORY PARAMETERS
ARh = 4.667; % HT Aspect ratio
lambdah = 0.7; % HT taper ratio
alpha_twist = -1e-10; % Twist angle (deg)
a_2d = 6.108; % airfoil lift curve slope (1/rad)
a_0 = 0; % HT zero lift AOA (deg)
ce_c=0.189; % Elevator to tail chord ratio
be_b=0.8; % Elevator-to-HT span ratio
ih = -1.39; % HT setting angle (deg)

% Elevator Longitudinal trim parameters
np = 0.85; % Propeller efficiency
P = 30; % Power (Watt)
Vc = 14.6154; % Crusie speed (m/s)
rhoc = 1.2232; % Air density (Kg/m^3)
Zt = 0.0328; % Thrust line to CG distance (m). -ve when thrust is ahead of CG
Cmo = -0.077;
MAC = 0.164;
CL_alfa = 4.828; % Wing lift curve slope (1/rad)
CL_1 = 0.4798;
CL_o = 0.8;
Cm_alfa = -0.8377;

% PLOT parametrs
Vs = 8; % Stall speed m/s
Vmax = 19; % Max speed m/s
g = 9.81; % m/s^2

% Stall parameters
Ato = 5.27; % Fuselage AOA at takeoff (deg)
e_a = 0.4390; % Downwash slope (rad/rad)
eo = 0.0436; % Downwash angle (rad)
AHs = 10; % HT stall angle without employing elevator (deg)
DhE = 2.5; % Elevator reduction in HT stall angle (deg)

Mw = m*9.81*Xmg_cg % Weight moment (Nm)
Md = D*Zd_mg % Weight moment (Nm)
Mt = T*Zt_mg % Thrust moment (Nm)
Mlwf = Lwf*Xmg_acwf % Wing/fuselage lift moment (Nm)
Ma = m*a*Zcg_mg % Linear acceleration moment (Nm)
Lh = (Mlwf+Mac_wf+Ma-Mw+Md-Mt-(Iyymg*theta/57.3))/Xach_mg % HT lift (N)
CLh = 2*Lh/(rho*Sh*Vr^2) % HT lift coefficient
tau = (CLh-(CL_alfah*alfah/57.3))/(CL_alfah*deltau/57.3)


N = 9; % (number of segments-1)
a_0_ed = 2*(-1.15*ce_c*deltau); % Deflected elevator zero-lift AOA (deg)
bh = sqrt(ARh*Sh); % HT span
MACh = Sh/bh; % Mean Aerodynamic Chord
Croot = (1.5*(1+lambdah)*MACh)/(1+lambdah+lambdah^2); % root chord
theta = pi/(2*N):pi/(2*N):pi/2;
alpha=ih+alpha_twist:-alpha_twist/(N-1):ih;
% segment’s angle of attack
for i=1:N
if (i/N)>(1-be_b)
    alpha_0(i)=a_0_ed; %flap down zero lift AOA
else
alpha_0(i)=a_0; %flap up zero lift AOA
end
end
z = (bh/2)*cos(theta);
c = Croot * (1 - (1-lambdah)*cos(theta)); % MAC at each segment
mu = c * a_2d / (4 * bh);
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
CL = 4*bh*sum2 ./ c;
CL1=[0 CL(1) CL(2) CL(3) CL(4) CL(5) CL(6) CL(7) CL(8) CL(9)];
y_s=[bh/2 z(1) z(2) z(3) z(4) z(5) z(6) z(7) z(8) z(9)];
plot(y_s,CL1,'-o')
grid
title('Lift distribution')
xlabel('Semi-span location (m)')
ylabel ('Lift coefficient')
CL_HT = pi * ARh * A(1)

% Elevator effectiveness derivatives
Cm_deltae = -CL_alfah*nh*VH*be_b*taue
CL_deltae = CL_alfah*nh*(Sh/S)*be_b*taue
CLh_deltae = CL_alfah * taue

Tc = np*P/Vc
qc = 0.5*rhoc*Vc^2
Delta_E = -((((Tc*Zt/(qc*S*MAC))+Cmo)*CL_alfa)+((CL_1-CL_o)*Cm_alfa))/((CL_alfa*Cm_deltae)-(Cm_alfa*CL_deltae))*57.3 % Elevator longitudinal trim deflection (deg)


i = 1;
for U =Vs:Vmax
    Tl = np*P/U;
    q1 = 0.5*rho*U^2;
    q2 = 0.5*rhoc*U^2;
    CL_1 = m*g/(q1*S);
    CL_2 = m*g/(q2*S);
    Delta_E1(i) = -((((Tl*Zt/(q1*S*MAC))+Cmo)*CL_alfa)+((CL_1-CL_o)*Cm_alfa))/((CL_alfa*Cm_deltae)-(Cm_alfa*CL_deltae))*57.3;
    Delta_E2(i) = -((((Tl*Zt/(q2*S*MAC))+Cmo)*CL_alfa)+((CL_2-CL_o)*Cm_alfa))/((CL_alfa*Cm_deltae)-(Cm_alfa*CL_deltae))*57.3;
    V(i) = U;
    i = i + 1;
end
plot(V,Delta_E1,'-o',V,Delta_E2,'-*')
grid
xlabel('Speed (m/s)')
ylabel('\delta_E (deg)')
title ('Variation of elevator deflection with flight speed at sea level and crusie altitude')
legend ('Sea level','Cruise altitude','location','northwest')

alfah_TO = (Ato*(1-e_a))+ih-(eo*57.3) % HT AOA at takeoff (deg)
Ah_stall = AHs -DhE % HT stall AOA at takeoff with deflected elevator (deg)
bE = bh*be_b % Elevator span (m)
CE = MACh*ce_c % Elevator chord (m)
SE = bE*CE % Elevator area (m^2)
