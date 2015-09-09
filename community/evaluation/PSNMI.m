function Q = PSNMI(V,V0)
% function Q=PSNMI(V,V0)
% Normalized Mutual Information (NMI)
%
% An implementation of Normalized Mutual Information (NMI)
% by Erwan Le Martelot. The NMI measure shows 
% the similarity between two partitions. Max similarity is 1
% and min similarity is 0. For details see Danon, Leon, et al. 
% "Comparing community structure identification." Journal of 
% Statistical Mechanics: Theory and Experiment 2005.09 (2005): P09008.
%
% INPUT
% V:        N-by-1 matrix describes 1st partition
% V0:        N-by-1 matrix describes 2nd partition
%
% OUTPUT
% Q:         The Normalized Mututal Information between V and V0
%
% EXAMPLE
% [A,V0]=GGGirvanNewman(32,4,12,4,0);
% VV=GCAFG(A,[0.2:0.5:1.5]);
% Kbst=CNModul(VV,A);
% V=VV(:,Kbst);
% Q=PSNMI(V,V0);
%
if length(V) ~= length(V0)
    error('The two lists have different lengths');
end

% Number of nodes
n = length(V);

% Number of values in each list
nc1 = length(unique(V));
nc2 = length(unique(V0));

% Terms initialisation
term1 = 0;
term2 = 0;
term3 = 0;
    
use_full_matrix = (nc1*nc2 < 1000000);
% Computing terms using full matrix representation
if use_full_matrix
        
    % Build the confusion matrix
    c = zeros(nc1,nc2);
    for i=1:n
        c(V(i),V0(i)) = c(V(i),V0(i)) + 1;
    end
    sumci = sum(c,2);
    sumcj = sum(c,1);

    % Terms computing
    for i=1:nc1
        for j=1:nc2   
            if c(i,j) > 0
                term1 = term1 + ( c(i,j) * log( (c(i,j)*n) / (sumci(i)*sumcj(j)) ) );
            end
        end
        term2 = term2 + ( sumci(i) * log(sumci(i)/n) );
    end
    for j=1:nc2
        term3 = term3 + ( sumcj(j) * log(sumcj(j)/n) );
    end
        
% Sparse representation
else
        
    % Build the confusion matrix
    c = sparse(nc1,nc2);
    sumci = zeros(nc1,1);
    sumcj = zeros(nc2,1);
    for i=1:n
        c(V(i),V0(i)) = c(V(i),V0(i)) + 1;
        sumci(V(i)) = sumci(V(i)) + 1;
        sumcj(V0(i)) = sumcj(V0(i)) + 1;
    end

    % Terms computing
    for i=1:nc1
        cols = find(c(i,:));
        for k=1:length(cols)
            j = cols(k);
            term1 = term1 + ( c(i,j) * log( (c(i,j)*n) / (sumci(i)*sumcj(j)) ) );
        end
        term2 = term2 + ( sumci(i) * log(sumci(i)/n) );
    end
    for j=1:nc2
        term3 = term3 + ( sumcj(j) * log(sumcj(j)/n) );
    end
        
end
     
%Result
Q = (-2 * term1) / (term2 + term3);
Q=Q';
end
