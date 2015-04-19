function M = mean_stein_2(X1,X2,w)

w1 = w;
w2 = 1-w;
[u,L] = eig(X1);
g = u*sqrt(L);
invg = inv(g);
P = invg*X2*invg';
P = abs(P);

I = eye(size(X1));
M = g*(MtrxSqrt(P + (w2-w1)^2/4*(I-P)*(I-P)) - (w2-w1)/2*(I-P))*g';
M = abs(M);

end