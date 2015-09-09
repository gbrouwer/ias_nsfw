function analyze

%Init
clc;
addpath(genpath('/Users/gijs/UNICEF/assignment/community'))



%Read Categories
fid = fopen('../meta/categories','r');
categories = [];
for i=1:213
  tline = fgetl(fid);
  [left,right] = strtok(tline,char(9));
  categories{i} = left;
end
fclose(fid);



%Load Matrices
load('../matrices/A.mat');
load('../matrices/C.mat');



%Sort
A(:,1) = A(:,1) ./ A(:,3);
A(:,2) = A(:,2) ./ A(:,3);
[R,I] = sortrows(A,2);
A = A(I,:);
bar(A(:,1:2));



%List in order
for i=1:213
  category = categories{I(i)};
  disp([category ', accuracy: ' num2str(A(i,1)) ', top 5: ' num2str(A(i,2))]);
end



%Community Detection
imagesc(C);
com = GCModulMax1(C);
for i=1:max(com)
  dum = find(com == i);
  for j=1:numel(dum)
    disp(['Community ' num2str(i) ': ' categories{dum(j)}]);
  end
  disp('--------');
end

  