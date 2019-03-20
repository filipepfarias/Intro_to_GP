clear; close all;
%% dataset
ns = 20; 
x = linspace(0,1,ns)';
%y = @(x) sin(2*pi*x);
w2 = 0.5; w1 = 0.8;
y = @(x) w2*x + w1;
e = .2*randn(size(x));
t = y(x) + e;

%% prior
M = 2;
MuPrior = zeros(1,M)'; SigmaPrior = eye(M); beta = 100;

phi = @(x)(bsxfun(@power,x,0:M-1)); % Phi function
phix = phi(x); % design matrix
f1 = figure('Position',[0 100 500 400]); f2 = figure('Position',[501 100 500 400]);
f3 = figure;


for i=1:length(t)
    if i == 1
        x1 = -2:.005:2; x2 = x1;
        [X1,X2] = meshgrid(x1,x2);
        F = mvnpdf([X1(:) X2(:)],MuPrior',inv(SigmaPrior));
        F = reshape(F,length(x2),length(x1));
        figure(f2); clf; imagesc(x1,x2,F);set(gca,'YDir','normal'); hold on; plot(w1,w2,'w+','LineWidth',1.5);
    end
    
    SigmaPost = SigmaPrior + beta*(phix(1:i,:)'*phix(1:i,:));
    MuPost = SigmaPost\(SigmaPrior\MuPrior + beta*phix(1:i,:)'*t(1:i));
    MuPrior = MuPost;

    W = mvnrnd(MuPost',inv(SigmaPost),10);
    
    xx = linspace(0,1,100);
    yt = W(:,2)*xx + W(:,1);
    figure(f1); clf;
    plot(xx,yt); hold on; plot(x(1:i),t(1:i),'o'); xlim([0 1]); ylim([0 2]);pause(0.5);
    
    F = mvnpdf([X1(:) X2(:)],MuPost',inv(SigmaPost));
    F = reshape(F,length(x2),length(x1));
    figure(f2); clf; imagesc(x1,x2,F);set(gca,'YDir','normal'); hold on; plot(w1,w2,'w+','LineWidth',1.5);
    %figure(f3); imagesc(phix'*phix);
end