function features = get_joint_features(joint_locations,body_model)

if (sum(sum(joint_locations(:, body_model.hip_center_index, :))))
    error('Something wrong. Hip center is supposed to be the origin in every frame')
end

joint_locations(:, body_model.hip_center_index, :) = [];
S = size(joint_locations);
features = reshape(joint_locations, S(1)*S(2), S(3));

end