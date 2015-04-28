function [newFeat,newHH,newSub,newAct] = getNewHH(o)

s = size(o);
newFeat = cell(s);
newHH = cell(s);
newSub = zeros(s);
newAct = zeros(s);
for k = 1:s(3)
    for i = 1:s(1)
        for j = 1:s(2)
            if isempty(o{i,j,k}), continue; end
            joint_locations = o{i,j,k}.joint_locations;
            if isempty(joint_locations), continue; end
            joint_locations(:,7,:) = [];
            S = size(joint_locations);
            features = reshape(joint_locations, S(1)*S(2), S(3));
            newFeat{i,j,k} = features;
            newHH(i,j,k) = getHH({features});
            newSub(i,j,k) = j;
            if i==1
                newAct(i,j,k) = 13;
            elseif i==2
                newAct(i,j,k) = 6;
            end
        end
    end
end

newFeat(newAct==0) = [];
newFeat = newFeat(:);
newHH(newAct==0) = [];
newHH = newHH(:)';
newSub(newAct==0) = [];
newSub = newSub(:);
newAct(newAct==0) = [];
newAct = newAct(:);

end