function output_image = rescale_max_size(input_image, max_allowed_size, verbose)
%if all image dimensions are less than max_allowed_size, this function does
%nothing.  Otherwise it will scale the image down, uniformly, so that the
%largest image dimension has size max_allowed_size

%works for color or grayscale

%now uses opencv, much faster.  But doesn't work for all image types.

if ~exist('verbose', 'var')
    verbose = 0;
end

is_double = 0;
if(isa(input_image, 'uint8'))% 原来是double  现在改为uint8 对应于原始输入图像 20151118 
    input_image = single(input_image);
    is_double = 1;
end

if(size(input_image,1) > max_allowed_size || size(input_image,2) > max_allowed_size)

    new_size = round(max_allowed_size * [size(input_image,1)  size(input_image,2)] / ...
                                    (max(size(input_image,1), size(input_image,2))));

    if(verbose)
        fprintf('  rescale_max_size: using slow built in image resize\n');
    end
    output_image = imresize(input_image, new_size, 'bilinear');

else
    if(verbose)
        fprintf('  Image does not need to be rescaled (%dx%d)\n',size(input_image,2), size(input_image,1));
    end
    output_image = input_image;
end

%to preserve the type of the input_image
if(is_double)
    output_image = double(output_image);
end

end