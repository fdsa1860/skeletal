function Y = incSteinMean(X)

n = size(X,3);
Y = X(:,:,1);
for i = 2:n
    Y = mean_stein_2(Y,X(:,:,i),1-1/i);
end


end