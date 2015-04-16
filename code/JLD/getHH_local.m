
function HH_main = getHH_local(features,opt)

if ~exist('opt','var')
    opt.H_structure = 'HHt';
end

s = size(features{1});
assert(mod(s(1),3)==0);
nJoints = s(1) / 3;
Hsize = 10*3;
Lambda = 0.9;

HH_main = cell(1,nJoints);
for j=1:nJoints
    HH = cell(1,length(features));
    for i=1:length(features)
        t = diff(features{i}(3*(j-1)+1:3*j,:),[],2);
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
        I = Lambda * eye(size(HHt));
        HH{i} = HHt + I;
    end
    HH_main{j} = HH;
end

end