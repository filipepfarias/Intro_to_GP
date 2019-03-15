clear; close all;

n = 10;
x = linspace(0,1,n)';
y = sin(2*pi*x);
e = .2*randn(size(x));
t = y + e;

%plot(x,t,'o');
M = 5;
phi = @(a)(bsxfun(@power,a,0:M-1));
phix = phi(x);

W = ((phix'*phix)\phix')*t;

