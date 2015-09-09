function Q=PSRelCluNumError(V,V0)
% function Q=PSPSRelCluNumError(V,V0)
% Relative cluster number error
%
% Relative cluster number error: abs(K-K0)/K0
% Becomes zero when V has the same number of clusters as V0
%
% INPUT
% V:        N-by-1 matrix describes test partition
% V0:        N-by-1 matrix describes reference partition
%
% OUTPUT
% Q:         The relative Cluster Number error of  V wrt V0
%
% EXAMPLE
% [A,V0]=GGGirvanNewman(32,4,12,4,0);
% VV=GCAFG(A,[0.2:0.5:1.5]);
% Kbst=CNModul(VV,A);
% V=VV(:,Kbst);
% Q=PSRelCluNumError(V,V0);
%
K0=length(unique(V0));
K =length(unique(V));
Q=abs(K-K0)/K0;