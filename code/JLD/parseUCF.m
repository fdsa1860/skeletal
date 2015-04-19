% load utKinect data

function [data,action_labels,subject_labels,instance_labels] = parseUCF

dataDir = '~/research/data/UCF';
actionNames = {'balance','climbladder','climbup','duck','hop','kick',...
    'leap','punch','run','stepback','stepfront','stepleft','stepright',...
    'twistleft','twistright','vault'};
nActions = length(actionNames);
nSubjects = 16;
nInstances = 5;

action_labels = zeros(nActions, nSubjects, nInstances);
subject_labels = zeros(nActions, nSubjects, nInstances);
instance_labels = zeros(nActions, nSubjects, nInstances);
data = cell(nActions, nSubjects, nInstances);
for si = 1:nSubjects
    subDir = sprintf('subj%02d',si);
    for ai = 1:nActions
        for ii = 1:nInstances
            filename = fullfile(dataDir,subDir,[actionNames{ai},'.',num2str(ii),'.ske']);
            [ posMat, posConf, oriMat, oriConf ] = loadUCFSkeleton( filename );
            T = permute(posMat,[4 3 1 2]);
            s = size(T);
            T = reshape(T,s(1)*s(2),[]);
            data{ai,si,ii} = T;
            action_labels(ai,si,ii) = ai;
            subject_labels(ai,si,ii) = si;
            instance_labels(ai,si,ii) = ii;
        end
    end
end

data = data(:);
action_labels = action_labels(:);
subject_labels = subject_labels(:);
instance_labels = instance_labels(:);

end

