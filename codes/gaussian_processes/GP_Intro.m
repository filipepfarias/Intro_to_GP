% clear enviroments
close all; clear;

% generating synthetic data
N = 10; SIGMA =.3;
X = linspace(0,.7,N)';
Y = @(x) sin(2*pi*x);
ns = normrnd(0,SIGMA^2,size(X));
T = Y(X) + ns;

% GP regression

% contructing kernel
F = 200; % number of features
lambda = .1;
phi = @(x) bsxfun(@power,x,0:F); % basis function
k = @(x,xl) (sqrt(2*pi*lambda^1.5)*exp(-(4*lambda^2)\bsxfun(@minus,x,xl').^2)); % kernel
mu = @(n) zeros(size(n,1),1); % zero mean

n = 1000; x = linspace(0,1,n)';
m = mu(x);
kxx = k(x,x);
% s = bsxfun(@plus,m,chol(kxx + 1.0e-8 * eye(n))' * randn(n,3));
% stdpi = sqrt(diag(kxx));

% prior
M = mu(X);
kXX = k(X,X);
G = chol(kXX + SIGMA^2 * eye(N));

% learning
A = k(X,x)'/G;

% post
mpost = m + A * (G' \ (T-M));
vpost = kxx - A * A';
stdpost = sqrt(diag(vpost));

% plot
figure;
hold on;
plot(X,T,'o','LineWidth',1,'Color','blue');
plot(x,mpost,'-','LineWidth',1,'Color','red');
%plot(x,mpost-2*stdpost,'-','LineWidth',1,'Color','green');
%plot(x,mpost+2*stdpost,'-','LineWidth',1,'Color','green');
fill([x;flipud(x)], [mpost-2*stdpost;flipud(mpost+2*stdpost)], 'r','LineStyle','none');
alpha(.15)
fplot(Y,[0,1],'LineWidth',1,'Color','green');
hold off;
legend('Data','Post Mean','$\pm$ 2 $\times$ Post std ','f(x)=$\sin (2 \pi x)$','Interpreter','latex');
xlim([-.02 1.02]); ylim([-1.5 1.5]);
