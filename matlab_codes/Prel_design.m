function Prel_design=Prel_design(Vs,Vmax,Sto,ROC_max)
%rho=air density at sea level, CLmax=maximum lift coefficient
%WL=wing loading, PL=power loading
WL=15:0.1:70;

%STALL SPEED
Vs=8;
rho=1.225; CLmax=1.6;
PL_stall=0:0.05:3;
WLs=rho*(Vs^2)*CLmax/2;
%MAXIMUM SPEED
pi=3.142; e=0.825; %e=oswald span efficiency factor
AR=7; np=0.6; %AR=aspect ratio, np=propeller efficiency
CD0=0.035; %CD0=zero lift CD
Vmax_altitude=20;
x=Vmax_altitude;
x0=0; y0=1;
x1=305; y1=0.9711;
x2=610; y2=0.9428;
L0=((x-x1)*(x-x2))/((x0-x1)*(x0-x2));
L1=((x-x0)*(x-x2))/((x1-x0)*(x1-x2));
L2=((x-x0)*(x-x1))/((x2-x0)*(x2-x1));
y=(L0*y0)+(L1*y1)+(L2*y2);
sigma_max=y;
rho_max=y*1.225; 
k=1/(pi*e*AR)
PL_max=(np)./((0.5*rho*(Vmax^3)*CD0./WL)+(2*k*WL./(rho_max*sigma_max*Vmax)));
%TAKEOFF RUN
Vto=1.1*Vs %takeoff velocity
g=9.81;miu=0.04; %miu=runway friction coefficient
CLc=0.3; delta_CL_flap_to=0.55;%flap lift coefficient at takeoff
CD0_LG=0.009; CD0_HLD_to=0.0055; % zero lift CD for landing gear and high lift device at takeoff
CD0_to=CD0+CD0_LG+CD0_HLD_to
CL_to=CLc+delta_CL_flap_to;
CD_to=CD0_to+(k*(CL_to^2));
CDg=CD_to-(miu*CL_to);
CLr=CLmax/1.21;
PL_to=(1-exp(0.6*rho*g*CDg*Sto./WL))*(np/Vto)./(miu-((miu+(CDg./CLr))*(exp(0.6*rho*g*CDg*Sto./WL))));
%RATE OF CLIMB
rho_climb=1.225;LDmax=7;
PL_roc=1./((ROC_max/np)+(sqrt(2*WL./(rho_climb*sqrt(3*CD0./k)))*(1.155./(LDmax*np))));
%CEILING
h_celing=25;%ceiling altitude
x=h_celing;
x0=0; y0=1;
x1=305; y1=0.9711;
x2=610; y2=0.9428;
L0=((x-x1)*(x-x2))/((x0-x1)*(x0-x2));
L1=((x-x0)*(x-x2))/((x1-x0)*(x1-x2));
L2=((x-x0)*(x-x1))/((x2-x0)*(x2-x1));
y=(L0*y0)+(L1*y1)+(L2*y2);
sigma_c=y;
rho_c=y*1.225;
ROC_c=0.1;
PL_c=sigma_c./((ROC_c./np)+(sqrt(2*WL./(rho_c*sqrt(3*CD0./k)))*(1.155./(LDmax*np))));
plot(WLs,PL_stall,'b*:',WL,PL_max,'y*--',WL,PL_to,'r^--',WL,PL_roc,'mo:',WL,PL_c,'g--o'),grid,
legend('Vstall (blue)','Vmax(yellow)','Sto(red)','ROCmax(magenta)','Ceiling(green)','location','northwest')
title('Power Loading vs Wing Loading'), xlabel('Wing Loading (N/m2)')
ylabel('Power Loading(N/W)')
end
