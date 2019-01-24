function lab = getpatchLabel( gtmask, patchsize)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % gtmask    ground truth of the PIXEL_WISE annotation
    % lab       {-1, 1} -1 is background, 1 is the salient object
    % xiaofei zhou,2015/12/28
    % 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    thresh = 0.55;
    
    gtmask(gtmask >= 128) = 255;
    gtmask(gtmask < 128) = 0;
    gtmask = double(gtmask);
    tmpgtcell = imPart1(gtmask,patchsize);
    tmpgtcell = tmpgtcell';
    m = patchsize(1);
    n = patchsize(2);
    
    lab = zeros(m, n);
    
    for i=1:m
        for j=1:n
            [saliency, occurence] = mode( tmpgtcell{i,j}(:) );
            len = size(tmpgtcell{i,j},1)*size(tmpgtcell{i,j},2);
            gtrate = occurence / max(len, eps);
            if ( gtrate > thresh) && (saliency == 255)
               lab(i,j) = 1;
            else
               lab(i,j) = -1;
            end
             
        end     
    end
    
    clear gtmask tmpgtcell
%     for ix = 1 : nseg
%         pixels = spstats(ix).PixelIdxList;
%         [saliency occurence] = mode( gtmask(pixels) );
%         if occurence / max(length(pixels), eps) < thresh
%             lab(ix) = 0;
%         else
%             if saliency == 255
%                 lab(ix) = 1;
%             elseif saliency == 0
%                 lab(ix) = -1;
%             else
%                 error( 'error in gtmask' );
%             end
%         end
%     end
end