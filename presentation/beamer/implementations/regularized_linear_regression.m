% This script accompanishes the presentation 'Introduction to Gaussian
% Processes'

clear; close all;

[x,y,t] = generate_data(0,1,100,0,0.5^2);

[x_train,t_train,x_test,t_test,x_valid,t_valid] = split_data(x,t);

E_rms = [];
w_key = [];

figure();

% Training the model
for M = 1:length(x_train)
    
    phi = design_matrix(x_train,M);
    
    % Training the model
    [w,y_hat_train] = train_model(phi,t_train);

    % Metrics
    w_norm = norm(w);
    aux = sqrt(sum((y_hat_train - t_train).^2)/length(x_train));
    E_rms = [E_rms aux];
    
    if M > 1 && abs(E_rms(M)- E_rms(M-1)) >= 1e-3
        M_key = M;
    end
    
    w_key = padcat(w_key, w);
    
    plot(x_train,y(1:length(x_train))); hold on;
    plot(x_train,t_train, 'o'); hold on;
    p1 = plot(x_train,y_hat_train, '--r'); hold off;
    legend('$y = \sin (2 \pi x)$','$\mathcal{D} \sim y + \mathcal{N}(0,0.5^2)\}$','Predicted','Interpreter','latex');
    xlabel('x','Interpreter','latex');
    ylabel('y','Interpreter','latex');
    title(['M = ',num2str(M),' $|$ ','$||w||$ = ',num2str(w_norm,'%.4e')],'Interpreter','latex');
    pause(0.1);
    
    if M == 1 || M == 2 || M == 5 || M == 10 || M == 50 || M == 100
        %filen = [mfilename,'_M',num2str(M)];
        %print(filen,'-depsc');
    end
    if M ~= length(x_train)
        delete(p1);
    end
end

figure();
plot(linspace(0,length(x_train),length(x_train)),E_rms,'o-');
xlabel('M','Interpreter','latex');
ylabel('$E_{rms}$','Interpreter','latex')
%filen = [mfilename,'_Erms']; print(filen,'-depsc');

pause;
close all;

E_rms_valid = [];

%x_valid = [x_train; x_valid]; t_valid = [t_train; t_valid]; 
figure();
% Training the model
for M = 1:length(x_valid)
    
    phi = design_matrix(x_valid,M);
    
    % Training the model
    y_hat_valid = phi*w_key(1:M,M);

    % Metrics
    w_norm = norm(w);
    aux = sqrt(sum((y_hat_valid - t_valid).^2)/length(x_valid));
    E_rms_valid = [E_rms_valid aux];
    
    plot(x_train,y(1:length(x_train))); hold on;
    plot(x_train,t_train, 'o'); hold on;
    p1 = plot(x_train,y_hat_train, '--r'); hold off;
    legend('$y = \sin (2 \pi x)$','$\mathcal{D} \sim y + \mathcal{N}(0,0.5^2)\}$','Predicted','Interpreter','latex');
    xlabel('x','Interpreter','latex');
    ylabel('y','Interpreter','latex');
    title(['M = ',num2str(M),' $|$ ','$||w||$ = ',num2str(w_norm,'%.4e')],'Interpreter','latex');
    pause(0.1);
    
    if M == 1 || M == 2 || M == 5 || M == 10 || M == 50 || M == 100
        %filen = [mfilename,'_M',num2str(M)];
        %print(filen,'-depsc');
    end
    if M ~= length(x_valid)
        delete(p1);
    end
end

figure();
plot(linspace(0,length(x_train),length(x_train)),E_rms,'ro-'); hold on;
plot(linspace(0,length(x_train),length(x_train)),E_rms_valid(1:length(x_train)),'o-');
legend('Train','Validation');
xlabel('M','Interpreter','latex');
ylabel('$E_{rms}$','Interpreter','latex')
%filen = [mfilename,'_Erms']; print(filen,'-depsc');


%%%%%%

function [x,y,t] = generate_data(start,final,ns,mu,sigma)
    x = linspace(start,final,ns)';
    y = sin(2*pi*x);
    e = normrnd(mu, sigma, size(y));
    t = y + e;
end

function [x_train,t_train,x_test,t_test,x_valid,t_valid] = split_data(x,t)
    s = floor(length(x)/3);
    x_train = x(1:s); t_train = t(1:s);
    x_valid = x(s+1:s*2); t_valid = t(s+1:s*2);
    x_test = x(s*2+1:end); t_test = t(s*2+1:end);
end

function arg = kernel(x,i)
    arg = x^(i-1);
end

function phi = design_matrix(x,M)
    ns = length(x);
    phi = zeros([ns,M]);
    for k = 1:M
        for j = 1:ns
            phi(j,k) = kernel(x(j),k);
        end
    end
end

function [w,y_hat] = train_model(phi,t)
    w = pinv(phi)*t;
    y_hat = phi*w;
end