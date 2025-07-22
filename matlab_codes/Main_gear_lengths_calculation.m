Track = 34;
Land_Height = 22;
Tire_sh = 4;
Fus_sl = 8;

b = (Track-Fus_sl)/2
h = Land_Height - Tire_sh
theta = atand(b/h)
psi = 90-theta
Angle_up = 90+theta
Angle_down = 90+psi
Slant_Length = sqrt((h^2)+(b^2))