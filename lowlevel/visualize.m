function visualize

%Init
clc;
load('data/butterfly.mat');
load('conv1l1.mat');
load('conv2l1.mat');
nImages = numel(filelist(:,1))


%Convert
conv1l1 = reshape(conv1l1,48,3*11*11);
conv2l1 = reshape(conv2l1,48,3*11*11);



%Create Fake image using filters
im = zeros(229,229,3);
ic = 0;
jc = 0;




for i=7:4:224
  ic = ic + 1;
  jc = 0;
  for j=7:4:224
    jc = jc + 1;
    r1 = a1l1(1,:,ic,jc);
    r2 = a2l1(1,:,ic,jc);
    v1 = r1 * conv1l1;
    v2 = r2 * conv2l1;
    v1 = reshape(v1,3,11,11);
    v2 = reshape(v2,3,11,11);
    
    
    im(i-5:i+5,j-5:j+5,1) = im(i-5:i+5,j-5:j+5,1) + squeeze(v1(1,:,:)) + squeeze(v2(1,:,:));
    im(i-5:i+5,j-5:j+5,2) = im(i-5:i+5,j-5:j+5,2) + squeeze(v1(2,:,:)) + squeeze(v2(2,:,:));
    im(i-5:i+5,j-5:j+5,3) = im(i-5:i+5,j-5:j+5,3) + squeeze(v1(3,:,:)) + squeeze(v2(3,:,:));
  end
end

im = im ./ max(abs(im(:)));
min(im(:))
max(im(:))
im = im .* 0.5;
im = im + 0.5;


subplot(2,2,1);
imagesc(im(:,:,1));
subplot(2,2,2);
imagesc(im(:,:,2));
subplot(2,2,3);
imagesc(im(:,:,3));

colormap gray;

im(im<0) = 0;
im(im>1) = 1;
subplot(2,2,4);
imagesc(im);


%im = im + 0.5;
%im(im<0) = 0;
%im(im>1) = 1;
%imagesc(im);
% % 
% % % %Conv1
% % % load('conv1l1.mat');
% % % load('conv1l2.mat');
% % % load('conv1l3.mat');
% % % load('conv1l4.mat');
% % % load('conv1l5.mat');
% % % 
% % % 
% % % 
% % % %Conv2
% % % load('conv2l1.mat');
% % % load('conv2l2.mat');
% % % load('conv2l3.mat');
% % % load('conv2l4.mat');
% % % load('conv2l5.mat');
% % % 
% % % 
% % % size(conv1l1)
% % % size(conv1l2)
% % 
% % 
% % 
% % % figure;
% % % b = reshape(conv1l1,48,3*11*11,1);
% % % for i=1:128
% % %   v = squeeze(conv1l2(i,:,1,1));
% % %   c = v*b;
% % %   c = reshape(c,3,11,11);
% % %   x = [];
% % %   x(:,:,1) = c(1,:,:);
% % %   x(:,:,2) = c(2,:,:);
% % %   x(:,:,3) = c(3,:,:);
% % %   x = x + 0.5;
% % %   x = x - min(x(:));
% % %   x = x ./ max(x(:));
% % %   subplot(12,12,i);
% % %   imagesc(x);
% % %   axis off;
% % % end
% % 
% % 
% % 
% % 
% % 
% % % 
% % % %Class
% % % load('classl1.mat');
% % % load('classl2.mat');
% % % load('classl3.mat');
% % % 
% % % figure;
% % % C = squareform(pdist(classl3'));
% % % imagesc(C)
% % % %C = classl1'*classl2'*classl3;
% % % %save('C','C');
% % 
% % 
% % %load('C','C');
% % %figure;
% % %c = C(:,1);
% % %c = reshape(c,96,96)
% % %imagesc(c);
% % 
% % 
% % % %Plot
% % % for i=1:48
% % %   subplot(7,7,i);
% % %   r = squeeze(conv1l1(i,1,:,:));
% % %   g = squeeze(conv1l1(i,2,:,:));
% % %   b = squeeze(conv1l1(i,3,:,:));
% % %   x(:,:,1) = r;
% % %   x(:,:,2) = g;
% % %   x(:,:,3) = b;
% % %   x = x + 0.5;
% % %   x = x - min(x(:));
% % %   x = x ./ max(x(:));
% % %   imagesc(x);
% % %   colormap gray;
% % % end
% % whos