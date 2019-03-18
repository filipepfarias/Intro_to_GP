ns = 10; 
X = linspace(-3,3,ns)';
y = @(x) sin(0.2*pi*X);
e = randn(size(X));
Y = y(X) + e;

clearvars -except y X Y;
M = 10; % number of features
phi = @(a)(bsxfun(@power,a,0:M-1)); % φ(a) = [1; a]
mu = zeros(M,1);
Sigma = eye(M); 

n = 100; x = linspace(-6,6,n)'; % ‘test’ points
phix = phi(x); % features of x
m = phix * mu;
kxx = phix * phix'; % p(fx) = N(m, kxx)
s = bsxfun(@plus,m,chol(kxx + 1.0e-1 * eye(n))' * randn(n,3)); % samples from prior
L = chol(kxx + 1.0e-1 * eye(n));
stdpi = sqrt(diag(kxx)); % marginal stddev, for plotting

M = n; % # dimensions
F = 30; % # frames
x = linspace(-8,8,M)';
s1 = GPanimation(M,F);
s2 = GPanimation(M,F);
s3 = GPanimation(M,F);

N = length(Y); 
sigma=1;
phiX = phi(X); % features of data
M = phiX * mu;
kXX = phiX * Sigma * phiX'; % p(fX) = N(M, kXX)
G = kXX + sigma^2 * eye(N); % p(Y ) = N(M, kXX + σ

R = chol(G); % most expensive step: O(N3

kxX = phix * Sigma * phiX'; % cov(fx, fX) = kxX
A = kxX / R; % pre-compute for re-use
mpost = m + A * (R' \ (Y-M)); % p(fx ∣Y ) = N(m + kxX(kXX + σ
vpost = kxx - A * A'; % kxx − kxX(kXX + σ
lpost = chol(vpost + 1.0e-1 * eye(n));
spost = bsxfun(@plus,mpost,chol(vpost + 1.0e-1 * eye(n))' * randn(n,3)); % samples
stdpo = sqrt(diag(vpost)); % marginal stddev, for plotting

for f = 1:F
     clf; plot(X,Y,'o'); hold on;
     plot(x,mpost + lpost' * s1(:,f),'--');
     plot(x,mpost + lpost' * s2(:,f),'--');
     plot(x,mpost + lpost' * s3(:,f),'--');
    xlim([-8,8]);
    ylim([-14.99,19.99]);
    pause(0.1);
end