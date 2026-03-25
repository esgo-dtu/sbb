function [ch1DN, ch2DN] = denoising(cube_size, height_factor, threshold,matrix_3D_ch1,matrix_3D_ch2)

ch1DN = NaN(length(matrix_3D_ch1(:,1,1)),length(matrix_3D_ch2(1,:,1)),length(matrix_3D_ch1(1,1,:)));
ch2DN = NaN(length(matrix_3D_ch2(:,1,1)),length(matrix_3D_ch2(1,:,1)),length(matrix_3D_ch2(1,1,:)));

for i = cube_size/2:length(ch1DN(:,1,1))-cube_size/2
    for j = cube_size/2:length(ch2DN(1,:,1))-cube_size/2
        for k = round(cube_size/2/height_factor):length(ch1DN(1,1,:))-round(cube_size/2/height_factor)
            if sum(isnan(matrix_3D_ch1(i-cube_size/2+1:i+cube_size/2,j-cube_size/2+1:j+cube_size/2,k-round(cube_size/2/height_factor)+1:k+round(cube_size/2/height_factor))),"all")/cube_size^2*(round(cube_size/2/height_factor)*2) > threshold
                ch1DN(i,j,k) = NaN;
            else
                ch1DN(i,j,k) = matrix_3D_ch1(i,j,k);
            end
            if sum(isnan(matrix_3D_ch2(i-cube_size/2+1:i+cube_size/2,j-cube_size/2+1:j+cube_size/2,k-round(cube_size/2/height_factor)+1:k+round(cube_size/2/height_factor))),"all")/cube_size^2*(round(cube_size/2/height_factor)*2) > threshold
                ch2DN(i,j,k) = NaN;
            else
                ch2DN(i,j,k) = matrix_3D_ch2(i,j,k);
            end
        end
    end
end
end