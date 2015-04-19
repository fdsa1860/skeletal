close all

sub = 7;
ins = 2;

s = size(skeletal_data{20,sub,ins}.joint_locations)
t = 1;
ind1 = 1:t-1;
ind2 = t:s(3);
% ind1 = [];ind2 = [];
% ind = ind1;
ind = ind2;
a = reshape(skeletal_data{20,sub,ins}.joint_locations(:,:,ind),60,[]);
show_skel_MSRA(a)

%%
load o o;
o{1,sub,ins}.joint_locations = skeletal_data{20,sub,ins}.joint_locations(:,:,ind1);
o{1,sub,ins}.original_skeletal_data = skeletal_data{20,sub,ins}.original_skeletal_data(:,:,ind1);
o{1,sub,ins}.time_stamps = skeletal_data{20,sub,ins}.time_stamps(ind1);
o{2,sub,ins}.joint_locations = skeletal_data{20,sub,ins}.joint_locations(:,:,ind2);
o{2,sub,ins}.original_skeletal_data = skeletal_data{20,sub,ins}.original_skeletal_data(:,:,ind2);
o{2,sub,ins}.time_stamps = skeletal_data{20,sub,ins}.time_stamps(ind2);
if isempty(ind1)
    o{3,sub,ins}.joint_locations = skeletal_data{20,sub,ins}.joint_locations(:,:,1:s(3));
    o{3,sub,ins}.original_skeletal_data = skeletal_data{20,sub,ins}.original_skeletal_data(:,:,1:s(3));
    o{3,sub,ins}.time_stamps = skeletal_data{20,sub,ins}.time_stamps(1:s(3));
else
    o{3,sub,ins}.joint_locations = [];
    o{3,sub,ins}.original_skeletal_data = [];
    o{3,sub,ins}.time_stamps = [];
end
save o o;