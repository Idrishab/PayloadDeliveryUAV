
a = 0.2e-2;
b = 22e-2;
c = 2e-2;
m = 165.5e-3;
x = 6.5e-2;
y = 0;
z = 14.42e-2;

Ixx = m*((a^2)+(b^2))/6
Iyy = m*((b^2)+(c^2))/6
Izz = m*((a^2)+(c^2))/6

Ixxcg = Ixx + (m*(y^2+z^2))
Iyycg = Iyy + (m*(x^2+z^2))
Izzcg = Izz + (m*(x^2+y^2))

