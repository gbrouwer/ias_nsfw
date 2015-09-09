function Q=QFGloDens(V,A)
%function Q=QFGloDens(V,A)
% A global-density-based quality function
%
% A global-density-based quality function
% For more details see the ComDet Toolbox manual
%
% INPUT
% V:      N-by-1 matrix describes a partition
% A:      adjacency matrix of graph
%
% OUTPUT
% Q:      local-density-based quality function of V given graph 
%         with adj. matrix A
% 
% EXAMPLE
% [A,V0]=GGPlantedPartition([0 10 20 30 40],0.9,0.1,0);
% VV=GCDanon(A);
% Kbst=CNGloDens(VV,A);
% V=VV(:,Kbst);
% Q=QFGloDens(V,A)
%
N=length(V);
K=max(V);
Q=0;
dinn=0; dind=0;
doun=0; doud=0;
for i=1:K
	V1=find(V==i)';         N1=length(V1);
	V2=setdiff([1:N],V1);   N2=length(V2);
    dinn=dinn+sum(sum(A(V1,V1)));
	dind=dind+N1*N1;
    doun=doun+sum(sum(A(V1,V2)));
	doud=doud+N1*(N-N1);
end
Q=(dinn/dind + 1-doun/doud)/2;
