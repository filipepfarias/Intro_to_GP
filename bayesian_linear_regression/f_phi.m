function y = f_phi(x,i)
    y=0;
    for j=0:i; y = x.^j + y; end
end