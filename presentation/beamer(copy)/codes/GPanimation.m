function X = GPanimation(d,n)
% returns a matrix X of size [d,n], representing a grand circle on the
% unit d-sphere in n steps, starting at a random location. Given a kernel
% matrix K, this can be turned into a tour through the sample space, simply by
% calling chol(K)’ * X;
%
% Philipp Hennig, September 2012
x = randn(d,1); % starting sample
r = sqrt(sum(x.^2));
x = x ./ r; % project onto sphere
t = randn(d,1); % sample tangent direction
t = t - (t'*x) * x; % orthogonalise by Gram-Schmidt.
t = t ./ sqrt(sum(t.^2)); % standardise
s = linspace(0,2*pi,n+1); s = s(1:end-1); % space to span
t = bsxfun(@times,s,t); % span linspace in direction of t
X = r.* exp_map(x,t); % project onto sphere, re-scale
end

function M = exp_map (mu, E)
% Computes exponential map on a sphere
%
% many thanks to Soren Hauberg!
D = size(E,1);
theta = sqrt(sum((E.^2)));
M = mu * cos(theta) + E .* repmat(sin(theta)./theta, D, 1);
if (any (abs (theta) <= 1e-7))
for a = find (abs (theta) <= 1e-7)
M (:, a) = mu;
end % for
end % if
% M (:,abs (theta) <= 1e-7) = mu;
end % function