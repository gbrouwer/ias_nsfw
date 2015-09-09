function Kbst=CNModul(VV,A)
% function Kbst=CNModul(VV,A)
% Modularity based cluster number selection
%
% Cluster number selection performed by finding the VV column which
% achieves  highest Newman-Girvan modularity (see Evaluation/QFModul.m)
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
% [A,V0]=GGGirvanNewman(32,4,16,0,0);
% VV=GCAFG(A,[0.2:0.5:1.5]);
% Kbst=CNModul(VV,A);
%
[N Kmax]=size(VV);
for K=1:Kmax
	V=VV(:,K);
	Q(K)=QFModul(V,A);
end
[Qbst Kbst]=max(Q);
