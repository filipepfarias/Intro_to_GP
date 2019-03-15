clear; close all; warning('off','all');

n = 10; 
x = linspace(0,1,n)';
y = sin(2*pi*x);
e = .2*randn(size(x));
t = y + e;

figure;
for M = 1:20
    plot(x,t,'o');
    phi = @(a)(bsxfun(@power,a,0:M-1));
    phix = phi(x);
    
    W = ((phix'*phix)\phix')*t;
    
    hold on;
    Xp = linspace(x(1),x(end),200)';
    phiXp = phi(Xp); Tp = phiXp*W;
    plot(Xp,Tp); axis([0 1 min(t) max(t)]);
    hold off; pause(0.5);
end
warning('on','all')
