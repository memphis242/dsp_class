function [Hd] = generate_Hd(Omk,freqs,gain)
Hd = interp1(freqs, gain, Omk, 'spline');
end

