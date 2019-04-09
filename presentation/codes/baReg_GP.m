clear; close all;

%% plot colors
dgr = [0,0.4717,0.4604]; % color [0,125,122]
dre = [0.4906,0,0]; % color [130,0,0]
lightdgr = [1,1,1] - 0.5 * ([1,1,1] - dgr);
lightdre = [1,1,1] - 0.5 * ([1,1,1] - dre);
dgr2white = bsxfun(@minus,[1,1,1],bsxfun(@times,(linspace(0,0.6,2024)').^0.5,[1,1,1]-dgr));
dre2white = bsxfun(@minus,[1,1,1],bsxfun(@times,(linspace(0,0.6,2024)').^0.5,[1,1,1]-dre));

%% dataset
ns = 20; 
x = linspace(0,1,ns)';
%y = @(x) sin(2*pi*x);
w2 = 0.5; w1 = 0.8;
y = @(x) w2*x + w1;
e = .2*randn(size(x));
t = y(x) + e;
gaussmf = @(x,params) (exp(-(x-params(2)).^2/(2*params(1))));

%% prior
M = 2;
alpha = .1;
beta = 1/.01;

MuPrior = zeros(1,M)'; SigmaPrior = alpha\eye(M);

phi = @(x)(bsxfun(@power,x,0:M-1)); % Phi function
phix = phi(x); % design matrix
%f1 = figure('units','normalized','outerposition',[0 0 1 1]);% f2 = figure('Position',[501 100 500 400]);
f1 = figure;% f2 = figure('Position',[501 100 500 400]);
pbaspect([1 1 1]);
%f3 = figure;
fr = 30;
s1 = .3*GPanimation(2,fr); s2 = .3*GPanimation(2,fr); s3 = .3*GPanimation(2,fr);

for f = 1:fr
    for i=1:1
        clf;
        if i == 1
            x1 = -2:.005:2; x2 = x1;
            [X1,X2] = meshgrid(x1,x2);
            F = mvnpdf([X1(:) X2(:)],MuPrior',inv(SigmaPrior));
            F = reshape(F,length(x2),length(x1));
            %figure(f2); clf;
            
            L = chol(SigmaPrior);
            W1 = MuPrior + L'*s1(:,f);
            W2 = MuPrior + L'*s2(:,f);
            W3 = MuPrior + L'*s3(:,f);
            
            subplot(1,4,1); imagesc(x1,x2,F); colormap(dgr2white); set(gca,'YDir','normal'); 
            hold on; plot(w1,w2,'r+','LineWidth',1.5);
            hold on; plot(W1(1,1),W1(2,1),'.r','LineWidth',1.5); 
            hold on; plot(W2(1,1),W2(2,1),'.r','LineWidth',1.5); 
            hold on; plot(W3(1,1),W3(2,1),'.r','LineWidth',1.5); 
            pbaspect([1 1 1]);
            
            xx = linspace(0,1,100);
            yt1 = W1(1,1)*xx + W1(2,1);
            yt2 = W2(1,1)*xx + W2(2,1);
            yt3 = W3(1,1)*xx + W3(2,1);
            
            %figure(f1); clf;
            subplot(1,4,4); plot(xx,yt1); hold on; plot(xx,yt2); hold on; 
            plot(xx,yt3); hold on; plot(xx,y(xx),'r--','LineWidth',1); title('Predicted'); xlim([0 1]); ylim([0 2]);
            pbaspect([1 1 1]);
        end
        
        %     if i ~= 1
        %         F = mvnpdf([X1(:) X2(:)],MuPost',inv(SigmaPost));
        %         F = reshape(F,length(x2),length(x1));
        %         %figure(f2); clf;
        %         subplot(1,4,1); imagesc(x1,x2,F); set(gca,'YDir','normal'); hold on; plot(w1,w2,'w+','LineWidth',1.5);
        %         pbaspect([1 1 1]);title('Prior');
        %         %figure(f3); clf;
        %     end
        %
        %     SigmaPost = SigmaPrior + beta*(phix(1:i,:)'*phix(1:i,:));
        %     MuPost = SigmaPost\(SigmaPrior\MuPrior + beta*phix(1:i,:)'*t(1:i));
        %     MuPrior = MuPost;
        %
        %     W = mvnrnd(MuPost',inv(SigmaPost),10);
        %
        %     xx = linspace(0,1,100);
        %     yt = W(:,2)*xx + W(:,1);
        %     %figure(f1); clf;
        %     subplot(1,4,4); plot(xx,yt); hold on; plot(xx,y(xx),'r--','LineWidth',1); hold on; plot(x(1:i),t(1:i),'o'); xlim([0 1]); ylim([0 2]);
        %     pbaspect([1 1 1]); title('Predicted');
        %
        %     F = mvnpdf([X1(:) X2(:)],MuPost',inv(SigmaPost));
        %     F = reshape(F,length(x2),length(x1));
        %     %figure(f2); clf;
        %     subplot(1,4,3); imagesc(x1,x2,F); set(gca,'YDir','normal'); hold on; plot(w1,w2,'w+','LineWidth',1.5);
        %     pbaspect([1 1 1]);title('Posterior');
        %     %figure(f3); clf;
    end
    pause(0.05);
end