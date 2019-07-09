% data generation
ns = 100;
mu = 0;
sigma = 0.05;

% parameters setup
alpha = 0.001;
beta = 1000;
N = 10;
phiSigma = .1^2;

[x,y] = meshgrid(linspace(0,1,ns));
z = sin(2*pi.*x).*sin(2*pi.*y);
e = normrnd(mu,sigma,size(x));
t = z + e;

MuN = [0.0 0.0]';
Sigma0 = (1/alpha)*eye(N); Sigma0i = inv(Sigma0);
SigmaNi = Sigma0i;

% generating means
MuA = [unifrnd(0,1,[10,2]) zeros([N,1])];

% sqrt(abs(MuA(ii,1)-x).^2+abs(MuA(ii,2)-y).^2);

% Kernel function
phi = @(x,me,sd) inv(sd*sqrt(2*pi))*exp(-0.5*(abs(MuA(ii,1)-x).^2 ...
+abs(MuA(ii,2)-y).^2)/sd^2);