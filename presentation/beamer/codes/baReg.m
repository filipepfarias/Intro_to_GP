clear; close all;
% mkdir([mfilename,'/']);
%% figure colors
% the standard gauss plot, using the nonlinear dataset
% Philipp Hennig, 11 Dec 2012
dgr = [239,125,45]/255-20/255; % color [0,125,122]
dre = [119,154,171]/255-50/255; % color [130,0,0]
lightdgr = [1,1,1] - 0.5 * ([1,1,1] - dgr);
lightdre = [1,1,1] - 0.5 * ([1,1,1] - dre);
dgr2white = bsxfun(@minus,[1,1,1],bsxfun(@times,(linspace(0,.6,2024)').^0.5,[1,1,1]-dgr));
dre2white = bsxfun(@minus,[1,1,1],bsxfun(@times,(linspace(0,.6,2024)').^0.5,[1,1,1]-dre));

%% dataset
ns = 20; 
x = linspace(0,1,ns)';
%y = @(x) sin(2*pi*x);
w2 = 0.5; w1 = 0.8;
y = @(x) w2*x + w1;
e = .2*randn(size(x));
t = y(x) + e;
gaussmf = @(x,params) (exp(-(x-params(2)).^2/(2*params(1))));

style = ['scale=0.075\linewidth,'...
                       'legend style={nodes={scale=0.5, transform shape}},',...
                       ];                  
%% prior
M = 2;
alpha = .1;
beta = 1/.01;

MuPrior = zeros(1,M)'; SigmaPrior = alpha\eye(M);

phi = @(x)(bsxfun(@power,x,0:M-1)); % Phi function
phix = phi(x); % design matrix
%f1 = figure('units','normalized','outerposition',[0 0 1 1]);% f2 = figure('Position',[501 100 500 400]);
f1 = figure; colormap(dgr2white);% f2 = figure('Position',[501 100 500 400]);
pbaspect([1 1 1]);
%f3 = figure;


for i=length(t)
    clf;
    if i == 1
        x1 = -2:.005:2; x2 = x1;
        [X1,X2] = meshgrid(x1,x2);
        F = mvnpdf([X1(:) X2(:)],MuPrior',inv(SigmaPrior));
        F = reshape(F,length(x2),length(x1));
        %figure(f2); clf;
        subplot(2,2,1); imagesc(x1,x2,F);set(gca,'YDir','normal'); hold on; plot(w1,w2,'+',...
            'LineWidth',1.5,'Color',dgr);
        W = mvnrnd(MuPrior',inv(SigmaPrior),10); pbaspect([1 1 1]); title('Prior'); 
        
        xx = linspace(0,1,100);
        yt = W(:,2)*xx + W(:,1);
        %figure(f1); clf;
        subplot(2,2,4); plot(xx,yt,'Color',dgr); hold on; plot(xx,y(xx),'r','LineWidth',1); title('Predicted'); xlim([0 1]); ylim([0 2]);
        pbaspect([1 1 1]); pause;
        set(gcf,'Units','inches');
        screenposition = get(gcf,'Position');
        set(gcf,...
            'PaperPosition',2*[0 0 2 2],...
            'PaperSize',2*[2 2]);
%         print([mfilename,'/',mfilename,'_','frame_',num2str(0)],'-dpdf');
    end
    
    if i == 1
        F = mvnpdf([X1(:) X2(:)],MuPost',inv(SigmaPost));
        F = reshape(F,length(x2),length(x1));
        %figure(f2); clf;
        subplot(2,2,1); imagesc(x1,x2,F); set(gca,'YDir','normal'); hold on; plot(w1,w2,'+',...
            'LineWidth',1.5,'Color',dgr);
        pbaspect([1 1 1]);title('Prior');
        %figure(f3); clf;
    end
    
    SigmaPost = SigmaPrior + beta*(phix(1:i,:)'*phix(1:i,:));
    MuPost = SigmaPost\(SigmaPrior\MuPrior + beta*phix(1:i,:)'*t(1:i));
    MuPrior = MuPost;

    W = mvnrnd(MuPost',inv(SigmaPost),10);
    
    xx = linspace(0,1,100);
    yt = W(:,2)*xx + W(:,1);
    %figure(f1); clf;
    subplot(2,2,4); plot(xx,yt,'Color',dgr); hold on; plot(xx,y(xx),'r','LineWidth',1); hold on; plot(x(1:i),t(1:i),'bo'); xlim([0 1]); ylim([0 2]);
    pbaspect([1 1 1]); title('Predicted');
    
    F = mvnpdf([X1(:) X2(:)],MuPost',inv(SigmaPost));
    F = reshape(F,length(x2),length(x1));
    %figure(f2); clf;
    subplot(2,2,3); imagesc(x1,x2,F); set(gca,'YDir','normal'); hold on; plot(w1,w2,'+',...
            'LineWidth',1.5,'Color',dgr);
    pbaspect([1 1 1]);title('Posterior');
    %figure(f3); clf; 
    
    lkhd = [X1(:) X2(:)]*phix(i,:)'; lkhd = (sqrt(2*pi)*beta)\gaussmf(lkhd(:),[1 t(i)]);
    lkhd = reshape(lkhd,length(x2),length(x1));
    subplot(2,2,2); imagesc(x1,x2,lkhd); set(gca,'YDir','normal'); hold on; plot(w1,w2,'w+','LineWidth',1.5);
    pbaspect([1 1 1]); title('Likelihood'); pause(0.5);
    
    if i == 1
        %pause;
    end
%     matlab2tikz([mfilename,'/',mfilename,'_','frame_',num2str(i),'.tex'],'width','0.075\linewidth',...
%         'showInfo', false,'extraaxisoptions', style);
    set(gcf,'Units','inches');
    screenposition = get(gcf,'Position');
    set(gcf,...
        'PaperPosition',2*[0 0 2 2],...
        'PaperSize',2*[2 2]);
%     print([mfilename,'/',mfilename,'_','frame_',num2str(i)],'-dpdf');
end