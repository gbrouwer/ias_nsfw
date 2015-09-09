function convertimages


%Init
clc;
count = 0;
rootdir = cd;
cd('goreval');
fdir = dir;
for i=3:size(fdir,1)
  fname = fdir(i).name;
  ext = fname(end-2:end);
  if strcmp(ext,'jpg')
    count = count + 1;
    savename = [rootdir '/gore/' num2str(count) '.jpg'];
    im = imread(fname);
    [x,y,z] = size(im);
    xlimer = round(x*0.8);
    ylimer = round(y*0.8);
    im = im(1:xlimer,1:ylimer,:);
    disp(savename);
    imwrite(im,savename,'jpg');
  end
end



