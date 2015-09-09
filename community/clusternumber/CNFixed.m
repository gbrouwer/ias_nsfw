function Kbst = CNFixed(VV,K)
% function Kbst = CNFixed(VV,K)
% Cluster Number Selection by fixed number K
%
% Cluster Number Selection: let selected Kbst equal given K
% This function simply returns the cluster number which is 
% input by the user
%
% INPUT
% K:      desired number of clusters
%
% OUTPUT
% Kbst:   K, the input number 
% 
% EXAMPLE
% [A,V0]=GGGirvanNewman(32,4,16,0,0);
% VV=GCAFG(A,[0.2:0.5:2.5]);
% Kbst=CNFixed(4);
% V=VV(:,Kbst);
% Q=PSRelCluNumError(V,V0)
% Q=PSNMI(V,V0)
%
[N,Kmax]=size(VV);
for k=1:Kmax
	Kr=length(unique(VV(:,k)));
	d(k)=abs(Kr-K);
end
[Dbst Kbst]=min(d);
end
