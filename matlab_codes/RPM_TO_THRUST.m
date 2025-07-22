RPM=2700; %Velocity = 8.8; np = 0.5;
RPM0=3925; Thrust0=212;
RPM1=6360; Thrust1=620;
RPM2=7200; Thrust2=770;
L0=((RPM-RPM1)*(RPM-RPM2))/((RPM0-RPM1)*(RPM0-RPM2));
L1=((RPM-RPM0)*(RPM-RPM2))/((RPM1-RPM0)*(RPM1-RPM2));
L2=((RPM-RPM0)*(RPM-RPM1))/((RPM2-RPM0)*(RPM2-RPM1));
Thrust_g=(L0*Thrust0)+(L1*Thrust1)+(L2*Thrust2)
Thrust_N=Thrust_g/1000*9.81
%Power = Thrust_N * Velocity / np