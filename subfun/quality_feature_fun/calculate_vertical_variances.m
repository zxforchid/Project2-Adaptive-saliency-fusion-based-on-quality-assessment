% Calculates the horizontal variances for each color component. As
% described in section 4.3 of the paper 'Learning to Detect a Salient
% Object' by Liu et al. CVPR 2007.
%
% Vicente Ordonez @ Stony Brook University
%                   State University of New York

function [variances] = calculate_vertical_variances(colormaps)

[height, width, numberOfColors] = size(colormaps);
colormap_sum = zeros(numberOfColors, 1);

% Calculate the sum of each color map.
% Denoted as sum_{x} p(c/x)in the paper.
for i = 1: numberOfColors
    colormap_sum(i) = sum(sum(colormaps(:, :, i)));
end

% Now calculate the term denoted as M_v(c) for each color map.
M_v = zeros(numberOfColors, 1);
for y = 1: height
    for x = 1: width
        for color = 1: numberOfColors
            M_v(color) = M_v(color) + colormaps(y, x, color) * y;
        end
    end
end

% Now divide by the term denoted as 1 / \|X\|_c in the paper.
M_v = M_v ./ colormap_sum;

% Now calculate the term denoted as V_h(c) in the paper.
vertical_variances = zeros(numberOfColors, 1);
for y = 1: height
    for x = 1: width
        for color = 1: numberOfColors
            temp = abs(y - M_v(color));
            vertical_variances(color) = ...
                vertical_variances(color) + ...
                colormaps(y, x, color) * temp * temp;
        end
    end
end

% Now divide by the term denoted as 1 / \|X\|_c in the paper.
vertical_variances = vertical_variances ./ colormap_sum;

% Return this values.
variances = vertical_variances;

end

