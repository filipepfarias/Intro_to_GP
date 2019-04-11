ns = 17; X = linspace(-4,4,ns)';
%Y = @(X) 10*sin(.2*pi*X);
w2 = 2.5; w1 = 0.8;
Y = @(X) w2*X + w1;

s = 3;
e = s*randn(size(X));
T = Y(X) + e;
sigma = .5;
plot(X,T,'bo')
save('data.mat','X','T','sigma')