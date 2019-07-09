close all; clear;
N = 4; % number of components
ns = 25; % number of samples
nf = 10; % number of sampled features
alpha = 0.01; beta = 20;

x = linspace(-1+eps,1-eps,ns)';
a1 = 0.5; a2 = -0.8; a3 = 0.8; a4 = -0.2;
y = @(x) (a4*x.^3+a3*x.^2+a2*x+a1);
mu = 0;    
e = normrnd(mu,1/beta,size(x));
t = y(x) + e;

% Initial iteration: N = 0
MuN = zeros([N,1]);
Sigma0 = (1/alpha)*eye(N); Sigma0i = inv(Sigma0);
SigmaNi = Sigma0i;

% Kernel function
phi = @(x,i) x^(i-1);

xx = linspace(-1,1,100);
k = 2;

for n = 1:k:ns
    w = mvnrnd(MuN',inv(SigmaNi),nf); pause(0.1);
    
    yt = w(:,4)*xx.^3 +  w(:,3)*xx.^2 + w(:,2)*xx + w(:,1);

    plot(xx,yt,'r'); hold on; plot(x(1:k:n),t(1:k:n),'bo'); hold on;
    fplot(y,[xx(1) xx(end)],'g','LineWidth',1.5); axis square;
    xlim([-1,1]); ylim([-1,2.5]);
    hold off;
    
    P = 1:N; P = arrayfun(@(i) phi(x(n),i),P);
    
    SigmaNiPrior = SigmaNi;
    SigmaNi = SigmaNiPrior + beta*(P'*P);
    MuN = SigmaNi\(SigmaNiPrior*MuN + beta*P'*t(n));
end