function [x,error] = cs_ista(y,A,lambda,epsilon,itermax)
N = size(A,2) ;
error = [];
x = zeros(N,1) ;
soft = @(x, T) sign(x).*max(abs(x) - T, 0);

for i = 1:itermax
    x_pre = x;
    x = soft(x + A'*(y - A*x), lambda);
    error(i,1) = norm(x - x_pre) / norm(x) ;
    error(i,2) = norm(y-A*x) ;
    if error(i,1) < epsilon
        break;
    end
end
