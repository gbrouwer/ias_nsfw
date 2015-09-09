function VV= GCReichardt(A,Gamma)
% function VV= GCReichardt(A,Gamma)
% Reichardt community detection
%
% This is a front end for reichardt.m, which is E. le Martelot's 
% implementation of gamma-modularity maximization. Gamma modularity
% as defined by Reichardt, Jorg, and Stefan Bornholdt. "Statistical
% mechanics of community detection." Physical Review E 74.1 
% (2006): 016110.
% 
% INPUT
% A:      adjacency matrix of graph
% Gamma:  a K-by-1 matrix of gamma values, each value yields a
%         a clustering
%
% OUTPUT
% VV:     N-ny-K matrix, VV(n,k) is the cluster to which node n 
%         belongs when algorithm uses Gamma(k)
%  
% EXAMPLE
% [A,V0]=GGGirvanNewman(32,4,16,0,0);
% VV=GCReichardt(A,[3:-0.5:0.1]);
%
N=length(A);
W=PermMat(N);                     % permute the graph node labels
A=W*A*W';

K=length(Gamma);
for k=1:K
  [V,Q] = reichardt(A,Gamma(k));
  VV(:,k)=V;
end

VV=W'*VV;                         % unpermute the graph node labels

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modularity optimisation based on a Reichardt et al method
%
% Input
%   - adj: (symmetrical) adjacency matrix
%   - gamma: scale parameter
%
% Output
%   - com: communities (listed for each node)
%   - Q  : gamma modularity value of the given partition
%
% Author: Erwan Le Martelot
% Date: 20/12/10

function [com,Q] = reichardt(adj,gamma)

    % Set initial communities with one node per community
    cur_com = [1:length(adj)]';

    % Initialise best community to current value
    com = cur_com;

    % Compute initial community matrix
    e = get_community_matrix(adj,com);
    % Lines and columns sum (speed optimisation)
    ls = sum(e,2);
    cs = sum(e,1);

    % Initialise best known and current Q values
    cur_Q = trace(e) - gamma*sum(sum(e^2));
    Q = cur_Q;

    % Loop until no more aggregation is possible
    while length(e) > 1

        % Print progress
        %fprintf('Loop %d/%d...',length(adj)-length(e)+1,length(adj));
        %tic

        % Best Q variation
        loop_best_dQ = -inf;

        % For all the pairs of nodes that could be merged
        can_merge = false;
        for i=1:length(e)
            for j=i+1:length(e)
                % If they share edges
                if e(i,j) > 0
                    % Compute the variation in Q
                    dQ = 2 * (e(i,j) - gamma*ls(i)*cs(j));
                    % If best variation, then keep track of the pair
                    if dQ > loop_best_dQ
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
        for i=1:length(cur_com)
            if cur_com(i) == best_pair(2)
                cur_com(i) = best_pair(1);
            elseif cur_com(i) > best_pair(2)
                cur_com(i) = cur_com(i) - 1;
            end    
        end

        % Update community matrix
        e(best_pair(1),:) = e(best_pair(1),:) + e(best_pair(2),:);
        e(:,best_pair(1)) = e(:,best_pair(1)) + e(:,best_pair(2));
        e(best_pair(2),:) = [];
        e(:,best_pair(2)) = [];
        % Update lines/colums sum
        ls(best_pair(1)) = ls(best_pair(1)) + ls(best_pair(2));
        cs(best_pair(1)) = cs(best_pair(1)) + cs(best_pair(2));
        ls(best_pair(2)) = [];
        cs(best_pair(2)) = [];

        % Update Q value
        cur_Q = cur_Q + loop_best_dQ;

        % If new Q is better, save current partition
        if cur_Q > Q
            Q = cur_Q;
            com = cur_com;
        end

        %fprintf(' completed in %f(s)\n',toc);

    end

end

