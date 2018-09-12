clear all, close all

no =1e3;
X = linspace(0,1,no);
X = X';
Y = sin(2*pi*X) + (0.0)*exp(X.^0.75) + 0*X;
e = 0.1.*randn(1,no);
e = e';
t = Y + e;

m = 3;
mu = [0:m];

mu = mu';

for i=1:numel(mu); f(:,i) = f_phi(X,mu(i)); mu(i); end

rank(f'*f)

w = t\f;

%w = inv(f'*f)*f'*t;

y_hat = w*f';

plot(X,y_hat)
hold on
plot(X,t)
hold on
plot(X,Y)
legend('Prediction','Function','Data')

figure();
plot(X,f)

