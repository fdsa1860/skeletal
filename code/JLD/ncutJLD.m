function [label,X_center,D,cparams] = ncutJLD(X,k,opt)
% ncutJLD:
% perform kmeans clustering on covariance matrices with JLD metric
% Input:
% X: an N-by-1 cell vector
% k: the number of clusters
% Output:
% label: the clustered labeling results

% N = length(X);
% D2 = zeros(N);
D = HHdist(X,[],opt.metric);
% load sD;
% load sD_MSR_seg_L11;
% D = sD;

kNN = 10;
D2 = D;
for j=1:size(D,1)
    [ignore,ind] = sort(D(:,j));
    D2(ind(kNN+1:end),j) = Inf;
    D2(ind(1:kNN),j) = D(ind(1:kNN),j) / max(D(ind(1:kNN),j)) * 0.5;
end
D = min(D2,D2');%(B+B')/2;
% D = max(D2,D2');

scale_sig = 1;
W = exp(-D.^2/scale_sig);
NcutDiscrete = ncutW(W, k);
label = sortLabel_count(NcutDiscrete);

cparams(1:k) = struct ('alpha',0,'theta',0);
X_center = cell(1, k);
for j=1:k
    if strcmp(opt.metric,'JLD')
        if nnz(label==j)>1
%             X_center{j} = karchermean(X(label==j));
            X_center{j} = steinMean(cat(3,X{label==j}));
        elseif nnz(label==j)==1
            X_center{j} = X{label==j};
        elseif nnz(label==j)==0
            error('cluster is empty.\n');
        end
        d = HHdist(X_center(j),X(label==j),'JLD');
        d(abs(d)<1e-6) = 1e-6;
%         param = gamfit(d);
        phat = mle(d,'pdf',@gampdf,'start',[1 1],'lowerbound',[0 0],'upperbound',[1.5 inf]);
        cparams(j).alpha = min(100,phat(1));
        if isinf(cparams(j).alpha), keyboard;end
        cparams(j).theta = max(0.01,phat(2));
    elseif strcmp(opt.metric,'binlong')
        X_center{j} = findCenter(X(label==j));
    end
end

end

function center = findCenter(X)

n = length(X);
D = zeros(n,n);
for i=1:n
    for j=i+1:n
%         D(i,j) = hankeletAngle(X{i},X{j},thr);
        D(i,j) = 2 - norm(X{i}+X{j},'fro');
    end
end
D = D + D';
d = sum(D);
[~,ind] = min(d);
center = X{ind};

end