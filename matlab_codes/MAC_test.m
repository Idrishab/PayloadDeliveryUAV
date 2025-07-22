S = 0.02; % Area (m^2)
b = 0.173; % Span (m)
lambda = 0.75; % Taper ratio
y = 0.07025; % Chord location on y-axis from root(m)
MAC = 0.0968; % Mean Aerodynamic Chord
Croot = 0.131; % Root chord
ac_loc = 25; % Aerodynamic centre location on  MAC (%)

c = (2*S/(b*(1+lambda)))*(1-(2*(1-lambda)*abs(y)/b)) % chord (m)

% MAC Location across the span
y = (1-(MAC*b*(1+lambda)/(2*S)))*b/(2*(1-lambda))

ac_loc_on_Croot = Croot - MAC + (ac_loc*MAC/100)