clear; close; 

no=100; nb = 100;  

f = @(x)sin(2*pi*x); 
n = 1e-1*randn(no,1);

for io = 1:no

 x = linspace(0+eps,1-eps,io)'; 
 t = f(x) + n(1:io); 

for ibb = 1:nb
 clear X   
 for ib=0:ibb-1; 
  X(1:io,ib+1) = (x.^ib); 
 end

 wh_m(1:ibb,io,ibb) = X\(t(1:io));
 wh_i(1:ibb,io,ibb) = inv(X'*X)*X'*t(1:io);
 wh_p(1:ibb,io,ibb) = pinv(X)*t(1:io);

 yh_m(1:io,io,ibb) = X*wh_m(1:ibb,io,ibb); 
 yh_i(1:io,io,ibb) = X*wh_i(1:ibb,io,ibb);
 yh_p(1:io,io,ibb) = X*wh_p(1:ibb,io,ibb);

 e_m(io,ibb) = sqrt(mean((squeeze(yh_m(1:io,io,ibb))-t(1:io)).^2));
 e_i(io,ibb) = sqrt(mean((squeeze(yh_i(1:io,io,ibb))-t(1:io)).^2));
 e_p(io,ibb) = sqrt(mean((squeeze(yh_p(1:io,io,ibb))-t(1:io)).^2));

 subplot(3,1,1); fplot(f,[0 1]); hold; plot(x,yh_p(1:io,io,ibb),'.'); plot(x,t,'o'); hold
 subplot(3,1,2); fplot(f,[0 1]); hold; plot(x,yh_m(1:io,io,ibb),'.'); plot(x,t,'o'); hold
 subplot(3,1,3); fplot(f,[0 1]); hold; plot(x,yh_i(1:io,io,ibb),'.'); plot(x,t,'o'); hold
 drawnow
 [io ibb];
end
end