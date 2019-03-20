%% dataset
ns = 20; 
x = linspace(0,1,ns)';
y = @(x) sin(2*pi*x);
e = .2*randn(size(x));
t = y(x) + e;

%% prior
M = 2;
MuPrior = zeros(1,M)'; SigmaPrior = eye(M); beta = 1;

phi = @(x)(bsxfun(@power,x,0:M-1)); % Phi function
phix = phi(x); % design matrix

SigmaPost = SigmaPrior;
MuPost = SigmaPost\(SigmaPrior\MuPrior+ beta*phix'*t);
SigmaPost = SigmaPrior + beta*(phix'*phix);
