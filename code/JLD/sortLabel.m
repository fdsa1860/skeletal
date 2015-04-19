function newLabel = sortLabel(label)

uLabel = unique(label);
n = length(label);
k = length(uLabel);
newLabel = zeros(n, 1);
index = cell(k, 1);
count = zeros(k, 1);

for i = 1:k
    index{i} = find(label == uLabel(i));
    count(i) = length(index{i});
end

[~, I] = sort(-count);

for i = 1:k
    newLabel(index{I(i)}) = i;
end

end