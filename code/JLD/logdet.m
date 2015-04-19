function L = logdet( G )
% Fast computation of the  Log Det 
% of a symmetric matrix G using its
% Cholesky factorization
% Written by Octavia Camps April 1, 2015
% Ref: "Efficient Similarity Search for Covariance Matrices 
% via the Jensen-Bregman LogDet Divergence", A. Cherian et al.

L = log(prod(diag(chol(G)).^2));

end

