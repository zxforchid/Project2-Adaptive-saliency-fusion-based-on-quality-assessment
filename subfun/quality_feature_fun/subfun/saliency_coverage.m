function FC = saliency_coverage(saliencymap,threshold)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version1:07/08/2015
% version2: 09/13/2015 ����ϸ��������
% 
% computer saliency_coverage feature
% input:
% saliencymap ����ͼ
% threshold   ��ֵ �������ڵ���1 
% output:
% FC      �������1*10
% reference paper:
% <comparing salient object detection results without ground truth>
% written by xiaofei zhou,shanghai university,shanghai,china
% current version: 09/13/2015  15:38PM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[mt,nt] = size(threshold);
[ms,ns] = size(saliencymap);

num_pixels = ms*ns;
num_fc     = mt*nt;

FC = zeros(1,num_fc);
for i=1:num_fc
    FC(i) = sum(sum(saliencymap>threshold(i)))/num_pixels;    
end

clear saliencymap threshold
end