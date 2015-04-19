function X1 = steinMean(X)


n = size(X,3);
dim = size(X,1);
Y = X(:,:,1);
X0 = zeros(dim,dim);

for i=1:n
    X0 = X0 + X(:,:,i);
end
Y0 = inv(X0./n);

while JBLD(Y,Y0)>1e-15
    T = Y;
    Y = zeros(dim,dim);
    for i=1:n
        Y = Y + inv((inv(Y0)+X(:,:,i))/2);
    end
    Y = Y./n;
    Y0 = T;
end

X1 = inv(Y);