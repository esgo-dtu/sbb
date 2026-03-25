function [padded_ch1, padded_ch2] = pad_to_512(S1ch1, S1ch2)
    % Get current size
    [rows_ch1, cols_ch1] = size(S1ch1);
    [rows_ch2, cols_ch2] = size(S1ch2);

    % Calculate padding needed
    padRows_ch1 = max(0, 512 - rows_ch1);
    padCols_ch1 = max(0, 512 - cols_ch1);
    padRows_ch2 = max(0, 512 - rows_ch2);
    padCols_ch2 = max(0, 512 - cols_ch2);

    % Compute padding for top/bottom and left/right
    padTop_ch1 = floor(padRows_ch1 / 2);
    padBottom_ch1 = ceil(padRows_ch1 / 2);
    padLeft_ch1 = floor(padCols_ch1 / 2);
    padRight_ch1 = ceil(padCols_ch1 / 2);
    padTop_ch2 = floor(padRows_ch2 / 2);
    padBottom_ch2 = ceil(padRows_ch2 / 2);
    padLeft_ch2 = floor(padCols_ch2 / 2);
    padRight_ch2 = ceil(padCols_ch2 / 2);


    % Apply zero-padding
    padded_ch1 = padarray(S1ch1, [padTop_ch1, padLeft_ch1], 0, 'pre');
    padded_ch1 = padarray(padded_ch1, [padBottom_ch1, padRight_ch1], 0, 'post');
    padded_ch2 = padarray(S1ch2, [padTop_ch2, padLeft_ch2], 0, 'pre');
    padded_ch2 = padarray(padded_ch2, [padBottom_ch2, padRight_ch2], 0, 'post');
end