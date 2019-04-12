clear; close all;

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

%% data generation
ns = 20; [X1,X2] = meshgrid(linspace(-4,4,ns),linspace(-4,4,ns));
Y = @(X1,X2) 10*sin(.25*pi*X1).*sin(.25*pi*X2);
%w2 = 2.5; w1 = 0.8;
%Y = @(X) w2*X + w1;

sigma = 2.5;
e = (1/sigma^2)*randn(size(X1));
T = Y(X1,X2);

X = [X1(:) X2(:)];
T = T(:);

%load('data.mat');
N = length(T); % gives T,X,sigma

%% prior on w
F = 4; % number of features
phi = @(a)(bsxfun(@power,a(:,1),[0:F-1])+bsxfun(@power,a(:,2),[0:F-1]));
mu = zeros(F,1);
Sigma = eye(F); % p(w) = N(µ, Σ)

%% prior on f(x)
n = 70; [x1,x2] = meshgrid(linspace(-4,4,n),linspace(-4,4,n));
x = [x1(:) x2(:)]; % ‘test’ points
phix = phi(x); % features of x
m = phix * mu;
kxx = phix * Sigma * phix'; % p(fx) = N(m, kxx)
%s = bsxfun(@plus,m,chol(kxx + 1.0e-5 * eye(n))' * randn(n,3)); % samples from prior
stdpi = sqrt(diag(kxx)); % marginal stddev, for plotting prior

%% plot

s1 = GPanimation(n^2,fr);

V = kxx; 
L = chol(V + 1.0e-5 * eye(size(V))); % jitter for numerical stability
m3 = reshape(m,size(x1));
std3 = sqrt(diag(V)); std3 = reshape(std3,size(m3));

close all;
for f = 1:fr
    clf; hold on
    %imagesc(x,y,P);
    %plot(x,max(min(m,20),-15),'-','Color',dgr,'LineWidth',0.7);
    surf(x1,x2,max(min(m3 + 2 * std3,200),-200),'FaceLighting','gouraud',...
        'FaceColor',lightdgr,'EdgeColor',dgr,'EdgeLighting','gouraud',...
        'FaceAlpha',.3,'EdgeColor','none');
    surf(x1,x2,max(min(m3 - 2 * std3,200),-200),'FaceLighting','gouraud',...
        'FaceColor',lightdgr,'EdgeColor',dgr,'EdgeLighting','gouraud',...
        'FaceAlpha',.3,'EdgeColor','none');
    %plot(x,phi(x),'-','Color',0.3*ones(3,1));
    ys1 = m + L' * s1(:,f); ys1 = reshape(ys1,size(x1));
    surf(x1,x2,ys1,'FaceLighting','gouraud','FaceColor',lightdgr,...
        'EdgeColor',dgr,'EdgeLighting','gouraud','EdgeAlpha',.5);
    light('Position',[-1 0 5],'Style','infinite'); material dull; view(3);
    %plot(x,m + L' * s2(:,f),'--','Color',dgr);
    %plot(x,m + L' * s3(:,f),'--','Color',dgr);
    %xlim([-6,6]);
    zlim([-10,10]);
    drawnow; pause(0.02)
end

%% prior on Y = fX + e
phiX = phi(X); % features of data
M = phiX * mu;
kXX = phiX * Sigma * phiX'; % p(fX) = N(M, kXX)
G = kXX + sigma^2 * eye(N); % p(T) = N(M, kXX + σ²I)
R = chol(G); % most expensive step: O(N³)
kxX = phix * Sigma * phiX'; % cov(fx, fX) = kxX
A = kxX / R; % pre-compute for re-use
mpost = m + A * (R' \ (T-M)); % p(fx ∣ T ) = N(m + kxX(kXX + σ²I)^{−1} (T − M),
vpost = kxx - A * A'; % kxx − kxX(kXX + σ²I)^{−1}kXx)
%spost = bsxfun(@plus,mpost,chol(vpost + 1.0e-5 * eye(n))' * randn(n,3)); % samples
%stdpo = sqrt(diag(vpost)); % marginal stddev, for plotting

close all;

V = vpost; clear kxX vpost kxx;
L = chol(V + 1.0e-5 * eye(size(V))); % jitter for numerical stability
m3 = reshape(mpost,size(x1));
std3 = sqrt(diag(V)); std3 = reshape(std3,size(m3));

close all;
for f = 1:fr
    clf; hold on;
    surf(x1,x2,max(min(m3 + 2 * std3,200),-200),'FaceLighting',...
        'gouraud','FaceColor',lightdgr,'EdgeColor',dgr,'EdgeLighting',...
        'gouraud','FaceAlpha',.3,'EdgeColor','none');
    surf(x1,x2,max(min(m3 - 2 * std3,200),-200),'FaceLighting',...
        'gouraud','FaceColor',lightdgr,'EdgeColor',dgr,'EdgeLighting',...
        'gouraud','FaceAlpha',.3,'EdgeColor','none');
    ys1 = m + L' * s1(:,f); ys1 = reshape(ys1,size(x1));
    surf(x1,x2,ys1,'FaceLighting','gouraud','FaceColor',lightdgr,...
        'EdgeColor',dgr,'EdgeLighting','gouraud','EdgeAlpha',.5);
    light('Position',[-1 0 5],'Style','infinite'); material dull; view(3);
    zlim([-2,2]);
    plot3(X1,X2,Y(X1,X2) + e,'bo');
    drawnow; pause(0.02)
end
