function [] = skeletal_action_classification(dataset_idx, feature_idx)

dbstop if error

addpath(genpath('./code'))
addpath(genpath('./data'))

feature_types = {'absolute_joint_positions', 'relative_joint_positions',...
    'joint_angles_quaternions', 'SE3_lie_algebra_absolute_pairs',...
    'SE3_lie_algebra_relative_pairs', 'JLD'};

if (feature_idx > 6)
    error('Feature index should be less than 6');
end

datasets = {'UTKinect', 'Florence3D', 'MSRAction3D'};

if (dataset_idx > 3)
    error('Dataset index should be less than 3');
end


% All the action sequences in a dataset are interpolated to have same
% length. 'desired_frames' is the reference length.
if (strcmp(datasets{dataset_idx}, 'UTKinect'))
    desired_frames = 74;
    
elseif (strcmp(datasets{dataset_idx}, 'Florence3D'))
    desired_frames = 35;
    
elseif (strcmp(datasets{dataset_idx}, 'MSRAction3D'))
    desired_frames = 76;
    
else
    error('Unknown dataset')
end


directory = [datasets{dataset_idx}, '_experiments/', feature_types{feature_idx}];
mkdir(directory)


% Training and test subjects
tr_info = load(['data/', datasets{dataset_idx}, '/tr_te_splits']);
n_tr_te_splits = size(tr_info.tr_subjects, 1);
tr_subjects = tr_info.tr_subjects;
te_subjects = tr_info.te_subjects;
action_sets = tr_info.action_sets;
n_action_sets = length(action_sets);

%% Skeletal representation
disp ('Generating skeletal representation')
generate_features(directory, datasets{dataset_idx}, feature_types{feature_idx}, desired_frames);

%% JLD
disp ('JLD dictionary')
labels = load([directory, '/labels'], 'action_labels', 'subject_labels');
subject_labels = labels.subject_labels;
action_labels = labels.action_labels;

loadname = [directory, '/features'];
data = load(loadname, 'features');

k = 4;
opt.metric = 'JLD';
C_val = 1;

for set = 1:n_action_sets
    
    actions = unique(action_sets{set});
    n_classes = length(actions);
    
    action_ind = ismember(action_labels, actions);
    
    total_accuracy = zeros(n_tr_te_splits, 1);
    cw_accuracy = zeros(n_tr_te_splits, n_classes);
    confusion_matrices = cell(n_tr_te_splits, 1);
    
    for si = 1:n_tr_te_splits
        
        tr_subject_ind = ismember(subject_labels, tr_subjects(si,:));
        te_subject_ind = ismember(subject_labels, te_subjects(si,:));
        tr_ind = (action_ind & tr_subject_ind);
        te_ind = (action_ind & te_subject_ind);
        X_train = data.features(tr_ind);
        nTrain = length(X_train);
        y_train = action_labels(tr_ind);
        X_test = data.features(te_ind);
        nTest = length(X_test);
        y_test = action_labels(te_ind);
        unique_classes = unique(y_train);
        n_classes = length(unique_classes);
        HH_center = cell(1, n_classes);
        for ai = 1:n_classes
            X_tmp = X_train(y_train==unique_classes(ai));
            HH_center{ai} = karcher(X_tmp{1:end});
            fprintf('processed %d/%d\n',ai,n_classes);
        end
        % test
        D2 = HHdist(HH_center,X_test,opt.metric);
        [~,ind] = min(D2);
        predicted_labels = unique_classes(ind);
        total_accuracy(si) = nnz(y_test==predicted_labels)/ length(y_test);
        
        class_wise_accuracy = zeros(1, n_classes);
        confusion_matrix = zeros(n_classes, n_classes);
        for i = 1:n_classes
            temp = find(y_test == unique_classes(i));
            class_wise_accuracy(i) =...
                nnz(predicted_labels(temp)==unique_classes(i)) / length(temp);
            
            confusion_matrix(i, :) = hist(predicted_labels(temp), unique_classes) / length(temp);
        end
        cw_accuracy(si,:) = class_wise_accuracy;
        confusion_matrices{si} = confusion_matrix;
        
%         centers(1:d) = struct('HH_center',[],'param',[]);
%         for di = 1:d
%             HH = cell(1,nTrain);
%             for ni = 1:nTrain
%                 HH(ni) = HH_train{ni}(di);
%             end
%             [label,HH_center,D,param] = ncutJLD(HH,k,opt);
%             centers(di).HH_center = HH_center;
%             centers(di).param = param;
%         end
%         
%         hFeat = zeros(k*d,n);
%         for hi = 1:d
%             HH_center = centers(hi).HH_center;
%             param = centers(hi).param;
%             HH = cell(1,n);
%             for ni = 1:n
%                 HH(ni) = data.features{ni}(hi);
%             end
%             D2 = HHdist(HH_center,HH,opt.metric);
%             for ci=1:k
%                 hFeat(k*(hi-1)+ci,:) = gampdf(D2(ci,:),param(ci).alpha,param(ci).theta);
%             end
%         end
%         
%         % scale data
%         mx = max(hFeat,[],2); mn = min(hFeat,[],2);
%         hFeat = bsxfun(@rdivide,bsxfun(@minus,hFeat,(0.5*mx+0.5*mn)),0.5*mx-0.5*mn);
%         
%         X_train = hFeat(:,tr_ind);
%         y_train = action_labels(tr_ind);
%         X_test = hFeat(:,te_ind);
%         y_test = action_labels(te_ind);
%         
%         [total_accuracy(si), cw_accuracy(si,:), confusion_matrices{si}] =...
%             svm_one_vs_all(X_train,...
%             X_test, y_train, y_test, C_val);
    end
    
    avg_total_accuracy = mean(total_accuracy);
    avg_cw_accuracy = mean(cw_accuracy);
    
    avg_confusion_matrix = zeros(size(confusion_matrices{1}));
    for j = 1:length(confusion_matrices)
        avg_confusion_matrix = avg_confusion_matrix + confusion_matrices{j};
    end
    avg_confusion_matrix = avg_confusion_matrix / length(confusion_matrices);
    
    save ([results_dir, '/classification_results_as', num2str(set), '.mat'],...
        'total_accuracy', 'cw_accuracy', 'avg_total_accuracy',...
        'avg_cw_accuracy', 'confusion_matrices', 'avg_confusion_matrix');
end

%     %% Temporal modeling
%     disp ('Temporal modeling')
%     labels = load([directory, '/labels'], 'action_labels', 'subject_labels');
%
%     n_actions = length(unique(labels.action_labels));

%     mkdir([directory, '/dtw_warped_features']);
%     mkdir([directory, '/dtw_warped_fourier_features']);
%     mkdir([directory, '/dtw_warped_pyramid_lf_fourier_kernels']);
%
%     for tr_split = 1:n_tr_te_splits
%         for tr_action = 1:n_actions
%             % DTW
%             loadname = [directory, '/features'];
%             data = load(loadname, 'features');
%
%             savename = [directory, '/dtw_warped_features/warped_features_split_',...
%                 num2str(tr_split), '_class_', num2str(tr_action)];
%
%             get_warped_features(data.features, labels.action_labels,...
%                 labels.subject_labels, tr_info.tr_subjects(tr_split, :), tr_action, savename);
%
%
%             % Fourier feature computation
%             loadname = [directory, '/dtw_warped_features/warped_features_split_',...
%                 num2str(tr_split), '_class_', num2str(tr_action)];
%             data = load(loadname, 'warped_features');
%
%             savename = [directory, '/dtw_warped_fourier_features/warped_fourier_features_split_',...
%                 num2str(tr_split), '_class_', num2str(tr_action)];
%
%             generate_fourier_features(data.warped_features, savename, desired_frames);
%
%
%             % Compute linear kernel from fourier features
%             loadname = [directory, '/dtw_warped_fourier_features/warped_fourier_features_split_',...
%                 num2str(tr_split), '_class_', num2str(tr_action)];
%             data = load(loadname);
%
%             savename = [directory, '/dtw_warped_pyramid_lf_fourier_kernels/',...
%                 'warped_pyramid_lf_fourier_kernels_split_',...
%                 num2str(tr_split), '_class_', num2str(tr_action)];
%
%             compute_kernels(data.pyramid_lf_fourier_features, savename);
%         end
%     end


% %% Classification
% disp ('Classification')
% perform_classification(directory, labels.subject_labels, labels.action_labels,...
%     tr_info.tr_subjects, tr_info.te_subjects);
% 
% if (strcmp(datasets{dataset_idx}, 'MSRAction3D'))
%     perform_classification_with_subsets(directory, labels.subject_labels,...
%         labels.action_labels, tr_info.tr_subjects, tr_info.te_subjects,...
%         tr_info.action_sets);
% end
end
