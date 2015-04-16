
function HH = getHH(data)

% nc = 5;
% % HH = cell(1,size(data,2));
% count = 1;
% for i=1:size(data,2)
%     if all(data(:,i,:)==0), continue; end
%     t = diff(squeeze(data(:,i,:)),[],2);
%     nr = 3*(size(t,2)-nc+1);
%     if nr<=1,keyboard;end
%     Ht = hankel_mo(t,[nr nc]);
%     HHt = Ht' * Ht;
%     HHt = HHt / (norm(HHt,'fro')+1e-10);
%     %     HHt = t * t';
%     I = 1e-6*eye(size(HHt));
%     HH{count} = HHt + I;
%     count = count + 1;
% end

Hsize = 540;
opt.metric='JLD';opt.H_structure = 'HHt';

s = size(data);
data = reshape(data,s(1)*s(2),s(3));
count = 1;
while count <= size(data,1)
    if all(data(count,:)==0), data(count,:) = []; continue; end
    count = count + 1;
end
t = diff(data,[],2);
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
I = 0.9*eye(size(HHt));
HH = HHt + I;

end