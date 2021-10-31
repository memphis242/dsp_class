function [Y] = Ykk([k])

    f = @(k) 400 ./ ((pi*k).^2);
    g = @(k) (20./(pi*k)).*exp(1j*(k*(14*pi/20)+(pi/2))).*(14+1j*(20./(pi*k)));
    f1 = @(k) f(k) + g(k);
    h = @(k) (20./(pi*k)).*exp(-1j*(k*(17*pi/20)+(pi/2))).*(17-1j*(20./(pi*k)));
    f2 = @(k) h(k) - f(k);
    
    if(k~=0)
        Y_k = @(k) (-1/440)*f1(k) + (1/340)*f2(k);
        Y = Y_k(k);
    else
        Y = 0.99;
    end

end

