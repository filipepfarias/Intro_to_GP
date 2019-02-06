% This script accompanishes the presentation 'Introduction to Gaussian
% Processes'

clear; close all;

% Generating data
ns = 100; % number of samples
mu = 0; % mean of samples
sigma = 0.5^2; % variance of samples

x = linspace(0,1,ns)';
y = sin(2*pi*x);
e = normrnd(mu, sigma, size(y));
t = y + e;

% Defining the kernel function
poly = @(x,i) x^(i-1);

% Declaring E_rms
E_rms = [];
figure();
% Constructing the design Phi matrix
for M = 1:ns
    phi = zeros([ns,M]);

    for k = 1:M
        for j = 1:ns
            phi(j,k) = poly(x(j),k);
        end
    end

    % Training the model
    w = pinv(phi)*t;
    y_hat = phi*w;

    % Metrics
    w_norm = norm(w);
    aux = sqrt(sum((y_hat - t).^2)/ns);
    E_rms = [E_rms aux];

    
    plot(x,y); hold on;
    plot(x,t, 'o'); hold on;
    p1 = plot(x,y_hat, '--r'); hold off;
    legend('$y = \sin (2 \pi x)$','$\mathcal{D} \sim y + \mathcal{N}(0,0.5^2)\}$','Predicted','Interpreter','latex');
    xlabel('x','Interpreter','latex');
    ylabel('y','Interpreter','latex');
    title(['M = ',num2str(M),' $|$ ','$||w||$ = ',num2str(w_norm,'%.4e')],'Interpreter','latex');
    pause(0.1);
    
    if M == 1 || M == 2 || M == 5 || M == 10 || M == 50 || M == 100
        filen = [mfilename,'_M',num2str(M)];
        print(filen,'-depsc');
    end
    if M ~= 100
        delete(p1);
    end
end
figure();
plot(linspace(0,100,100),E_rms,'o-');
xlabel('M','Interpreter','latex');
ylabel('$E_{rms}$','Interpreter','latex')
filen = [mfilename,'_Erms']; print(filen,'-depsc');
