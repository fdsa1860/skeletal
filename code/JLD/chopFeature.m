function [feat,label] = chopFeature(features)

maxFeat = 50000;
feat = cell(1,maxFeat);
label = zeros(1, maxFeat);
wSize = 11;
count = 1;
for i = 1:length(features)
    f = features{i};
    nc = size(f,2);
    if nc <= wSize
        feat{count} = f;
        label(count) = i;
        count = count + 1;
        continue;
    end
    for j = 1:nc-wSize+1
        feat{count} = f(:,j:j+wSize-1);
        label(count) = i;
        count = count + 1;
    end
end
feat(count:end) = [];
label(count:end) = [];

end