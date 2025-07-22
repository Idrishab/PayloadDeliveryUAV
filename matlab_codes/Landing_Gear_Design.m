% THIS CODE IS STRICTLY FOR TRICYCLE LANDING GEAR DESIGN
% IT IS BASICALLY WRITTEN FOR LANDING GEAR ATTACHED UNDER FUSELAGE
% IF THIS IS TO BE USED FOR A DIFFERENT DESIGN, REVIEW EACH LINE OF THE CODE CAREFULLY
% ALL DIMENSIONS ARE IN S.I. UNIT

clear
clc
Delta_H = 0.05; % Landing gear clearance from aircraft lowest point (m)
Dprop = 0.254; % Properller diameter (m)
Delta_G = -0.0358; % Distance between CG and prop mid point (m).
hcg = 0.0242; % Distance between CG and fuselage base (m)
np_to = 0.5; % Propeller efficiency at takeoff
Pmax = 30; % Maximum engine power (W)
Vto = 9.6; % Takeoff rotation speed (m/s)
CDo_to = 0.0495; 
K = 0.0551;
CL_to = 1.1105;
rho = 1.225;
Vr = 8.8; % Aircraft linear forward speed at instant of rotation (m/s)
S = 0.1878; % Wing area (m/s^2)
Sh = 0.0245; % Horizontal tail area (m^2)
m = 1.2; % Aircraft mass (kg)
miu = 0.04; % coefficient of friction
CLh = -0.374; % Horizontal tail CL. The suppose -ve sign is in the equation
MAC = 0.164; % Wing MAC (m)
CMac_wf = -0.077; % Wing/fuselage pitching moment coefficient
Zd = 0.06; % Drag height from fuselage base (m)
Zt = 0.06; % Thrust height from fuselage base (m)
g = 9.81; % Acceleration due to gravity (m/s^2)
Xac = 0.25; % Aerodynamic pitching moment percentage location on wing
Xcg_fwd = 0.2; % Percentage CG forward position on wing MAC
Xcg_aft = 0.2; % Percentage CG aft position on wing MAC
lh = 0.3773; % Horizontal tail arm
theta = 12; % Takeoff pitch angular acceleration (deg/s^2)
xcg = 0; % This should be zero because the aircraft CG was set as the reference point
Iyycg = 0.042; 
Xle_us = 0.26955; % Horizontal distance from wing LE to fuselage upsweep point (m)
Fn = 0.2; % Percentage load carried by nose gear relative to aircraft weight
Vtaxi = 6; R = 7; % Taxi speed (m/s) and taxi turn radius (m)
Vw = 20; % Cross wind speed (m/s)
As = 0.05; % Aircraft side area (m^2)
CDs = 0.55; % Aircraft side drag coefficient
hc = 0.07; % Controid height from fuselage base (m)
aL = -0.5;


H_CG = Delta_H +(Dprop/2) + Delta_G % CG distance from ground (m)
H_LG = H_CG - hcg % Landing gear heaight (m). For LG under fuselage

% Main gear distance from aircraft CG
% Forces
Tto = np_to*Pmax/Vr; % Thrust at takeoff (N)
CDto = CDo_to + (K*CL_to^2) % Total drag coefficient at takeoff
Dto = 0.5*rho*(Vr^2)*S*CDto % Total drag force at takeoff (N)
Lto = 0.5*rho*(Vr^2)*S*CL_to; % Lift force at takeoff(N)
Ff = miu*((m*9.81)-Lto); % Frictional force (N)
Lh = 0.5*rho*(Vr^2)*Sh*CLh; % Horizontal tail lift force
Lwf = Lto - Lh % Wing/fuselage lift force
a = (Tto-Dto-Ff)/m % Aircraft linear acceleration at takeoff rotation time

% Moments
Mac_wf = 0.5*rho*(Vr^2)*S*CMac_wf*MAC % Pitching moment (Nm)
Md = Dto * (Zd+H_LG); % Drag moment (Nm)
Mt = Tto * (Zt+H_LG); % Thrust moment(Nm)
xac_wf = (Xac-Xcg_fwd)*MAC; % Wing/fuselage aerodynamic center location
xac_h = lh+xac_wf; % HT aerodynamic center location
Ma = m*a*H_CG; % Linear acceleration moment (Nm)
W = m*g; % Aircraft weigth (N)
xmgi = ((Iyycg*theta/57.3)-Md+Mt-Mac_wf-Ma-(W*xcg)+(Lwf*xac_wf)+(Lh*xac_h))/(Lwf+Lh-W) % Main gear maximum allowable distance from CG
Iyymg = Iyycg+(m*(xmgi^2+H_CG^2))
xmg = ((Iyymg*theta/57.3)-Md+Mt-Mac_wf-Ma-(W*xcg)+(Lwf*xac_wf)+(Lh*xac_h))/(Lwf+Lh-W) % Main gear maximum allowable distance from CG
xmg = abs(xmg)

Delta_xcg = (Xcg_fwd-Xcg_aft)* MAC;
xmgfor=xmg;
xmgaft =  xmgfor - Delta_xcg;
alfa_tb = atand(xmgaft/H_CG) % Tipback angle (deg)
Xmg_LE = xmgfor+(Xcg_fwd*MAC) % Distance from main gear to wing LE
Xmg_us = Xle_us-Xmg_LE; % Distance from main gear to upsweep point
Alfa_clear = atand (H_LG/Xmg_us) % Takeoff rotation clearance (deg)

% Wheel base
Bm = xmgfor;
Base = Bm*W/(Fn*W) % Wheel base (m)

% Wheel track
T_min = 2*tand(30)*H_CG % Wheel track (m)
Fc = m*(Vtaxi^2)/R % Centrifugal force (N)
T_GC = 2*Fc*H_CG/(m*g) % Wheel track based on ground controllability (m)
Phi_OT_GC = atand (Fc/(m*g)) % Overturn angle (deg)
Fw = 0.5*rho*(Vw^2)*As*CDs % Cross wind force (N)
T_GS = 2*Fw*(hc+H_LG)/W % Wheel tarck based on ground stability (m)

% LANDING GEAR LOADS
Bm_max = xmgfor;
Bn_max = Base-xmgaft;
Fn_max = W*Bm_max/Base; % Nose gear static load (N)
Fm_max = W*Bn_max/Base; % Main gear static load (N)
Fn_dyn = (W*abs(aL)*H_CG)/(g*Base); % Nose gear dynamic load (N)
Fm_dyn = (W*a*H_CG)/(g*Base); % Main gear dynamic load (N)
FN = Fn_max + Fn_dyn % Nose gear total load (N)
FM = Fm_max + Fm_dyn % Main gear total load (N)