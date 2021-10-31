function [poles, wn,Q,zeta,systf] = sallenKeyCircuit(R1,R2,C1,C2)
% Inputs
%   R1 --> First resistor from left
%   R2 --> Resistor between R1 and non-inverting input of op-amp
%   C1 --> Cap between non-inverting input and ground
%   C2 --> Feedback cap
% Outputs
%   poles   --> Filter poles in Hz
%   wn      --> Filter natural frequency
%   Q       --> Quality factor
%   zeta    --> Damping factor
%   systf   --> System transfer function

wn = 1/sqrt(R1*R2*C1*C2);
alpha = 0.5*(1/C1)*(1/R1 + 1/R2);
Q = wn / (2*alpha);
zeta = 1/(2*Q);
num = wn^2;
den = [1, 2*alpha, wn^2];
systf = tf(num,den);
poles = eig(systf)/(2*pi);

end

