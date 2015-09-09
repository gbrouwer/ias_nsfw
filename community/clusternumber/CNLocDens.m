function Kbst=CNLocDens(VV,A)
% function Kbst=CNLocDens(VV,A)
% Local-density-based cluster number selection
%
% Cluster number selection performed by finding the VV column which
% achieves  highest value of the local density clustering  quality 
% function QFLD (see documentation in Evaluation/QFLD.m)
%
% INPUT
% VV:     N-by-K matrix of partitions, k-th column describes a partition
%         of k clusters
% A:      adjacency matrix of graph
%
% OUTPUT
% Kbst:   the number of best VV column and so best number of clusters
% 
% EXAMPLE
% [A,V0]=GGPlantedPartition([0 10 20 30 40],0.9,0.1,0);
% VV=GCAFG(A,[0.2:0.5:1.5]);
% Kbst=CNLocDens(VV,A);
%
[N Kmax]=size(VV);
for K=1:Kmax
	V=VV(:,K);
	Q(K)=QFLocDens(V,A);
end
[Qbst Kbst]=max(Q);
