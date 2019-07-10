close all; clear;

% Generating data
ns = 10; % samples
sigma2_n = 0.25; % standard deviation

x = linspace(0,1,100);
f = sin(2*pi*x);
e = sigma2_n*randn(size(x));
y = f + e;

