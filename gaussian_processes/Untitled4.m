
    Wml = pinv(P)*t(n);
    beta = sum(((P*Wml)-t(n))^2)^(-1);
    Paux = P.'*P;
    Sinv = alpha*eye(size(Paux)) + beta*Paux;
    m = beta*(Sinv\P.'*t(n));