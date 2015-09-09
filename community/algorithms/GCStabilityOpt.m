function VV=GCStabilityOpt(A,Scale)
% function VV=GCStabilityOpt(A,Scale)
% Graph clustering by stability optimization. 
%
% This is a front end for mscd_so.m, which is E. le Martelot's 
% implementation of Le Martelot and  Hankin's stability optimization 
% method. See "Multi-scale Community Detection using Stability as 
% Optimisation Criterion in a Greedy Algorithm, Proceedings of 
% KDIR 2011".
% 
% INPUT
% A:      adjacency matrix of graph
% Scale:  a K-by-1 matrix of scale parameters (LOW-TO-HIGH VALUES!!!); 
%         every value yields a clustering
%
% OUTPUT
% VV:     N-ny-K matrix, VV(n,k) is the cluster to which node n belongs 
%         when algorithm uses Scale(k)
%
% EXAMPLE
% [A,V0]=GGGirvanNewman(32,4,13,3,0);
% VV=GCStabilityOpt(A,[0.1:0.4:2.5])
%
N=length(A);
W=PermMat(N);                     % permute the graph node labels
A=W*A*W';

[coms,Qs] = mscd_so(A,Scale);
for k=1:length(Scale)
    VV(:,k)=coms{k};
end

VV=W'*VV;                         % unpermute the graph node labels

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [coms,Qs] = mscd_so(adj, ps)
% Fast multi-scale detection of communities using stability optimisation
% as described in (Le Martelot, Hankin; Multi-scale Community Detection
% using Stability as Optimisation Criterion in a Greedy Algorithm,
% Proceedings of KDIR 2011, 2011)
%
% Author: Erwan Le Martelot
% Date: 21/10/11
%
% Input
%   - adj: adjacency matrix
%   - ps : list of Markov time values to consider (from low to high)
%
% Output
%   - coms: community (crip) membership per node
%   - Qs  : stability values of the corresponding partitions
%
% Comments:
% - This implementation uses the stability criterion. The code
% specific to stability is placed between comment signs lines and can be
% replaced with code optimising any other criterion. It was placed within
% the algorithm and not in external functions for speed optimisation
% purposes only.
% - When a better dQ is found when moving a node, the algorithm checks that
% moving this node does not leave its initial community disconnected.
% Otherwise some communities may end up being in several components that
% should not be grouped together as one.
% - Note that this implementation uses two distinct lists of neighbours:
% one that lists the actual neighbours in the initial network, the other
% one that stores the neighbours in the current matrix for the given
% parameter. This is necessary in order to only consider actual
% neighbours when selecting the candidate neighbour nodes and communities.
% - The computation of the matrices for each parameter value is optimised
% by keeping in memory the recent matrices and corresponding exponents. For
% each new exponent the optimisation attempts to exploit the previsously
% computed matrices to speed up the matrix power computation.
%
% Dependencies: The matrix power function used here is the mpower2 function
% provided by James Tursa at http://www.mathworks.com/matlabcentral/fileexchange/25782-mpower2-a-faster-matrix-power-function
% It has the same interface as the built-in mpower Matlab function but
% is significantly faster. If you want to use the regular mpower function
% instead just replace mpower2 by mpower in the code.


    % Check there is at least one scale parameter
    if (nargin < 2) || isempty(ps)
        error('One scale parameter value at least is required: ms_so(adj,ps)');
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Transition matrix M
    D = diag(sum(adj,2)');
    M = D \ adj;
    
    % Neighbours list for each node
    % (This keeps the neighbour list small as otherwise it would grow as
    % the graph expands over time. However this works well with a list of t
    % values increasing. If using one t value, it works better to use the
    % neighbours of the node at the given time and perform checks on
    % cluster validity to ensure components are not broken.)
    for i=1:length(adj)
        Nbs{i} = find(adj(i,:));
        Nbs{i}(Nbs{i}==i) = [];
    end

    % Previously computed times and matrices
    M1 = [];
    M2 = [];
    p1 = -inf;
    p2 = -inf;
    
    % Total weight m and its double m2
    m2 = sum(sum(adj));
    m = m2/2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Initial community partition: each node in one separate community
    com = 1:length(adj);
 
    % Compute community partition for the current parameter
    for p_idx=1:length(ps)
        
        % Current parameter value
        p = ps(p_idx);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %fprintf('t = %g\n',p);

%         % Compute current adj (affected by p) [simple version]
%         dp = p - floor(p);
%         if dp == 0
%             if p == 1
%                 adj_p = adj;
%             else
%                 adj_p = D * mpower2(M,p);
%             end
%         else
%             fp = floor(p);
%             Mp = mpower2(M,fp);
%             adj_p = D * ((1-dp)*Mp + dp*(Mp*M));
%         end
        % Compute current adj (affected by p) [optimised version]
        dp = p - floor(p);
        if dp == 0
            if p == 1
                adj_p = adj;
            else
                if p == p2
                    M1 = M2;
                elseif p == p2 + 1
                    %fprintf('P2: %g = %g + 1\n', p, p2);
                    M1 = M2 * M;
                elseif p == p1 + 1
                    %fprintf('P1: %g = %g + 1\n', p, p1);
                    M1 = M1 * M;
                elseif p == p1 * 2
                    %fprintf('P1: %g = %g * 2\n', p, p1);
                    M1 = mpower2(M1,2);
                elseif p == p2 * 2
                    %fprintf('P2: %g = %g * 2\n', p, p2);
                    M1 = mpower2(M2,2);
                else
                    %fprintf('Regular power %g\n', p);
                    M1 = mpower2(M,p);
                end
                p1 = p;
                M2 = [];
                p2 = -inf;
                adj_p = D * M1;
            end
        else
            fp = floor(p);
            if fp == p1
                if fp+1 ~= p2
                    M2 = M1 * M;
                    p2 = p1 + 1;
                end
            elseif fp == p2
                M1 = M2;
                p1 = p2;
                M2 = M1 * M;
                p2 = p1 + 1;
            else
                M1 = mpower2(M,fp);
                p1 = fp;
                M2 = M1 * M;
                p2 = p1 + 1;
            end
            adj_p = D * ((1-dp)*M1 + dp*M2);
        end
        
        % Degree vector
        d = sum(adj_p,2);
        
        % Total weight of a community
        ucom = unique(com);
        for i=1:length(ucom)
            wcom(i) = sum(d(com==ucom(i)));
        end
        
        % Neighbours list for each node on adj_p
        if p == 1
            Nbs_p = Nbs;
        else
            for i=1:length(adj_p)
                Nbs_p{i} = find(adj_p(i,:));
                Nbs_p{i}(Nbs_p{i}==i) = [];
            end
        end
      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Initial Q value
        Q = compute_Q(adj_p, com, m2, d);
        
        % While changes can be made
        check_nodes = true;
        check_communities = true;
        while check_nodes
            if debug() fprintf('SO big loop\n'); end

            % Nodes moving
            moved = true;
            while moved
                if debug() fprintf('Node loop\n'); end
                moved = false;

                % Create list of nodes to inspect
                l = 1:length(adj_p);

                % While the list of candidates is not finished
                while ~isempty(l)

                    % Pick at random a node n from l and remove it from l
                    idx = randi(length(l));
                    n = l(idx);
                    l(idx) = [];

                    % Find neighbour communities of n
                    ncom = unique(com(Nbs{n}));
                    ncom(ncom == com(n)) = [];
                    % For each neighbour community of n
                    best_dQ = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    nb = Nbs_p{n};
                    nb1 = nb(com(nb) == com(n));
                    sum_nb1 = -sum(adj_p(n,nb1));
                    w1 = wcom(com(n)) - d(n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    for i=1:length(ncom)
                        % Compute dQ for moving n to current community
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        c = ncom(i);
                        nb2 = nb(com(nb) == c);
                        dQ = sum_nb1+sum(adj_p(n,nb2));
                        dQ = dQ + (d(n)*(w1-wcom(c)))/m2;
                        %fprintf('dQ=%g\n',dQ);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % If best so far, keep track of the move
                        if dQ > best_dQ
                            % Check the move is not breaking a component
                            nodes_com = com == com(n);
                            nodes_com(n) = false;
                            comp = adj(nodes_com,nodes_com);
                            % Authorised move
                            if isempty(comp) || is_connected(comp)
                                best_dQ = dQ;
                                new_c = ncom(i);
                            %else
                            %    fprintf('Forbid: moving node %g from community %g to %g\n', n, com(n), ncom(i)); 
                            %    find(com==com(n))
                            %    find(com==ncom(i))
                            end
                        end
                    end

                    % If a move is worth it, do it
                    if best_dQ > 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Update total weight of communities
                        wcom(com(n)) = wcom(com(n)) - d(n);
                        wcom(new_c) = wcom(new_c) + d(n);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Update community of n
                        com(n) = new_c;
                        % Update Q
                        Q = Q + best_dQ/m;
                        %%%%%%%%%% DEBUG %%%%%%%%%
                        if debug()
                            fprintf('Move node %g: Q=%g\n',n,Q);
                            eqQ = compute_Q(adj_p, com, m2, d);
                            if abs(Q - eqQ) >= 0.00001
                                fprintf('Node Warning: found Q=%f, should be Q=%f. Diff = %f\n',Q, eqQ, abs(Q-eqQ));
                                fprintf('Correcting\n'); Q = eqQ;
                            end
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%
                        % A move occured
                        moved = true;
                        check_communities = true;
                    end

                end

            end % Nodes
            check_nodes = false;
            
            if ~check_communities
                break;
            end

            % Community merging
            moved = true;
            while moved
                %fprintf('Community loop\n');
                moved = false;

                % Create community list cl
                cl = unique(com);

                % While the list of candidates is not finished
                while ~isempty(cl)

                    % Pick at random a community cn from cl and remove it from cl
                    idx = randi(length(cl));
                    cn = cl(idx);
                    cl(idx) = []; 

                    % Find neighbour communities of cn
                    ncn = find(com==cn);
                    nbn = unique([Nbs{ncn}]);
                    ncom = unique(com(nbn));
                    ncom(ncom == cn) = [];

                    % For each neighbour community of cn
                    best_dQ = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    sum_dn1 = sum(d(ncn));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    for ncom_idx=1:length(ncom)
                        % Compute dQ for merging cn with current community
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        n2 = com==ncom(ncom_idx);
                        dQ = sum(sum(adj_p(ncn,n2))) - sum_dn1*sum(d(n2))/m2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % If positive, keep track of the best
                        if dQ > best_dQ
                            best_dQ = dQ;
                            new_cn = ncom(ncom_idx);
                        end
                    end

                    % If a move is worth it, do it
                    if best_dQ > 0
%                        disp('Move com');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Update total weight of communities
                        wcom(new_cn) = wcom(new_cn) + wcom(cn);
                        wcom(cn) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Merge communities
                        com(ncn) = new_cn;
                        % Update Q
                        Q = Q + best_dQ/m;
                        %%%%%%%%%% DEBUG %%%%%%%%%
                        if debug()
                            fprintf('Merge communities %g and %g: Q=%g\n',cn,new_cn,Q);
                            eqQ = compute_Q(adj_p, com, m2, d);
                            if abs(Q - eqQ) >= 0.00001
                                fprintf('Com Warning: found Q=%f, should be Q=%f. Diff = %f\n',Q, eqQ, abs(Q-eqQ));
                                fprintf('Correcting\n'); Q = eqQ;
                            end
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%
                        % A move occured
                        moved = true;
                        check_nodes = true;
                    end

                end

            end % Communities
            check_communities = false;

        end % while changes can be made

        % Reindexing communities
        ucom = unique(com);
        for i=1:length(com)
            com(i) = find(ucom==com(i));
        end
        
        % Storing best community found for current parameter value
        coms{p_idx} = com';
        Qs(p_idx) = Q;

    end % for p

end

% Compute the value of Q for the given partition
function [Q] = compute_Q(adj, com, m2, d)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Q = 0;
    for i=1:length(adj)
        Q = Q + adj(i,i);
        for j=i+1:length(adj)
            if com(i) == com(j)
                Q = Q + 2*(adj(i,j) - (d(i)*d(j))/m2);
            end
        end
        Q = Q - (d(i)*d(i))/m2;
    end
    Q = Q / m2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

% Debug switch: on = {true, false}
function [on] = debug()
    on = false;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mpower2 - Evaluate matrix to a power for integer power
%*************************************************************************************
% 
%  MATLAB (R) is a trademark of The Mathworks (R) Corporation
% 
%  Function:    mpower2
%  Filename:    mpower2.m
%  Programmer:  James Tursa
%  Version:     1.1
%  Date:        November 11, 2009
%  Copyright:   (c) 2009 by James Tursa, All Rights Reserved
%
%  This code uses the BSD License:
%
%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:
%
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%      
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.
% 
%  mpower2 evaluates matrix to a power for an integer power faster
%  than the MATLAB built-in function mpower. The speed improvement
%  apparently comes from the fact that mpower does an unnecessary
%  matrix multiply as part of the algorithm startup, whereas mpower2
%  only does necessary matrix multiplies. e.g.,
%
%  >> A = rand(2000);
%  >> tic;A^1;toc
%     Elapsed time is 6.047194 seconds.
%  >> tic;mpower2(A,1);toc
%     Elapsed time is 0.001882 seconds.
%
%  For sparse matrices, mpower does not do the unnecessary matrix
%  multiply. However, in this case mpower2 is apparently more
%  memory efficient. e.g.,
%
%  >> A = sprand(5000,5000,.01);
%  >> tic;A^1;toc
%     Elapsed time is 0.038530 seconds.
%  >> tic;mpower2(A,1);toc
%     Elapsed time is 0.036335 seconds.
%  >> tic;A^2;toc
%     Elapsed time is 3.248792 seconds.
%  >> tic;mpower2(A,2);toc
%     Elapsed time is 2.160705 seconds.
%  >> tic;A^3;toc
%     Elapsed time is 10.005085 seconds.
%  >> tic;mpower2(A,3);toc
%     Elapsed time is 10.020719 seconds.
%  >> tic;A^4;toc
%     ??? Error using ==> mpower
%     Out of memory. Type HELP MEMORY for your options.
%  >> tic;mpower2(A,4);toc
%     Elapsed time is 133.682037 seconds.
%
%   Y = mpower2(X,P), is X to the power P for integer P. The power
%   is computed by repeated squaring. If the integer is negative,
%   X is inverted first.  X must be a square matrix. 
%
%   Class support for inputs X, P:
%      float: double, single
%
%  Caution: Since mpower2 does not do the unnecessary startup matrix
%  multiply that mpower does, the end result may not match mpower exactly.
%  But the answer will be just as accurate.
% 
%  Change Log:
%  Nov 11, 2009: Updated for sparse matrix input --> sparse result
%
%**************************************************************************

function Y = mpower2(X,p)
%\
% Check the arguments
%/
if( nargin ~= 2 )
    error('MATLAB:mpower2:InvalidNumberOfArgs','Need two input arguments.');
end
if( nargout > 1 )
    error('MATLAB:mpower2:TooManyOutputArgs','Too many output arguments.');
end
classname = superiorfloat(p,X);
if( numel(p) ~= 1 )
    error('MATLAB:mpower2:InvalidP','P must be a scalar.');
end
if( ~isreal(p) )
    error('MATLAB:mpower2:InvalidP','P must be real.');
end
if( floor(p) ~= p )
    error('MATLAB:mpower2:InvalidP','P must be an integer.');
end
z = size(X);
if( length(z) > 2 || z(1) ~= z(2) )
    error('MATLAB:mpower2:NonSquareMatrix','Matrix must be square.');
end
if( isempty(X) )
    if( issparse(X) )
        Y = sparse(z(1),z(2));
    else
        Y = zeros(z,classname);
    end
    return
end
%\
% Special cases use custom code that is faster than binary decomposition
%/
if( p == 0 )
    if( issparse(X) )
        Y = diag(sparse(ones(z(1),1)));
    else
        Y = eye(z,classname);
    end
    return
end
if( p < 0 )
    X = inv(X);
    p = abs(p);
end
if( p == 1 )
    Y = X;
    return
elseif( p == 2 )
    Y = X * X;
    return
elseif( p == 3 )
    Y = X * X * X;
    return
elseif( p == 15 )
    X2 = X * X;
    Y = X * X2;
    Y = Y * X2;
    Y = Y * Y * Y;
    return
elseif( p == 31 )
    X2 = X * X;
    Y = X * X2;
    Y = Y * X2;
    Y = Y * Y;
    Y = Y * Y * Y * X;
    return
elseif( p == 63 )
    Y = X * X;
    X3 = X * Y;
    Y = X3 * Y;
    Y = Y * Y;
    Y = Y * Y;
    Y = Y * Y * Y * X3;
    return
end
%\
% Get the binary decomposition of the power as a row of binary characters.
%/
bp = dec2bin(p);
%\
% Loop through the bit positions from least significant to most significant
%/
Y = [];
P = X;
zz = size(bp,2);
for n=zz:-1:1
%\
% If the bit position is 1, then we need to apply the current power of X
% to the result. P is the current power of X, i.e. P = X^(2^(zz-n))
%/
    if( bp(n) == '1' )
        if( isempty(Y) )
            Y = P;
        else
            Y = Y * P;
        end
    end
%\
% Square the current power of X, but not if it is the last index in the
% loop because in that case it won't be used or needed. For some reason,
% P * P is a lot faster than P^2.
%/
    if( n ~= 1 )
        P = P * P;
    end
end
if( isa(Y,'double') && isequal(classname,'single') )
    Y = single(Y);
end
return
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test if a graph is connected
% Author: Erwan Le Martelot
% Date: 11/11/11
%
% Input
%   - adj: adjacency matrix
%
% Output
%   - result: true if connected, false otherwise

function [result] = is_connected(adj)
    % Initially no node visited 
    visited = false(length(adj),1);
    % Visit the first node
    queue = 1;
    visited(1) = true;
    % While there are nodes to visit
    while ~isempty(queue)
        % Take next in queue
        n = queue(1);
        queue(1) = [];
        % For each neighbour of n enqueue them if not visited
        nbs = find(adj(n,:));
        for i=1:length(nbs)
            if ~visited(nbs(i))
                visited(nbs(i)) = true;
                queue = [queue nbs(i)];
            end
        end
    end
    result = sum(visited) == length(adj);
end
