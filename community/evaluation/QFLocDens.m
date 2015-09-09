function Q=QFLocDens(V,A)
% function Q=QFLocDens(V,A)
% A local-density-based quality function
%
% A local-density-based quality function
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
% Q=QFLocDens(V,A)
%
N=length(V);
K=max(V);
Q=0;
for i=1:K
	V1=find(V==i)';         N1=length(V1);
	V2=setdiff([1:N],V1);   N2=length(V2);
	if N1>0
	  din=(sum(sum(A(V1,V1))))/(N1*N1);
	else
	  din=1;
	end
	if N1>0 & N2>0
	  dou=sum(sum(A(V1,V2)))/(N1*N2);
	else
	  dou=0;
	end
	Q=Q+(length(V1)/N)*(din+1-dou)/2;
end
