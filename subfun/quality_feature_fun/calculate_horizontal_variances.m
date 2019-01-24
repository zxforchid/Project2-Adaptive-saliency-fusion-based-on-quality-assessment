% Calculates the horizontal variances for each color component. As
% described in section 4.3 of the paper 'Learning to Detect a Salient
% Object' by Liu et al. CVPR 2007.
%
% Vicente Ordonez @ Stony Brook University
%                   State University of New York
% Ë®Æ½
function [variances] = calculate_horizontal_variances(colormaps)

[height, width, numberOfColors] = size(colormaps);
colormap_sum = zeros(numberOfColors, 1);

% Calculate the sum of each color map.
% Denoted as |X|c = sum_{x} p(c/x)in the paper.
for i = 1: numberOfColors
    colormap_sum(i) = sum(sum(colormaps(:, :, i)));
end

% Now calculate the term denoted as M_h(c) for each color map. £¨14£©
M_h = zeros(numberOfColors, 1);

for color = 1: numberOfColors
    for y = 1: height
        for x = 1: width
            M_h(color) = M_h(color) + colormaps(y, x, color) * x;
        end
    end
end

% Now divide by the term denoted as 1 / \|X\|_c in the paper.£¨14£©
M_h = M_h ./ colormap_sum;

% Now calculate the term denoted as V_h(c) in the paper.£¨13£©
horizontal_variances = zeros(numberOfColors, 1);
for y = 1: height
    for x = 1: width
        for color = 1: numberOfColors
            temp = abs(x - M_h(color));
            horizontal_variances(color) = ...
                horizontal_variances(color) + ...
                colormaps(y, x, color) * temp * temp;
        end
    end
end

% Now divide by the term denoted as 1 / \|X\|_c in the paper.£¨13£©
horizontal_variances = horizontal_variances ./ colormap_sum;

% Return this values.
variances = horizontal_variances;

end

