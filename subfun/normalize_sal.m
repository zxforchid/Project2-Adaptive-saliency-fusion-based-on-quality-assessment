function [ out ] = normalize_sal( img )
% max-min¹éÒ»»¯ 0~1
img = double(img);
if max(img(:)) == min(img(:))
    out=(img-min(img(:)))/(max(img(:))-min(img(:))+eps);
else
    out=(img-min(img(:)))/(max(img(:))-min(img(:)));
end
end