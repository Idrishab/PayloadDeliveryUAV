
clear
clc
Clalfa = 6.1852; % Wing airfoil lift curve slope (1/rad)
AR = 7; %  Wing aspect ratio
MAC = 0.164; % Wing MAC (m)
phid = 30; % Desired bank angle (deg)
tau = 0.41; % Aileron effectiveness parameter
Cr = 0.164; % Wing root chord (m)
S = 0.1878; % Wing area (m^2)
b = 1.15; % Wing span (m)
lambda = 1; % Wing taper ratio
Yi = 0.7; % Inboard aileron position on wing span
Yo = 0.95; % Outboard aileron position on wing span
delta_max = 25; % Maximum aileron deflection (deg)
rho = 1.225; % Air density at critical flight condition altitude (Kg/m^3)
Vt = 10.4; % Flight speed at critical flight condition
yd = 0.4; % Percentage rolling drag center along the y-axis
Sh = 0.0245; % HT area (m^2)
Svt = 0.02; % VT area (m^2)
CDR = 0.95; % Rolling drag coefficient
Ixx = 0.03517; % Mass moment of inertia (Kgm^2)

yi = Yi*b/2 % Inboard aileron position relative to fuselage center line (m)
yo = Yo*b/2 %Outboard aileron position relative to fuselage center line (m)

CL_alfa = Clalfa/(1+(Clalfa/(3.142*AR))) % Wing lift curve slope (1/rad)
Cl_delta_A = (2*CL_alfa*tau*Cr/(S*b))*(((0.5*yo^2)+((2/3)*(yo^3)*((lambda-1)/b)))-((0.5*yi^2)+((2/3)*(yi^3)*((lambda-1)/b)))) % Aileron rolling momemt (1/rad)
Cl = Cl_delta_A*(delta_max/57.3)
q = 0.5*rho*Vt^2
LA = q*S*Cl*b
Pss = sqrt(2*LA/(rho*(S+Sh+Svt)*CDR*((yd*b/2)^3)))
phi1 = Ixx*log(Pss^2)/(rho*(S+Sh+Svt)*CDR*((yd*b/2)^3)) % Steady state bank angle (rad)
phi1_deg = phi1*57.3 % Steady state bank angle(deg)
P = (Pss^2)/(2*phi1)
if phi1_deg>phid
    t2 = sqrt(2*phid/(P*57.3))
else 
    tss = sqrt(2*psi1/P)
    Delta_tr = (psid-psi1)/Pss
end
ba = yo-yi % Aileron span (m)
Ca = 0.2*MAC % Aileron chord (m)
Sa = 2*ba*Ca % Both wing sides aileron area (m^2)
