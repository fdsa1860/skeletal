function [X,iter,theta]=karcher(varargin)

% X=KARCHER(A1,...,Ap) computes the Karcher mean of positive 
%  definite matrices A1,...,Ap, using the relaxed Richardson iteration, 
%  where the parameter theta may be chosen automatically, 
%  and the initial value is the arithmetic mean
% X=KARCHER(A{1:p}) for a cell-array input
% X=KARCHER(A1,...,Ap,theta) same as above, but theta provided by user
% X=KARCHER(A{1:p},theta) for cell-array input
% Do not use X=KARCHER(A) for a cell-array A, use KARCHER(A{1:p}) instead
%
% varargin: positive definite matrix arguments A1,...,Ap
% theta: the parameter of the iteration
% X: the Karcher mean of A1,...,Ap
% iter: the number of iterations needed by the outer iteration
% 
% References
% [1] D.A. Bini and B. Iannazzo, "Computing the Karcher mean of symmetric 
% positive definite matrices", Linear Algebra Appl., 438-4 (2013), 
% pp. 1700-1710.

p=nargin;
  
% choose between automatic or given theta
aut=1;
if (size(varargin{p})==1)
  aut=0;
  theta=varargin{p};
  p=p-1;
end
  
tol=1d-15;niold=Inf;
maxiter=1000;
X=0;
for h=1:p
  A{h}=varargin{h};
  R{h}=chol(A{h});
  X=X+A{h}/p;
end

for k=1:maxiter

  R0=chol(X);
  iR0=inv(R0);
  for h=1:p
    Z=R{h}*iR0;
    [Uz{h} Vz]=schur(Z'*Z);
    V{h}=diag(Vz);
  end

  if (aut==1)
    % automatic choice of theta
    beta=0;gamma=0;
    for h=1:p
      ch=max(V{h})/min(V{h});
      if (abs(ch-1)<0.5)
        dh=log1p(ch-1)/(ch-1);
      else
        dh=log(ch)/(ch-1);
      end
      beta=beta+dh;gamma=gamma+ch*dh;
    end
    theta=2/(gamma+beta);
  end
	 
  S=0;
  for h=1:p
    T=Uz{h}*diag(log(V{h}))*Uz{h}';
    S=S+(T+T')/2;
  end
  [Us Vs]=schur(S);
  Z=diag(exp(diag(Vs*theta/2)))*Us'*R0;
  X=Z'*Z;

  ni=max(abs(diag(Vs))); % max(abs(diag(Vs)))=norm(S)
  if ( (ni<norm(X)*tol) || (ni>niold) )
      iter=k;break
  end
  niold=ni;

  if (k==maxiter)
    disp('Max number of iterations reached');
    iter=k; break;
  end

end