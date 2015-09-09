function activity(category)


%Init
clc;
load(['../activity/' category]);
T1 = T1(2:end,1:end-1);
T2 = T2(2:end,1:end-1);
T3 = T3(2:end,1:end-1);


%Sort
[maxval,index] = max(mean(T3));
t3 = T3(:,index);
[val,ind] = sort(t3);



%Get best images
for i=1:25
  filename = filelist(ind(end-26+i),:);
  filename = ['/Users/gijs/MyImageNet/train/' filename(36:end)];
  while (strcmp(filename(end),' '))
    filename = filename(1:end-1);
  end
  im = imread(filename);
  subplot(5,5,i);
  imagesc(im);
end



%Get worst images
figure;
for i=1:25
  filename = filelist(ind(i),:);
  filename = ['/Users/gijs/MyImageNet/train/' filename(36:end)];
  while (strcmp(filename(end),' '))
    filename = filename(1:end-1);
  end
  im = imread(filename);
  subplot(5,5,i);
  imagesc(im);
end



