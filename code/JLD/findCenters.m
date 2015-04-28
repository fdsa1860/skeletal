function centerInd = findCenters(D,label)
% Input:
% D: N x N distance Matrix between all samples, N is the number of samples
% label: N x 1 vector, the label of each sample
% Output: 
% centerInd: the indices of the cluster centers

uniLabel = unique(label);
k = length(uniLabel);

centerInd = zeros(k ,1);
for i = 1:k
    ind = find(label==uniLabel(i));
    M = D(ind,ind);
    sd = sum(M);
    [~,index] = min(sd);
    centerInd(i) = ind(index);
end

end