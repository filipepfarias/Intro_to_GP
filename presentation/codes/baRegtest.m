%% figure colors
% the standard gauss plot, using the nonlinear dataset
% Philipp Hennig, 11 Dec 2012
dgr = [239,125,45]/255-20/255; % color [0,125,122]
dre = [119,154,171]/255-50/255; % color [130,0,0]
lightdgr = [1,1,1] - 0.5 * ([1,1,1] - dgr);
lightdre = [1,1,1] - 0.5 * ([1,1,1] - dre);
dgr2white = bsxfun(@minus,[1,1,1],bsxfun(@times,(linspace(0,0.6,2024)').^0.5,[1,1,1]-dgr));
dre2white = bsxfun(@minus,[1,1,1],bsxfun(@times,(linspace(0,0.6,2024)').^0.5,[1,1,1]-dre));

GaussDensity = @(y,m,v)(bsxfun(@rdivide,exp(-0.5*...
    bsxfun(@rdivide,bsxfun(@minus,y,m').^2,v'))./sqrt(2*pi),sqrt(v')));

fr = 30; % # frames
mov(fr) = struct('cdata',[],'colormap',[]);

%% prior
F = 2; % number of features
phi = @(a)(bsxfun(@power,a,0:F)); % φ(a) = [1; a]
k = @(a,b)(phi(a)' * phi(b)); % kernel
mu = @(a)(zeros(size(a,1))); % mean function

% belief on f(x)
n = 100; x = linspace(-6,6,n)'; % ‘test' points
m = mu(x);
kxx = k(x,x); % p(fx) = N(m, kxx)
s = bsxfun(@plus,m,chol(kxx + 1.0e-8 * eye(n))' * randn(n,3)); % samples from prior
stdpi = sqrt(diag(kxx)); % marginal stddev, for plotting
load('data.mat'); N = length(T); % gives Y,X,sigma


%% plot

s1 = GPanimation(n,fr);
s2 = GPanimation(n,fr);
s3 = GPanimation(n,fr);

%kxx = k(x,x); % kernel function (enter your favorite here)
V = kxx;
L = chol(V + 1.0e-5 * eye(size(V))); % jitter for numerical stability
y = linspace(-15,20,n)';
P = GaussDensity(y,m,diag(V+eps)); colormap(dgr2white);

for f = 1:fr
    clf; hold on
    imagesc(x,y,P);
    plot(x,max(min(m,20),-15),'-','Color',dgr,'LineWidth',0.7);
    plot(x,max(min(m + 2 * sqrt(diag(V)),20),-15),'-','Color',lightdgr,'LineWidth',.5);
    plot(x,max(min(m - 2 * sqrt(diag(V)),20),-15),'-','Color',lightdgr,'LineWidth',.5);
    plot(x,phi(x),'-','Color',0.3*ones(3,1));
    plot(x,m + L' * s1(:,f),'--','Color',dgr);
    plot(x,m + L' * s2(:,f),'--','Color',dgr);
    plot(x,m + L' * s3(:,f),'--','Color',dgr);
    xlim([-6,6]);
    ylim([-4,5]);
    drawnow; pause(0.02)
    mov(f) = getframe(gcf);
end


%% prior on Y = fX + 
M = mu(X);
kXX = k(X,X); % p(fX) = N(M, kXX)
G = kXX + sigma^2 * eye(N); % p(Y ) = N(M, kXX + σ
R = chol(G); % most expensive step: O(N3
kxX = k(x,X); % cov(fx, fX) = kxX
A = kxX / R; % pre-compute for re-use
mpost = m + A * (R' \ (Y-M)); % p(fx ∣Y ) = N(m + kxX(kXX + σ
vpost = kxx - A * A'; % kxx − kxX(kXX + σ
spost = bsxfun(@plus,mpost,chol(vpost + 1.0e-8 * eye(n))' * randn(n,3)); % samples
stdpo = sqrt(diag(vpost)); 