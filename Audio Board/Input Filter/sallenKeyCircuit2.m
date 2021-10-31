function [Q, wn, alpha, zeta] = sallenKeyCircuit2(poles)
% Inputs
%   poles   --> Poles of 2nd order filter stage --> Assumed to be conjugate
%               pairs!!
% Outputs
%   Q       --> Quality factor
%   zeta    --> Filter natural frequency
%   alpha   --> Quality factor
%   wn      --> Damping factor

th = pi - angle(poles(1));
zeta = cos(th);
Q = 1/(2*zeta);
wn = abs(poles(1));
alpha = wn/(2*Q);

end

