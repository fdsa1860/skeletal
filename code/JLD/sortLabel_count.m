function [label, clusterSize] = sortLabel_count(NcutDiscrete)

% label the data from low order to high order
n = size(NcutDiscrete, 1);
k = size(NcutDiscrete, 2);
label = zeros(n, 1);

% index = cell(k, 1);
% for i = 1:k
%     index{i} = find(NcutDiscrete(:, i));
%     label(index{I(i)}) = i;
% end

clusterSize = sum(NcutDiscrete);
[clusterSize, I] = sort(-clusterSize);
clusterSize = -clusterSize;

for i = 1:k
    label(logical(NcutDiscrete(:,I(i)))) = i;
end

end