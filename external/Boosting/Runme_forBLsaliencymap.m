clc;
clear all;
tic;
imgRoot='.\img\';% test image path
saldir='.\OUT-BL\';% the output path of the saliency map
supdir='.\superpixels\';% the superpixel label file path
nfeature=3;
pa=5;
if ~isdir(supdir)
mkdir(supdir);
end
if ~isdir(saldir)
mkdir(saldir);
end
imnames=dir([imgRoot '*' 'jpg']);
ntype=3;
for ii=1:length(imnames)
    disp(ii);
    imname=[imgRoot imnames(ii).name]; 
    im=imread(imname);
    [w,h,dim]=size(im);
    if dim==1
    temp=zeros(w,h,3);
    temp(:,:,1)=im;
    temp(:,:,2)=im;
    temp(:,:,3)=im;
    im=temp;
    end
%% cut the frame of images
[input_im,flag]=cutframe(im);
input_im=uint8(input_im);
%%
[m,n,k] = size(input_im);
imname=[imname(1:end-4) '.bmp'];
imwrite(input_im,imname);
smap=0;
datap.rgb=[];
datan.rgb=[];
datap.lab=[];
datan.lab=[];
datap.lbp=[];
datan.lbp=[];
labelp=[];
labeln=[];
rgbvals0=[];
labvals0=[];
lbpvals0=[];
cutim0=zeros(m,n);
 %% dark chanel
input_im0=input_im;
[mm,nn,kk] = size(input_im0);
  darkim=zeros(mm,nn);
  pp=(pa-1)/2;
  image=zeros(mm+pp*2,nn+pp*2,3);
 image((1+pp):(mm+pp),1:pp,:)=input_im0(:,1:pp,:);
 image((1+pp):(mm+pp),nn+pp+1:end,:)=input_im0(:,nn+1-pp:end,:);
 image((1+pp):(mm+pp),(1+pp):(nn+pp),:)=input_im0;
image(1:pp,:,:)=image(pp+1:(pa-1),:,:);
image(pp+mm+1:end,:,:)=image((end-pa+2):pp+mm,:,:);
for i=1:mm
 for j=1:nn
     x=i+pp;
     y=j+pp;
    bk=image(i:x+pp,j:y+pp,:);
    darkim(i,j)=min(min(min(bk)));
 end
end
    darkim=255-darkim;
  darkim=normalize(darkim);
  side=[darkim(1:end,1)',darkim(1:end,end)',darkim(1,1:end),darkim(end,1:end)];
%% 
disp('building graph');
N = m*n;
  imm = double((input_im));
    m1=imm(:,:,1);
    m2=imm(:,:,2);
    m3=imm(:,:,3);
% construct graph
E = edges4connected(m,n);
V=1./(1+sqrt((m1(E(:,1))-m1(E(:,2))).^2+(m2(E(:,1))-m2(E(:,2))).^2+(m3(E(:,1))-m3(E(:,2))).^2));
AA=1000*sparse(E(:,1),E(:,2),0.3*V);
g = fspecial('gauss', [5 5], sqrt(5));
%% 
for ss=2:5
    spnumber=(ss-0)*50;
%% generate superpixels
   % the slic software support only the '.bmp' image
    comm=['SLICSuperpixelSegmentation' ' ' imname ' ' int2str(20) ' ' int2str(spnumber) ' ' supdir];
    system(comm);    
    spname=[supdir imnames(ii).name(1:end-4)  '.dat'];
    superpixels=ReadDAT([m,n],spname); % superpixel label matrix
    spnum=max(superpixels(:));% the actual superpixel number
%% compute the feature
[m,n,k] = size(input_im);
    input_vals=reshape(input_im, m*n, k);
    rgb_vals=zeros(spnum,1,3);
    inds=cell(spnum,1);
    for i=1:spnum
        inds{i}=find(superpixels==i);
        rgb_vals(i,1,:)=mean(input_vals(inds{i},:),1); 
    end
lab_vals = colorspace('Lab<-', rgb_vals); 
lab_vals=reshape(lab_vals,spnum,3);
rgb_vals=reshape(rgb_vals,spnum,3);
%% lbp 
    [A,~] = LBP_uniform(rgb2gray(input_im));
     lbp_vals=zeros(spnum,1,59);
     STA=regionprops(superpixels,'all');
     if ss==2
         STA0=STA;
     else if ss==3
         STA1=STA;
         else if ss==4
             STA2=STA;
             else
                 STA3=STA;
             end
         end
     end
    for i=1:spnum
        temp=A(STA(i).PixelIdxList);
        lbp_vals(i,1,:)=hist(temp,1:59);
    end
    lbp_vals=reshape(lbp_vals,spnum,59);         
%%    
    % top, down, right, left
    bst=unique(superpixels(1,1:n));
    bsd=unique(superpixels(m,1:n));
    bsr=unique(superpixels(1:m,1));
    bsl=unique(superpixels(1:m,n));
    bs=sort(unique([bst,bsd,bsr',bsl'])); 
    spatial_prior=zeros(spnum,1);
    region_dist=zeros(spnum,spnum,3);
     [x y] = meshgrid(-n/2+1:n/2, -m/2+1:m/2); 
    x = x.^2;
    y = y.^2;
       k=2;
    centersp=setdiff([1:spnum],bs);
    for iii=1:spnum
        i=iii;
          temp_x_dist = mean(x(STA(i).PixelIdxList));
        temp_y_dist = mean(y(STA(i).PixelIdxList));
        spatial_prior(i) = exp(-k^2*temp_x_dist/n^2 - k^2*temp_y_dist/m^2); 
        for ix=i+1:spnum
            region_dist(i,ix,1)=histDist(lbp_vals(i,:),lbp_vals(ix,:));
            region_dist(i,ix,2)=sum((rgb_vals(i,:)-rgb_vals(ix,:)).^2);
            region_dist(i,ix,3)=sum((lab_vals(i,:)-lab_vals(ix,:)).^2);
        end
    end
    for i=1:3  
    region_dist(:,:,i)=(region_dist(:,:,i)-min(min(region_dist(:,:,i))))/(max(max(region_dist(:,:,i)))-min(min(region_dist(:,:,i))));
    end
    region_dist= sum(region_dist,3);
    region_dist=region_dist+region_dist'; 
   temp_sal = abs(-log(1 - region_dist));

   darkpa=zeros(spnum,1);
   for i=1:spnum
     darkpa(i,1)= mean(darkim(STA(i).PixelIdxList)); 
   end
   darkpa=exp(darkpa);
   if mean(side)>0.8
    darkpa=ones(spnum,1);
   end
  
   saliency = spatial_prior .* sum(temp_sal(:,bs), 2).*(darkpa);
   map=zeros(m,n);
   for i=1:spnum
      map(STA(i).PixelIdxList)=repmat(saliency(i), size(STA(i).PixelIdxList)); 
   end
   %%
   if ss==2
   [cutim]=graphcut0(AA,g,map);
   cutim0=normalize(cutim0+cutim);
   else if ss==3
   [cutim]=graphcut0(AA,g,map);
   cutim0=normalize(cutim0+cutim);
      else if ss==4
   [cutim]=graphcut0(AA,g,map);
   cutim0=normalize(cutim0+cutim);
          else
   [cutim]=graphcut0(AA,g,map); 
   cutim0=normalize(cutim0+cutim);
           end
       end
   end
 %% MKB
    bsf=[];
    bsb=[];
    meancut=1.5.*mean(cutim(:));
    thresh=0.05;
    maxi=0;
    for i=1:spnum 
        meantemp=mean(cutim(STA(i).PixelIdxList));
        if meantemp>maxi
            maxi=meantemp;
            maxind=i;
        end
        if meantemp>= meancut
            bsf=[bsf,i];
        else if meantemp< thresh
            bsb=[bsb,i];
            end
        end 
    end
    if isempty(bsf)
       bsf=[maxind]; 
    end
       bsb=unique([bsb,bs]);
   
 datap.rgb=[datap.rgb;rgb_vals(bsf,:)];
 datan.rgb=[datan.rgb;rgb_vals(bsb,:)];
 datap.lab=[datap.lab;lab_vals(bsf,:)];
 datan.lab=[datan.lab;lab_vals(bsb,:)];
 datap.lbp=[datap.lbp;lbp_vals(bsf,:)];
 datan.lbp=[datan.lbp;lbp_vals(bsb,:)];
labelp=[labelp;repmat(1,length(bsf),1)];
labeln=[labeln;repmat(-1,length(bsb),1)];
rgbvals0=[rgbvals0;rgb_vals];
labvals0=[labvals0;lab_vals];
lbpvals0=[lbpvals0;lbp_vals];
end

 data.rgb=[datap.rgb;datan.rgb];
 data.lab=[datap.lab;datan.lab];
 data.lbp=[datap.lbp;datan.lbp];
label.rgb = [labelp;labeln];
label.lab = label.rgb;
label.lbp = label.rgb;
datanum = [size(data.rgb,1) size(data.lab,1) size(data.lbp,1)];

[ beta, model, tm ] = boost_mkl3( data, label, nfeature, datanum,ntype);
d = distribution( model );  
 data.rgb=rgbvals0;
 data.lab=labvals0;
 data.lbp=lbpvals0;
[conf,binary] = mkltest_new3(beta, model,d,data,ntype);
 map0=zeros(m,n);  
 map1=zeros(m,n);
 map2=zeros(m,n);
 map3=zeros(m,n);

 spnum0=size(STA0,1);
 spnum1=size(STA1,1);
 spnum2=size(STA2,1); 
 spnum3=size(STA3,1);
 
  for i=1:spnum0
      map0(STA0(i).PixelIdxList)=repmat(conf(i), size(STA0(i).PixelIdxList));  
  end
   for i=spnum0+1:spnum0+spnum1
      map1(STA1(i-spnum0).PixelIdxList)=repmat(conf(i), size(STA1(i-spnum0).PixelIdxList));  
   end
   for i=spnum0+spnum1+1:spnum0+spnum1+spnum2
      map2(STA2(i-spnum0-spnum1).PixelIdxList)=repmat(conf(i), size(STA2(i-spnum0-spnum1).PixelIdxList));  
   end
   for i=spnum0+spnum1+spnum2+1:spnum0+spnum1+spnum2+spnum3
      map3(STA3(i-spnum0-spnum1-spnum2).PixelIdxList)=repmat(conf(i), size(STA3(i-spnum0-spnum1-spnum2).PixelIdxList));  
  end
   map0=normalize(map0);
   map1=normalize(map1);
   map2=normalize(map2);
   map3=normalize(map3);
  
 [mkbcut0]=graphcut0(AA,g,map0);
  [mkbcut1]=graphcut0(AA,g,map1);
  [mkbcut2]=graphcut0(AA,g,map2);
  [mkbcut3]=graphcut0(AA,g,map3);
  mkbcut=normalize(mkbcut0+mkbcut1+mkbcut2+mkbcut3);
step2graph=saveimg(flag,mkbcut,[w,h],[saldir imnames(ii).name(1:end-4) 'step2_graph.png']);
%% 
step2graphfilter= guidedfilter(step2graph,step2graph,7,0.1);
%imwrite(step2graphfilter,[saldir imnames(ii).name(1:end-4) 'step2_graph-filter.png']); 
cutim0=saveimg(flag,cutim0,[w,h],[saldir imnames(ii).name(1:end-4) '-twostep1.png']);
sal=normalize(cutim0*0.3+step2graphfilter*0.7);
imwrite(sal,[saldir imnames(ii).name(1:end-4) '_BL.png']); 
end
t=toc;



