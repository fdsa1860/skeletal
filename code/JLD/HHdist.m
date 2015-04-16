function D = HHdist(HH1,HH2,metric)

isSymmetric = false;
if isempty(HH2)
    HH2 = HH1;
    isSymmetric = true;
end
if ~isSymmetric
    m = length(HH1);
    n = length(HH2);
    D = zeros(m,n);
    for i = 1:m
        for j = 1:n
            if strcmp(metric,'JLD')
                D(i,j) = log(det((HH1{i}+HH2{j})/2)) - 0.5*log(det(HH1{i})) -0.5*log(det(HH2{j}));
            elseif strcmp(metric,'binlong')
                D(i,j) = 2 - norm(HH1{i}+HH2{j},'fro');
            end
        end
    end
else
    m = length(HH1);
    D = zeros(m);
    for i = 1:m
        for j = i:m
            if strcmp(metric,'JLD')
                D(i,j) = log(det((HH1{i}+HH2{j})/2)) - 0.5*log(det(HH1{i})) -0.5*log(det(HH2{j}));
            elseif strcmp(metric,'binlong')
                D(i,j) = 2 - norm(HH1{i}+HH2{j},'fro');
            end
        end
    end
    D = D + D';
end
    

end