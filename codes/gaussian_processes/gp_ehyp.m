function e = gp_ehyp(x,xl,t,th)
    X = bsxfun(@minus,x,xl');
    K = th(1)*exp(th(1)*X.^2);
    %Ki = inv(K);
    dKdth1 = exp(X.^2*th(1));
    dKdth2 = X.^2*th(1)*exp(X.^2*th(2));
    
    e = [-.5*trace(((K\(t*t'))/K)*dKdth1);
         -.5*trace(((K\(t*t'))/K)*dKdth2)];
end