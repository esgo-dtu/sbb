function [matrix_3D_ch1, matrix_3D_ch2] = fill_matrix(S1ch1, S1ch2, dimsize, parameter)
    % --- Shift Z coordinates so the lowest Z becomes 0 ---
    min_z = min([S1ch1(:,3); S1ch2(:,3)]);
    S1ch1(:,3) = S1ch1(:,3) - min_z;
    S1ch2(:,3) = S1ch2(:,3) - min_z;

    % --- Determine reference array based on max Z ---
    max_S1ch1 = max(S1ch1(:,3));
    max_S1ch2 = max(S1ch2(:,3));

    if max_S1ch1 < max_S1ch2
        selected_array = S1ch1;
    else
        selected_array = S1ch2;
    end
    % --- Create empty 3D matrices ---
    max_x = max([S1ch1(:,1); S1ch2(:,1)]);
    max_y = max([S1ch1(:,2); S1ch2(:,2)]);
    max_z = max(selected_array(:,3));

    ch1 = zeros(max_x, max_y, max_z + 1); % +1 because MATLAB indexing starts at 1
    ch2 = zeros(max_x, max_y, max_z + 1);

    % --- Fill ch1 matrix with boundary checks ---
    for i = 1:size(S1ch1, 1)
        if S1ch1(i, parameter) > 0
            x = S1ch1(i,1);
            y = S1ch1(i,2);
            z = S1ch1(i,3) + 1; % shift for MATLAB indexing

            x_start = max(1, x - 1);
            x_end   = min(max_x, x + 1);
            y_start = max(1, y - 1);
            y_end   = min(max_y, y + 1);
            z_start = max(1, z - 1);
            z_end   = min(max_z + 1, z);

            ch1(x_start:x_end, y_start:y_end, z_start:z_end) = S1ch1(i, parameter);
        end
    end
    % --- Fill ch2 matrix with boundary checks ---
    for i = 1:size(S1ch2, 1)
        if S1ch2(i, parameter) > 0
            x = S1ch2(i,1);
            y = S1ch2(i,2);
            z = S1ch2(i,3) + 1;

            x_start = max(1, x - 1);
            x_end   = min(max_x, x + 1);
            y_start = max(1, y - 1);
            y_end   = min(max_y, y + 1);
            z_start = max(1, z - 1);
            z_end   = min(max_z + 1, z);

            ch2(x_start:x_end, y_start:y_end, z_start:z_end) = S1ch2(i, parameter);
        end
    end

    % --- Downsample and average over blocks ---
    ch1rd = zeros(round(max_x / dimsize), round(max_y / dimsize), max_z + 1);
    ch2rd = zeros(round(max_x / dimsize), round(max_y / dimsize), max_z + 1);

    for i = 1:size(ch1rd, 1)
        for j = 1:size(ch1rd, 2)
            for k = 1:size(ch1rd, 3)
                x_start = (i - 1) * dimsize + 1;
                x_end   = min(i * dimsize, max_x);
                y_start = (j - 1) * dimsize + 1;
                y_end   = min(j * dimsize, max_y);

                ch1rd(i, j, k) = mean(ch1(x_start:x_end, y_start:y_end, k), 'all');
                ch2rd(i, j, k) = mean(ch2(x_start:x_end, y_start:y_end, k), 'all');
            end
        end
    end

    % --- Output renamed matrices ---
    matrix_3D_ch1 = ch1rd;
    matrix_3D_ch2 = ch2rd;
end
