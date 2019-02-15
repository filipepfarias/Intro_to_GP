close all; clear;
N = 2; % number of components
ns = 10; % number of samples

x = linspace(0,1,ns).';
a1 = 0.5; a2 = 0.8;
y = a2*x+a1;
e = normrnd(0,0.02,size(x));
t = y + e;


alpha = 10;

n=1;
P = [];

SigmaNi = (alpha^(-1))*eye(N);
muN = zeros([N,1]);

int = -1:.1:1;

[W1,W2] = meshgrid(int);
F = mvnpdf([W1(:) W2(:)],muN.',SigmaNi);
F = reshape(F,length(int),length(int));
colormap(jet);
contourf(int,int,F,100,'edgecolor','none'); hold on;
axis('square')
xlabel('w_1'); ylabel('w_2');

w = mvnrnd(muN.',SigmaNi,ns);
plot(w(:,1),w(:,2),'+'); hold on; axis square;

plot(a1,a2,'ro'); axis('square','equal'); hold off;

xx = linspace(0,1,100);
yt = w(:,2)*xx + w(:,1);

% subplot(N,2,2);
figure
plot(xx,yt); axis('square');

% for n = 2:N
% keyboard

P = zeros([1,N]);

for m = 1:2
%m = 1;
    pause; close all;
    phi = @(x,i) (x^i); % "kernel" function

    for n = 1:N
        P(n) = phi(x(m),n);
    end

    Wml = pinv(P)*t(m);
    beta = (sum(((P*Wml)-t(m))^2))^(-1);

    SigmaNi = SigmaNi + beta*(P.'*P);
    muN = SigmaNi*(SigmaNi*muN + beta*P.'*t(m));

    w = mvnrnd(muN,SigmaNi,ns);

    [W1,W2] = meshgrid(min(w,[],'all')*1.05:0.01:max(w,[],'all')*1.05);

    F = mvnpdf([W1(:) W2(:)],muN.',inv(SigmaNi));
    F = reshape(F,length(W1),length(W2));

    colormap(jet);

    figure();
    contourf(W1,W2,F,100,'edgecolor','none'); hold on;
    plot(w(:,1),w(:,2),'+'); hold on;
    plot(a1,a2,'ro'); axis('square','equal'); hold off;

    xx = linspace(0,1,100);
    yt = w(:,2)*xx + w(:,1);

    figure();
    plot(xx,yt); axis('square');
    
end
       