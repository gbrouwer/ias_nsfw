function [Kbst,CV]=CNNodMemb(VV,A,m)
% function Kbst=CNNodMemb(VV,A,m)
% Cluster Number Selection by node membership 
%
% Cluster number selection performed by finding the VV column which
% achieves  highest value of the node membership clustering  quality 
% function QFNM (see documentation in Evaluation/QFNM.m)
%
% INPUT
% VV:     N-by-K matrix of partitions, k-th column describes a partition
%         of k clusters
% A:      adjacency matrix of graph
% m:      internal variable, always set to 1
%
% OUTPUT
% Kbst:   the number of best VV column and so best number of clusters
% 
% EXAMPLE
% [A,V0]=GGPlantedPartition([0 10 20 30 40],0.9,0.1,0);
% VV=GCAFG(A,[0.2:0.5:1.5]);
% Kbst=CNNodMemb(VV,A,1);
%
Kmax=size(VV,2);
Cbst=-1;
Kbst=1;
for K=1:Kmax
    if m==1; CV(K)=CVIdx(VV(:,K),A); end
    if CV(K)>Cbst
        Cbst=CV(K);
        Kbst=K;
    end
    if CV(K)==Cbst & length(unique(VV(:,K)))>length(unique(VV(:,Kbst)))
        Cbst=CV(K);
        Kbst=K;
    end
end
