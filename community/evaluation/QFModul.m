function Q = QFModul(V,A)
% function Q = QFModul(V,A)
% Modularity  quality function
%
% Computes the classical Newman-Girvan modularity. The code for 
% its evaluation, listed below, was written by E. le Martelot.
% See http://en.wikipedia.org/wiki/Modularity_%28networks%29
% 
% INPUT
% V:      N-by-1 matrix describes a partition
% A:      adjacency matrix of graph
%
% OUTPUT
% Q:      the modularity of V given graph (with adj. matrix) A
% 
% EXAMPLE
% [A,V0]=GGGN(32,4,16,0,0);
% VV=GCAFG(A,[0.2:0.5:1.5]);
% Kbst=CNModul(VV,A);
% V=VV(:,Kbst);
% Q = QFModul(V,A)
%
m = sum(sum(A));
Q = 0;
COMu = unique(V);
for j=1:length(COMu)
    Cj = find(V==COMu(j));
    Ec = sum(sum(A(Cj,Cj)));
    Et = sum(sum(A(Cj,:)));
    if Et>0
        Q = Q + Ec/m-(Et/m)^2;
    end
end

