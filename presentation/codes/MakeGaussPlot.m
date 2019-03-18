function FR = MakeGaussPlot()
% the standard gauss plot, using the nonlinear dataset
% Philipp Hennig, 11 Dec 2012
dgr = [0,0.4717,0.4604]; % color [0,125,122]
dre = [0.4906,0,0]; % color [130,0,0]
lightdgr = [1,1,1] - 0.5 * ([1,1,1] - dgr);
lightdre = [1,1,1] - 0.5 * ([1,1,1] - dre);
dgr2white = bsxfun(@minus,[1,1,1],bsxfun(@times,(linspace(0,0.6,2024)').^0.5,[1,1,1]-dgr));
dre2white = bsxfun(@minus,[1,1,1],bsxfun(@times,(linspace(0,0.6,2024)').^0.5,[1,1,1]-dre));

M = 150; % # dimensions
F = 30; % # frames
x = linspace(-8,8,M)';
s1 = GPanimation(M,F);
s2 = GPanimation(M,F);
s3 = GPanimation(M,F);

GaussDensity = @(y,m,v)(bsxfun(@rdivide,exp(-0.5*...
    bsxfun(@rdivide,bsxfun(@minus,y,m').^2,v'))./sqrt(2*pi),sqrt(v')));
%% prior
phi = @(a)(bsxfun(@power,a,[0:7]));
k = @(a,b)(phi(a)*phi(b)');
kxx = k(x,x); % kernel function (enter your favorite here)
m = zeros(M,1);
V = kxx;
L = chol(V + 1.0e-2 * eye(M)); % jitter for numerical stability
y = linspace(-15,20,250)';
P = GaussDensity(y,m,diag(V+eps)); colormap(dgr2white);
for f = 1:F
    clf; hold on
    imagesc(x,y,P);
    plot(x,max(min(m,20),-15),'-','Color',dgr,'LineWidth',0.7);
    plot(x,max(min(m + 2 * sqrt(diag(V)),20),-15),'-','Color',lightdgr,'LineWidth',.5);
    plot(x,max(min(m - 2 * sqrt(diag(V)),20),-15),'-','Color',lightdgr,'LineWidth',.5);
    %if nargin > 1
         plot(x,phi(x),'-','Color',0.7*ones(3,1));
    %end
     plot(x,m + L' * s1(:,f),'--','Color',dgr);
     plot(x,m + L' * s2(:,f),'--','Color',dgr);
     plot(x,m + L' * s3(:,f),'--','Color',dgr);
    xlim([-8,8]);
    ylim([-14.99,19.99]);
    pause(0.1);
%    FR(f) = getframe;
end