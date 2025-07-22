Wto=11.7720;
Vc=14.6154;    S=0.1878;   Vs=8;
Wi=Wto; Wf=Wto;   % initial  and final gross weight
Delta_CL_HLD=0.55; %HLD lift coefficent

W_avg=0.5*(Wi+Wf);
hc=15;    %   cruise altitude
x=hc;
x0=0; y0=1;
x1=305; y1=0.9711;
x2=610; y2=0.9428;
L0=((x-x1)*(x-x2))/((x0-x1)*(x0-x2));
L1=((x-x0)*(x-x2))/((x1-x0)*(x1-x2));
L2=((x-x0)*(x-x1))/((x2-x0)*(x2-x1));
y=(L0*y0)+(L1*y1)+(L2*y2);
rho_cruise=y*1.225
CL_cruise=(2*W_avg)/(rho_cruise*(Vc^2)*S) % Aircraft ideal cruise CL
CL_cw=CL_cruise/0.95 % Wing cruise CL
Cli=CL_cw/0.9
wing_airfoil_ideal_Cl=Cli;       % Airfoil ideal lift coefficient
rho=1.225;
CLmax=(2*Wto)/(rho*(Vs^2)*S)
CLmax_w=CLmax/0.95              %wing maximum CL
Clmax_gross=CLmax_w/0.9
Gross_airfoil_wing_max_Cl=Clmax_gross; %Airfoil max Cl without HLD
Cl_max=Clmax_gross-Delta_CL_HLD
Airfoil_Net_Max_CL=Cl_max=; %Airfoil max Cl with HLD