function y=test_design(Vs,Vmax,Sto,ROC_max)
%rho=air density at sea level, CLmax=maximum lift coefficient
%WL=wing loading, PL=power loading
WL=15:0.1:70;

%STALL SPEED
rho=0.002378; CLmax=2.7;
PL_stall=0:0.5:10;
WLs=rho*((Vs*1.688)^2)*CLmax/2;
%MAXIMUM SPEED
pi=3.14; e=0.85; %e=oswald span efficiency factor
AR=12; np=0.7; %AR=aspect ratio, np=propeller efficiency
CD0=0.025; %CD0=zero lift CD
rho_max= 0.00089; 
sigma_max=rho_max/rho;
k=1/(pi*e*AR);
Vmax=Vmax*1.688;
PL_max=(np*550)./((0.5*rho*(Vmax^3)*CD0./WL)+(2*k*WL./(rho_max*sigma_max*Vmax)));
%TAKEOFF RUN
Vto=1.1*Vs*1.688 %takeoff velocity
g=32.2;miu=0.04; %miu=runway friction coefficient
CLc=0.3; delta_CL_flap_to=0.6;%flap lift coefficient at takeoff
CD0_LG=0.009; CD0_HLD_to=0.005; % zero lift CD for landing gear and high lift device at takeoff
CD0_to=CD0+CD0_LG+CD0_HLD_to;
CL_to=CLc+delta_CL_flap_to;
CD_to=CD0_to+(k*(CL_to^2));
CDg=CD_to-(miu*CL_to);
CLr=CLmax/1.21;
rhos=0.002175;
PL_to=(1-exp(0.6*rhos*g*CDg*Sto./WL))*(np/Vto)./(miu-((miu+(CDg./CLr))*(exp(0.6*rhos*g*CDg*Sto./WL))))*550;
%RATE OF CLIMB
rho_climb=rho;LDmax=18;
PL_roc=1./((ROC_max/(60*np))+(sqrt(2*WL./(rho_climb*sqrt(3*CD0./k)))*(1.155./(LDmax*np))))*550;
%CEILING
rho_c=0.000738;
sigma_c=rho_c/rho;
ROC_c=100/60;
PL_c=sigma_c./((ROC_c./np)+(sqrt(2*WL./(rho_c*sqrt(3*CD0./k)))*(1.155./(LDmax*np))))*550;
plot(WLs,PL_stall,'b*:',WL,PL_max,'y*--',WL,PL_to,'r^--',WL,PL_roc,'mo:',WL,PL_c,'g--o'),grid,
legend('Vstall (blue)','Vmax(yellow)','Sto(red)','ROCmax(magenta)','Ceiling(green)','location','northwest')
title('Power Loading vs Wing Loading'), xlabel('Wing Loading (N/m2)')
ylabel('Power Loading(N/W)')
end
