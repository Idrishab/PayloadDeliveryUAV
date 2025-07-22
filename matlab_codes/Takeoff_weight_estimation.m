Wto=1;Wtoo=0; 
W_payload_and_crew=0.600; 
a=-7.22e-5; b=0.481;
iterations=0;
while abs((Wto-Wtoo)/Wto)>0.001;
    iterations=iterations+1;
    Wtoo=Wto;
    empty_ratio= (a*Wto)+b;
    Wto=(W_payload_and_crew)/(1-(empty_ratio));
end
iterations
Wto
empty_ratio
empty_weight = empty_ratio * Wto
