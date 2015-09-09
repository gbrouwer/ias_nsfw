function VV= GCRonhovde(A,Gamma)
% function VV= GCRonhovde(A,Gamma)
% Community detection using Ronhovde et al.'s method. This 
% is a front end for ronhovde.m, which is E. le Martelot's 
% implementation of gamma-modularity maximization, as defined by
% Ronhovde, Peter, and Zohar Nussinov. "Local resolution-limit-free 
% Potts model for community detection." Physical Review E 81.4 
% (2010): 046114.
% 
% INPUT
% A:      adjacency matrix of graph
% Gamma:  a K-by-1 matrix of gamma values, each value yields a
%         a clustering
%
% OUTPUT
% VV:     N-ny-K matrix, VV(n,k) is the cluster to which node n belongs 
%         when algorithm uses Gamma(k)
%
%  
% EXAMPLE
% [A,V0]=GGGirvanNewman(32,4,16,0,0);
% VV=GCRonhovde(A,[0.5:-0.05:0.05]);
%
N=length(A);
W=PermMat(N);                     % permute the graph node labels
A=W*A*W';

K=length(Gamma);
for k=1:K
  [V,Q] = ronhovde(A,Gamma(k));
  VV(:,k)=V;
end

VV=W'*VV;                         % unpermute the graph node labels

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Community detection based on a Ronhovde et Nussinov's method
%
% Input
%   - adj: (symmetrical) adjacency matrix
%   - gamma: scale parameter
%
% Output
%   - com: communities (listed for each node)
%   - Q  : energy value of the given partition (to minimise)
%
% Author: Erwan Le Martelot
% Date: 24/05/11

function [com,Q] = ronhovde(adj, gamma)

    % Set initial communities with one node per community
    for i=1:length(adj)
        cur_com{i} = i;
    end
    coms = cur_com;

    % Communities graph
    e = adj;
    
    % Initialise best known and current Q values
    cur_Q = 0;
    Q = cur_Q;
    
    % Loop until no more aggregation is possible
    while length(e) > 1

        % Print progress
        %fprintf('Loop %d/%d...',length(adj)-length(e)+1,length(adj));
        %tic
        
        % Best Q variation
        loop_best_dQ = inf;

        % For all the pairs of nodes that could be merged
        can_merge = false;
        for i=1:length(e)
            for j=i+1:length(e)
                % If they share edges
                if e(i,j) > 0
                    % Compute the variation dQ
                    ni = length(cur_com{i});
                    ji = ((ni*(ni-1))/2) - e(i,i);
                    nj = length(cur_com{j});
                    jj = ((nj*(nj-1))/2) - e(j,j);
                    nij = ni + nj;
                    jij = ((nij*(nij-1))/2) - (e(i,i) + e(j,j) + e(i,j));
                    dQ = -(e(i,j) + gamma*(ji + jj - jij));
                    % If best variation, then keep track of the pair
                    if dQ < loop_best_dQ
                        loop_best_dQ = dQ;
                        best_pair = [i,j];
                        can_merge = true;
                    end
                end
            end
        end
        if ~can_merge
            disp('!!! Graph with isolated communities, no more merging possible !!!');
            break;
        end

        % Merge the pair of clusters maximising Q
        best_pair = sort(best_pair);
        e(best_pair(1),:) = e(best_pair(1),:) + e(best_pair(2),:);
        e(:,best_pair(1)) = e(:,best_pair(1)) + e(:,best_pair(2));
        e(best_pair(2),:) = [];
        e(:,best_pair(2)) = [];
        cur_com{best_pair(1)} = [cur_com{best_pair(1)} cur_com{best_pair(2)}];
        cur_com(best_pair(2)) = [];

        % Update Q value
        cur_Q = cur_Q + loop_best_dQ;
        
        % If new Q is better, save current partition
        if cur_Q < Q
            Q = cur_Q;
            coms = cur_com;
        end

        %fprintf(' completed in %f(s)\n',toc);

    end
    
    com = zeros(length(adj),1);
    for c=1:length(coms)
        for n=1:length(coms{c})
            com(coms{c}(n)) = c;
        end
    end
    
end

% function [Q] = evaluate(e, coms, gamma)
%     Q = 0;
%     for c=1:length(e)
%         n = length(coms{c});
%         Q = Q + (e(c,c) - gamma*( ((n*(n-1))/2) - e(c,c) ));
%     end
%     Q = -0.5 * Q;
% end

