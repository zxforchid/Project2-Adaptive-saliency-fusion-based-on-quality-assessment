% Take an rgb image as an input and then models the colors of the image
% as Gaussian Mixture Models, then it assigns a color to each pixel and
% assigns the probability for that color for each pixel.
%
% Vicente Ordonez @ Stony Brook University
%                   State University of New York

function [colormaps] = generate_colormaps(image, numberOfColors, debug)

[height, width, channels] = size(image);

pixelValues = permute(reshape(image, 1, width * height, 3), [3 2 1]);
pixelValues = double(pixelValues);
pixelValues = pixelValues ./ max(pixelValues(:));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GMM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Init the clustering with kmeans.
[Weights, Mu, Sigma] = EM_init_kmeans(pixelValues, numberOfColors);

% Calculate the clusters using Gaussian Mixture Models and the 
% Expectation Maximization algorithm for estimating the parameters.
[Weights, Mu, Sigma] = EM(pixelValues, Weights, Mu, Sigma);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colormaps = zeros(height, width, numberOfColors);
% Calculate the probability maps for each color cluster.
for i = 1: numberOfColors
     probabilities = gaussPDF(pixelValues, Mu(:, i), Sigma(:, :, i));
     colormaps(:, :, i) = reshape(probabilities, height, width);
end

% Now weight the colormaps according to the paper 'Learning to Detect a
% Salient Object' Liu et al. from CVPR 2007.

% First calculate the denominator, which is the weighted sum of all the 
% probabilities for each color map.对应于公式（12）分母
cumulated_colormap = zeros(height, width);
for i = 1 : numberOfColors
    cumulated_colormap = ...
        cumulated_colormap + Weights(i) * colormaps(:, :, i);
end

% Now weight the colormaps and divide by the cumulative weighted
% probability color map.
for i = 1: numberOfColors
    colormaps(:, :, i) = ...
        (Weights(i) * colormaps(:, :, i)) ./ cumulated_colormap;
    if (debug > 0) 
        figure; imshow(colormaps(:, :, i));
    end
end

end

