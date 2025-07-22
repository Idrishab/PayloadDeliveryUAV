x=150;
x0=0; y0=1;
x1=5791; y1=0.5511;
x2=6096; y2=0.5328;
L0=((x-x1)*(x-x2))/((x0-x1)*(x0-x2));
L1=((x-x0)*(x-x2))/((x1-x0)*(x1-x2));
L2=((x-x0)*(x-x1))/((x2-x0)*(x2-x1));
y=(L0*y0)+(L1*y1)+(L2*y2);
Sigma=y;
Relative_density = Sigma
Air_Density_at_that_altitude=y*1.225