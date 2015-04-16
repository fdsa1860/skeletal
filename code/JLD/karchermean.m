function G = karchermean(Gi)

N = length(Gi);
G = Gi{1};
Gpre = G;
for iter = 1:1000
    [V,D] = eig(G);
    sqrtG = V*diag(sqrt(diag(D)))*V';
    sqrtGinv = V*diag(1./sqrt(diag(D)))*V';
    M = cellfun(@(x) logm(sqrtGinv*x*sqrtGinv),Gi,'UniformOutput',false);
    M = sum(cat(3,M{:}),3)/N;
    G = sqrtG*expm(M)*sqrtG;
    if norm(G-Gpre,'fro')<=1e-3
        break;
    end
    Gpre = G;
end
G = real(G);