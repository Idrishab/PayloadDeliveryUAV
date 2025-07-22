
clear
clc
U = 10.4; % Landing speed (m/s)
Vw = 3.5; % Cross wind speed (m/s)
xcg = 0.3332; % Cg x-distance from reference (m)
xca = 0.4213; % Aircraft side area centroid distance from reference (m)
rho = 1.225; % Critical altitude air density (Kg/m^3)
Ss = 0.097; % Aircraft side area (m^2)
CDy = 0.65; % Aircraft side drag
Kf2 = 1.35; 
CL_alfav = 2.66; % VT lift curve slope (1/rad)
Sang = -2.6; % VT Sidewash gradient (rad/rad)
nv = 0.9; % VT efficiency
Sv = 0.02; % VT area (m^2)
S = 0.1878; % Wing area (m^2)
b = 1.15; % Wing span (m)
VV = 0.035; % VT volume coefficient
taur = 0.52; % Rudder AOA effectiveness parameter
br_b = 1; % Rudder span to VT span ratio
Cr_C = 0.3; % Rudder chord to VT chord ratio
bv = 0.173; % Rudder span (m)
MACv = 0.115; % VT MAC (m)
CnB = 0.266;
Cyo = 0;
Cno=0;

Vt = sqrt(U^2+Vw^2) % Total approach airspeed (m/s)
dc = xca-xcg % Distance between side area centroid and cg (m)
Fw = 0.5*rho*Vw^2*Ss*CDy % Crosswind force (N)
beta = atand(Vw/U) % Sideslip angle (deg)
CyB = -Kf2*CL_alfav*(1-Sang)*nv*Sv/S % Aircraft sideslip derivative (1/rad)

% CONTROL DERIVATIVES
CnDR = -CL_alfav*VV*nv*taur*br_b 
CyDR = CL_alfav*nv*taur*br_b*Sv/S

Delta_R = 20; ea = 1; i = 0;
while ea > 1e-7
    DRo = Delta_R;
    sigma = beta-(((2*Fw/(rho*S*Vt^2))-(Cyo/57.3)-((CyDR/57.3)*Delta_R))/(CyB/57.3));
    frat = Fw*dc*cosd(sigma)/(0.5*rho*S*b*Vt^2);
    Delta_R = -(frat+(Cno/57.3)+((CnB/57.3)*(beta-sigma)))/(CnDR/57.3);
    ea = abs((Delta_R-DRo)/DRo);
    i = i + 1;
end
i
Delta_R
sigma

% TEST -- TEST1 and TEST2 must approximate to zero for Delta_R and sigma to
% be correct
TEST1 = (0.5*rho*(Vt^2)*S*b*((Cno/57.3)+((CnB/57.3)*(beta-sigma))+((CnDR/57.3)*Delta_R)))+(Fw*dc*cosd(sigma))
TEST2 = Fw-(0.5*rho*(Vt^2)*S*((Cyo/57.3)+((CyB/57.3)*(beta-sigma))+((CyDR/57.3)*Delta_R)))

br = br_b*bv
Cr = Cr_C * MACv
