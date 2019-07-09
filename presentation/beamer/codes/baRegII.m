clear; close all;
%% dataset
ns = 20; 
x = linspace(0,1,ns)';
%y = @(x) sin(2*pi*x);
w1 = 0.2 ;w2 = 0.8; w3 = 1.2;
y = @(x) w3*x.^2 + w2*x + w1;
e = .05*randn(size(x));
t = y(x) + e;

%% prior
M = 3;
alpha = .1;
beta = 1/.01;

MuPrior = zeros(1,M)'; SigmaPrior = alpha\eye(M);

phi = @(x)(bsxfun(@power,x,0:M-1)); % Phi function
phix = phi(x); % design matrix
f1 = figure('units','normalized','outerposition',[0 0 1 1]);% f2 = figure('Position',[501 100 500 400]);
pbaspect([1 1 1]);
%f3 = figure;

for i=1:length(t)
    clf;
    if i == 1
        x1 = w1-1:.02:w1+1; x2 = w2-1:.02:w2+1; x3 = w3-1:.02:w3+1;
        [X1,X2,X3] = meshgrid(x1,x2,x3);
        F = mvnpdf([X1(:) X2(:) X3(:)],MuPrior',inv(SigmaPrior));
        F = reshape(F,length(x3),length(x2),length(x1));
        %figure(f2); clf;
        subplot(2,3,1);sl = slice(X1,X2,X3,F,w1,w2,w3); set(sl,'Edgecolor','none'); set(sl,'Edgecolor','none'); view([1 1 -1]);set(gca,'YDir','normal','ZDir','normal'); hold on; plot3(w1,w2,w3,'w+','LineWidth',1.5);
        W = mvnrnd(MuPrior',inv(SigmaPrior),10); pbaspect([1 1 1]); title('Prior'); 
        
        xx = linspace(0,1,100);
        yt = W(:,2)*xx + W(:,1);
        %figure(f1); clf;
        subplot(2,3,6); plot(xx,yt); hold on; plot(xx,y(xx),'r--','LineWidth',1); title('Predicted'); xlim([0 1]); ylim([0 2]);
        pbaspect([1 1 1]); pause;
    end
    
    if i ~= 1
        F = mvnpdf([X1(:) X2(:) X3(:)],MuPost',inv(SigmaPost));
        F = reshape(F,length(x3),length(x2),length(x1));
        %figure(f2); clf;
        subplot(2,3,1); sl1 = slice(X1,X2,X3,F,w1,w2,w3); set(sl1,'Edgecolor','none'); view([1 1 -1]); set(gca,'YDir','normal','ZDir','normal'); hold on; plot3(w1,w2,w3,'w+','LineWidth',1.5);
        pbaspect([1 1 1]);title('Prior');
        %figure(f3); clf;
    end
    
    SigmaPost = SigmaPrior + beta*(phix(1:i,:)'*phix(1:i,:));
    MuPost = SigmaPost\(SigmaPrior\MuPrior + beta*phix(1:i,:)'*t(1:i));
    MuPrior = MuPost;

    W = mvnrnd(MuPost',inv(SigmaPost),10);
    
    xx = linspace(0,1,100);
    yt = W(:,3)*xx.^2 + W(:,2)*xx + W(:,1);
    %figure(f1); clf;
    subplot(2,3,6); plot(xx,yt); hold on; plot(xx,y(xx),'r--','LineWidth',1); hold on; plot(x(1:i),t(1:i),'o'); xlim([0 1]); ylim([0 2]);
    pbaspect([1 1 1]); title('Predicted');
    
    F = mvnpdf([X1(:) X2(:) X3(:)],MuPost',inv(SigmaPost));
    F = reshape(F,length(x3),length(x2),length(x1));
    %figure(f2); clf;
    subplot(2,3,5); sl2 = slice(X1,X2,X3,F,w1,w2,w3); set(sl2,'Edgecolor','none'); view([1 1 -1]); set(gca,'YDir','normal','ZDir','normal'); hold on; plot3(w1,w2,w3,'w+','LineWidth',1.5); 
    pbaspect([1 1 1]);title('Posterior');
    %figure(f3); clf; 
    
    lkhd = [X1(:) X2(:) X3(:)]*phix(i,:)'; lkhd = (sqrt(2*pi)*beta)\gaussmf(lkhd(:),[1 t(i)]);
    lkhd = reshape(lkhd,length(x3),length(x2),length(x1));
    subplot(2,3,4); sl3 = slice(X1,X2,X3,lkhd,w1,w2,w3); set(sl3,'Edgecolor','none'); view([1 1 -1]); set(gca,'YDir','normal','ZDir','normal'); hold on; plot3(w1,w2,w3,'r+','LineWidth',1.5);
    pbaspect([1 1 1]); title('Likelihood'); pause(0.5);
    
    if i == 1
        pause;
    end
end