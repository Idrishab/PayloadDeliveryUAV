clc
clear
n_places = 0; % no of places
ind_weight = 0; % individyual weight (N)
carry_on = 0; % passenger carry on (N)
cargo_weight = 0; % (N)
k = 3.5; % k is 3.5 for reciprocating engine
rho = 1.225; % air density at sea level (kg/m^3)
Vstall = 8; % stall speed (m/s)
CLmax = 1.6; 
Vmax = 19; % maximum speed (m/s)
hc = 15; % cruise altitude (m)
AR = 7; % wing aspect ratio
CDp=0.025; % Profile drag
e=0.825; % Oswald span efficiency factor
np = 0.85; % propeller efficiency
pi = 3.142;
ROC = 0.5; % Rate of climb (m/s)
CDo = 0.035; %CD0=zero lift CD

a = 1; b = 1;
A = 1; c = 1; Kus = 1;
DR = 1; LR =1; % Design and loiter range
SFC = 1; % Specific fuel consumption

Wp = (n_places*(ind_weight+carry_on))+cargo_weight; % payload weight (N)
%G_weight = k * Wp;
G_weight = 1.2*9.81;
Wg = G_weight; % gross weight (N)
WL = 0.5*rho*(Vstall^2)*CLmax; % (N/m^2)
Vland = 1.3*Vstall; % landing speed (m/s)
Vcr = Vmax/1.3; % Cruise speed (m/s)
Se = Wg/WL; % effective wing area
x=hc;
x0=0; y0=1;
x1=305; y1=0.9711;
x2=610; y2=0.9428;
L0=((x-x1)*(x-x2))/((x0-x1)*(x0-x2));
L1=((x-x0)*(x-x2))/((x1-x0)*(x1-x2));
L2=((x-x0)*(x-x1))/((x2-x0)*(x2-x1));
y=(L0*y0)+(L1*y1)+(L2*y2);
sigmac=y;
rhoc=y*1.225;
DP = 0.5*rhoc*sigmac*Vcr^2; % dynamic pressure (N/m^2)
CLc = WL/DP; % coefficient of lift at cruise
F = 1/CLc;
CD = CDp+((CLc^2)/(pi*e*AR));% Total drag
LD = CLc/CD; % Lift to drag ratio
D = Wg/LD; % Total drag (N)
THP = D*Vcr/745.7; % thrust horsepower required at cruise (hp)
BHPcr = THP/(np*0.7); % Brake horsepower at cruise (hp)
BHPsl = BHPcr*(rho/rhoc)^0.96; % BHP at sea level (hp)
CLc_opt = sqrt(pi*e*AR*CDp); % optimum cruise CL
Vcr_opt = sqrt(2*Wg/(rhoc*sigmac*CLc_opt*Se*F));
K = 1/(pi*e*AR)
PL_roc=1/((ROC/np)+(sqrt(2*WL/(rho*sqrt(3*CDo/K)))*(1.155/(LD*np))))
P = Wg/PL_roc % Power required for ROC (W)
WTO = Wg;
We = ((a*WTO) + b)* WTO; % Empty weight
We = A*(WTO^c)*Kus*WTO; % Empty weight
Woil = 0.01*BHPcr*(DR+LR)/Vcr_opt; % Oil weight
Wfuel = SFC*BHPcr*(DR+LR)/Vcr_opt; % Fuel weight
WG = We+Woil+Wfuel+Wp; % New gross weight
CF = WG/Wg; % Correction factor
Se2 = Se*CF; % New wing area
D2 = D*CF; % New drag force
T2 = D2; % New thrust
BHPsl2 = BHPsl*CF; % New maxiumum Brake Horsepower