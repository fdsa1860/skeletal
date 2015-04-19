function sX = MtrxSqrt(X)

X = (X+X')/2;

%[u, s] = eig(X);
[u, s, v] = svd(X);
sX = u*sqrt(s)*v';