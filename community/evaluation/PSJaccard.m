function Q=PSJaccard(V,V0)
% function Q=PSJaccard(V,V0)
% Jaccard index
%
% Computes the Jaccard index, shows similarity between partitions
% V and V0. Max similarity is 1 and min similarity is 0. See 
% http://en.wikipedia.org/wiki/Jaccard_index
%
% INPUT
% V:        N-by-1 matrix describes 1st partition
% V0:        N-by-1 matrix describes 2nd partition
%
% OUTPUT
% Q:         The Jaccard similarity between V and V0
%
% EXAMPLE
% [A,V0]=GGGN(32,4,16,0,0);
% VV=GCAFG(A,[0.2:0.5:1.5]);
% Kbst=CNModul(VV,A);
% V=VV(:,Kbst);
% Q=PSJaccard(V,V0);
%
if  ~isvector(V)
    error('V must be a vector');
end

if ~isvector(V0)
    error('V must be a vector');
end

if length(V) ~= length(V0)
    error('V and V0 must have the same size');
end

% Variable initialization
a11 = 0;
a10 = 0;
a01 = 0;

% Variable computation
for i = 1:length(V)
    for j = 1:length(V)
        if i == j
            continue
        end
        sameV = V(i) == V(j);
        sameV0 = V0(i) == V0(j);
        
        if sameV && sameV0
            a11 = a11 + 1; 
        elseif sameV && ~ sameV0
            a10 = a10 + 1;
        elseif ~sameV && sameV0
            a01 = a01 + 1;
        end
    end
end

% Result
Q = a11/(a11+a10+a01);
end