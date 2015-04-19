
function HH = getHH(features,opt)

s = size(features{1});

% Hsize = 540;
Hsize = 9*s(1);
% Hsize = 7;

if ~exist('opt','var')
    opt.H_structure = 'HHt';
end

HH = cell(1,length(features));
for i=1:length(features)
    t = diff(features{i},[],2);
    if strcmp(opt.H_structure,'HtH')
        nc = Hsize;
        nr = size(t,1)*(size(t,2)-nc+1);
        if nr<1, error('hankel size is too large.\n'); end
        Ht = hankel_mo(t,[nr nc]);
        HHt = Ht' * Ht;
    elseif strcmp(opt.H_structure,'HHt')
        nr = floor(Hsize/size(t,1))*size(t,1);
        nc = size(t,2)-floor(nr/size(t,1))+1;
        if nc<1, error('hankel size is too large.\n'); end
        Ht = hankel_mo(t,[nr nc]);
        HHt = Ht * Ht';
    end
    HHt = HHt / norm(HHt,'fro');
    %     HHt = t * t';
    I = 0.25*eye(size(HHt));
    HH{i} = HHt + I;
end


% data = reshape(data,s(1)*s(2),s(3));



% count = 1;
% while count <= size(data,1)
%     if all(data(count,:)==0), data(count,:) = []; continue; end
%     count = count + 1;
% end
% t = diff(data,[],2);
% if strcmp(opt.H_structure,'HtH')
%     nc = Hsize;
%     nr = size(t,1)*(size(t,2)-nc+1);
%     if nr<1, error('hankel size is too large.\n'); end
%     Ht = hankel_mo(t,[nr nc]);
%     HHt = Ht' * Ht;
% elseif strcmp(opt.H_structure,'HHt')
%     nr = floor(Hsize/size(t,1))*size(t,1);
%     nc = size(t,2)-floor(nr/size(t,1))+1;
%     if nc<1, error('hankel size is too large.\n'); end
%     Ht = hankel_mo(t,[nr nc]);
%     HHt = Ht * Ht';
% end
% HHt = HHt / norm(HHt,'fro');
% %     HHt = t * t';
% I = 0.9*eye(size(HHt));
% HH = HHt + I;

end