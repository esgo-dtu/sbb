%% Data importation
% List of file names
% Enter your own list of filenames here
fileNames = {'ESGO_stratification_CO_effect_pos1_ch1_frame000001_Nz47_data.mat', 'ESGO_stratification_CO_effect_pos1_ch2_frame000001_Nz47_data.mat'};

% Select your desired parameters by writing their names in the following:
fields = {'Cube_CenterCoord', 'Intensity_Integrated_ch1', 'Distance_ToSurface_resolution2'};


% Import the BiofilmQ files into Matlab
for i = 1:length(fileNames)
    % Generate the variable name dynamically
    varName1 = ['stats_ch' num2str(i)];
    %varName2 = ['global_ch' num2str(i)];
    
    % Call the import_stats function
    import_data_biofilmq(fileNames{i}, varName1);
end

% Create coordinate array
num_coords_ch1 = length(stats_ch1); % change stats to reflect the two channels
num_coords_ch2 = length(stats_ch2);
num_variables = 5;
S1ch1 = zeros(length(stats_ch1),num_variables);
S1ch2 = zeros(length(stats_ch2),num_variables);

% Extract the data from the file imported from BiofilmQ and write into a
% matrix format that is easier to work with
for i=1:num_coords_ch1
    S1ch1(i,1) = [stats_ch1(i).Cube_CenterCoord(1)];
    S1ch1(i,2) = [stats_ch1(i).Cube_CenterCoord(2)];
    S1ch1(i,3) = [stats_ch1(i).Cube_CenterCoord(3)];
    S1ch1(i,4) = [stats_ch1(i).Intensity_Integrated_ch1];
    S1ch1(i,5) = [stats_ch1(i).Distance_ToSurface_resolution2];
end

for i=1:num_coords_ch2
    S1ch2(i,1) = [stats_ch2(i).Cube_CenterCoord(1)];
    S1ch2(i,2) = [stats_ch2(i).Cube_CenterCoord(2)];
    S1ch2(i,3) = [stats_ch2(i).Cube_CenterCoord(3)];
    S1ch2(i,4) = [stats_ch2(i).Intensity_Integrated_ch2];
    S1ch2(i,5) = [stats_ch2(i).Distance_ToSurface_resolution2];
end


% Create 3D matrix
dimsize = 1; % Choose if you want to average over more pixels in the x and y directions
parameter = 4; % Choose which column of data to process
[fluorescence_3D_ch1, fluorescence_3D_ch2] = fill_matrix(S1ch1,S1ch2,dimsize,parameter); % Create the matrix
parameter = 5; % Choose which column of data to process
[distance_3D_ch1, distance_3D_ch2] = fill_matrix(S1ch1,S1ch2,dimsize,parameter); % Create the matrix

%% Image processing
% Denoising
cube_size = 20; % Number of pixels around the target pixel to check for data
height_factor = 1; % remove
threshold = 0.90;

[ch1DN, ch2DN] = denoising(cube_size,height_factor,threshold,fluorescence_3D_ch1,fluorescence_3D_ch2); % cube size, height factor, threshold
[d1DN, d2DN] = denoising(cube_size,height_factor,threshold,distance_3D_ch1,distance_3D_ch2);


% Calculate your desired relationship between the signals in ch1 and ch2
ratioDN = ch2DN./(ch2DN+ch1DN);

% Convert distance to surface to distance to substrate
max_distance_to_surface = max(d1DN, [], 3);  % Max across Z for each (x, y)
max_distance_to_surface_expanded = repmat(max_distance_to_surface, [1, 1, size(d1DN, 3)]);
distance_to_substrate = max_distance_to_surface_expanded - d1DN;  % Element-wise subtraction

% Normalise the Z value
ratioDN_shifted = 0:(size(ratioDN, 3)-1);  % Z now starts at 0

% Smoothing
cube_size_x = 10; % Number of pixels on the x axis to average
cube_size_y = 10; % Number of pixels on the y axis to average
cube_size_z = 1; % Number of pixels on the z axis to average
target_variable = ratioDN; % Change to reflect your target variable
[ratioSM] = smoothing(target_variable,ch1DN,ch2DN,cube_size_x,cube_size_z,cube_size_y);
target_variable = distance_to_substrate;
[distanceSM] = smoothing(target_variable,ch1DN,ch2DN,cube_size_x,cube_size_z,cube_size_y);

%% Visualisation
% 4D plot
% --- Input dataset ---
dataset = ratioDN;

% --- User-controlled slice positions ---
x_slice = 0;                 % in pixels
y_slice = 0;                 % in pixels
z_slice = 0:1:200;      % in micrometres (user chooses physical units)

% --- User-controlled labels and title ---
label = 'Methanobacteriales relative proportion';
fig_title = '4D biofilm plot';

% --- Optional: crop z (in micrometres); use [] for no cropping ---
z_max_crop_um = [];

% --- Call cleaned function ---
[cropped_ratioDN, fig, ax] = plot_4D(dataset, x_slice, y_slice, z_slice, fig_title, label, z_max_crop_um);

%% Export
% Suppose your 3D matrix is called M
% Size of M: [X, Y, Z]

[X, Y, Z] = size(cropped_ratioDN);

% Reshape M into a column vector
values = cropped_ratioDN(:);

% Create corresponding Z indices
% Repeat each Z value for X*Y times
Z_indices = repelem(1:Z, X*Y)';

% Combine into a two-column array
output = [Z_indices, values];

average_tot = mean(ratioDN(:,:,:),'all','omitnan');
stdev_tot = std(ratioDN(:,:,:),1,'all','omitnan');

relative_proportion = values;
distance = Z_indices;
output_name = '100_CO_pos5_z.csv';
export_matrices(relative_proportion, distance, output_name);
