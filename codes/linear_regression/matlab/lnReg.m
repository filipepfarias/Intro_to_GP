close all; clear;

% Generating data
ns = 10; % samples
sigma2_n = 0.3; % standard deviation

x = linspace(0,1,ns)';
f = @(x) sin(2*pi*x); % Deterministic function
e = sigma2_n*randn(size(x)); % Noise
y = f(x) + e; % Data

% Regression
M = 20;
model = @(x,j) x.^j;
w_opt = linReg(x,model,M);
f_m = @(x)(bsxfun(model,x,0:M-1)*w_opt);

% Plot
figure();
plot(x,y,'bo'); hold on;
fplot(f,'g',[0 1]);hold on;
hold off;
legend('Data', '$f(x)=\sin(2 \pi x)$', 'Interpreter', 'latex');

function w_opt = linReg(data,model,M)
% Model: Anonymous function;
% Data: An array;

Phi = bsxfun(model,data,0:M-1);
w_opt = data*((Phi*Phi')\Phi);
end