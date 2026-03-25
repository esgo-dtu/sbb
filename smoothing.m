function [ratioSM] = smoothing(target_variable,ch1DN,ch2DN,cube_size_x,cube_size_y,cube_size_z)
ratioSM = NaN(length(ch1DN(:,1,1)),length(ch2DN(1,:,1)),length(ch1DN(1,1,:)));


for i = ceil(cube_size_x / 2):length(ch1DN(:, 1, 1)) - floor(cube_size_x / 2)
    for j = ceil(cube_size_y / 2):length(ch2DN(1, :, 1)) - floor(cube_size_y / 2)
        for k = ceil(cube_size_z / 2):length(ch1DN(1, 1, :)) - floor(cube_size_z / 2)
            if ~isnan(target_variable(i, j, k))
                ratioSM(i, j, k) = mean(target_variable(i - floor(cube_size_x / 2) + 1:i + floor(cube_size_x / 2), ...
                    j - floor(cube_size_y / 2) + 1:j + floor(cube_size_y / 2), ...
                    k - floor(cube_size_z / 2) + 1:k + floor(cube_size_z / 2)), ...
                    'all', 'omitnan');
            end     
        end
    end
end
end