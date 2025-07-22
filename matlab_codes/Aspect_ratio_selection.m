AR = 4.667; S= 0.182; e=0.825; CD0=0.035;
b = sqrt(AR*S)
C = S/b
Cl_alfa=6.0176; % Airfoil lift curve slope
CL_alfa = Cl_alfa/(1+(Cl_alfa/(3.142*AR)))% Wing lift curve slope
K=1/(3.142*e*AR);
LDmax=1/(2*sqrt(K*CD0));

tmax = 0.08;
Clalfa=(1.8*3.142)*(1+(0.8*tmax)); % lift curve slope (rad)