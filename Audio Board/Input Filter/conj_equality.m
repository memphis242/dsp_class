function [eql] = conj_equality(z1,z2)

if abs(real(z1)-real(z2))<=1e-3 && abs(imag(z1)+imag(z2))<=1e-3
    eql = 1;
else
    eql = 0;
end

end

