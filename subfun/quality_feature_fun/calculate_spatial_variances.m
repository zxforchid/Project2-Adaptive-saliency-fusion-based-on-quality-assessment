% Calculates the spatial variances for each color component. As
% described in section 4.3 of the paper 'Learning to Detect a Salient
% Object' by Liu et al. CVPR 2007.
%
% Vicente Ordonez @ Stony Brook University
%                   State University of New York

function [variances] = calculate_spatial_variances(colormaps)

horizontal_variances = calculate_horizontal_variances(colormaps);
vertical_variances = calculate_vertical_variances(colormaps);

variances = horizontal_variances + vertical_variances;
variances = (variances - min(variances(:)))...
            ./ (max(variances(:)) - min(variances(:)));
end

