function Q=QFDistBased(V,A)
%function Q=QFDistBased(V,A)
% A partition-distance-based quality function
%
% A partition-distance-based quality function
% For more details see the ComDet Toolbox manual
%
% INPUT
% V:      N-by-1 matrix describes a partition
% A:      adjacency matrix of graph
%
% OUTPUT
% Q:      node-membership-based quality function of V given graph 
%         with adj. matrix A
% 
% EXAMPLE
% [A,V0]=GGPlantedPartition([0 10 20 30 40],0.9,0.1,0);
% VV=GCDanon(A);
% Kbst=CNNM(VV,A);
% V=VV(:,Kbst);
% Q=QFDistBased(V,A)
%
N=length(V);
K=max(V);
AV=zeros(N,N);
for i=1:K
	V1=find(V==i)';
	AV(V1,V1)=1;
end
Q=sum(sum(abs(A-AV)))/(N^2);
