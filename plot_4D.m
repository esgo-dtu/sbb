function [cropped_ratioDN, fig, ax] = plot_4D(dataset, x_slice, y_slice, z_slice_um, fig_title, label, z_max_crop_um)

    % -----------------------------
    % Pixel size (µm)
    % -----------------------------
    pixel_size_xy = 2;
    pixel_size_z  = 2;

    % -----------------------------
    % Remove empty leading Z slices
    % -----------------------------
    first_valid_z = min(find(any(any(dataset,1),2)));
    dataset = dataset(:,:,first_valid_z:end);

    % -----------------------------
    % Optional crop in Z (user gives micrometres)
    % -----------------------------
    if ~isempty(z_max_crop_um) && z_max_crop_um >= 0
        z_max_crop_px = round(z_max_crop_um / pixel_size_z);
        dataset = dataset(:,:, z_max_crop_px + 1 : end);
    end

    % -----------------------------
    % Compute updated Z positions
    % -----------------------------
    z_vals = (0:size(dataset,3)-1) * pixel_size_z;

    % -----------------------------
    % Build coordinate grids in µm
    % -----------------------------
    x_vals = (1:size(dataset,2)) * pixel_size_xy;
    y_vals = (1:size(dataset,1)) * pixel_size_xy;

    [X, Y, Z] = meshgrid(x_vals, y_vals, z_vals);

    % -----------------------------
    % Convert slice positions
    % -----------------------------
    x_slice_um = x_slice * pixel_size_xy;
    y_slice_um = y_slice * pixel_size_xy;

    % User already defines z_slice in µm → OK directly
    z_slice_um = z_slice_um;

    % -----------------------------
    % Plotting
    % -----------------------------
    fig = figure('Color',[1 1 1]);
    ax  = axes('Parent', fig);

    h = slice(ax, X, Y, Z, dataset, x_slice_um, y_slice_um, z_slice_um);
    set(h, 'EdgeColor','none');

    % -----------------------------
    % Axes formatting
    % -----------------------------
    xlabel(ax, 'X (µm)');
    ylabel(ax, 'Y (µm)');
    zlabel(ax, 'Z (µm)');

    xlim(ax, [min(x_vals) max(x_vals)]);
    ylim(ax, [min(y_vals) max(y_vals)]);
    zlim(ax, [min(z_vals) max(z_vals)]);

    title(ax, fig_title, 'FontSize', 14);

    camproj(ax, 'orthographic');
    view(ax, 3);

    % -----------------------------
    % Colorbar
    % -----------------------------
    cb = colorbar(ax, 'southoutside');
    cb.Label.String = label;

    % -----------------------------
    % Output cropped dataset
    % -----------------------------
    cropped_ratioDN = dataset;

end