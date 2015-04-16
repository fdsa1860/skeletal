function [X,iter,energy]=BhattacharyyaMean(varargin)

% X=BattacharyaMean(A1,...,Ap) computes the Battacharya mean of positive 
%  definite matrices A1,...,Ap, using the fixed point algorithm
% X=KARCHER(A{1:p}) for a cell-array input
% 
% varargin: positive definite matrix arguments A1,...,Ap
%
% X: the Battacharya mean of A1,...,Ap
% iter: the number of iterations needed by the outer iteration
% energy: The sum of the JBLD between the samples and the computed mean
% 
% References
% "Using the Bhattacharyya Mean for the Filtering and Clustering of Positive-Definite Matrices,"
% by M. Charfi, Z. Chebbi, M. Moakher and B. Vemuri.
% Implemented by O. Camps 4/6/15

p=nargin;
  
% choose between automatic or given theta

  
tol=1d-10;niold=Inf;
maxiter=10000;

%initial guess for X

X=0;

for h=1:p
  A{h}=varargin{h};
  %R{h}=chol(A{h});
  X=X+A{h}/p;
end

energy = 0;
for h =1:p
    energy = energy + JBLD(X,A{h});
end
 
%Fix point iterations
for k=1:maxiter
    Xnew = 0;
    for i=1:p
        Xnew = Xnew + inv(0.5 * (A{i} + X))/p;
    end
    Xnew = inv(Xnew);
    energynew = 0;
    for h =1:p
        energynew = energynew + JBLD(Xnew,A{h});
    end
    
    d = energy - energynew;
    if (d < tol)
        iter = k;
        X = Xnew;
        energy = energynew;
        break;
    end
    X = Xnew;
    energy = energynew;
end

  
  if (k==maxiter)
    disp('Max number of iterations reached');
    iter=k; return;
  end

end