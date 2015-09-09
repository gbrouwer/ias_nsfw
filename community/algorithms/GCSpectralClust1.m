function [VV,C]=GCSpectralClust1(A,Kmax)
% function VV=GCSpectralClust1(A,Kmax)
%
% Community detection by spectral  clustering. See J. Hespanha's 
% implementation of spectral clustering. For details see 
% Joao Hespanha. "An efficient MATLAB Algorithm for Graph Partitioning". 
% Technical Report, University of California, Oct. 2004. 
% http://www.ece.ucsb.edu/~hespanha/techrep.html.
% 
% INPUT
% A:      adjacency matrix of graph
% Kmax:   max number of clusters  to consider. A clustering of K clusters 
%         will be produced for every K in [1:Kmax]
%
% OUTPUT
% VV:     N-ny-K matrix, VV(n,k) is the cluster to which node n belongs 
%         when algorithm uses a partition of k clusters
%
% EXAMPLE
% [A,V0]=GGGirvanNewman(32,4,13,3,0);
% VV=GCSpectralClust1(A,6)
%
N=length(A);
W=PermMat(N);                     % permute the graph node labels
A=W*A*W';

VV(:,1)=ones(N,1);
for k=2:Kmax
	[ndx,Pi,cost]= grPartition(A,k,1);
	VV(:,k)=ndx;
  C(k) = cost
end

VV=W'*VV;                         % unpermute the graph node labels

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ndx,Pi,cost]= grPartition(C,k,nrep)
%
% function [ndx,Pi,cost]= grPartition(C,k,nrep);
%
% Partitions the n-node undirected graph G defined by the matrix C
% 
% Inputs:
% C - n by n edge-weights matrix. In particular, c(i,j)=c(j,i) is equal 
%     to the cost associated with cuting the edge between nodes i and j.
%     This matrix should be symmetric and doubly stochastic. If this
%     is not the case, this matrix will be normalized to
%     satisfy these properties (with a warning).
% k - desired number of partitions
% nrep - number of repetion for the clustering algorithm 
%       (optional input, defaults to 1)
% 
% Outputs:
% ndx  - n-vector with the cluster index for every node 
%       (indices from 1 to k)
% Pi   - Projection matrix [see Technical report
% cost - cost of the partition (sum of broken edges)
%
% Example:
%
% X=rand(200,2);               % place random points in the plane
% C=pdist(X,'euclidean');      % compute distance between points
% C=exp(-.1*squareform(C));    % edge cost is a negative exponential of distance
%
% k=6;                         % # of partitions
% [ndx,Pi,cost]= grPartition(C,k,30);
%
% colors=hsv(k);               % plots points with appropriate colors
% colormap(colors)
% cla
% line(X(:,1),X(:,2),'MarkerEdgeColor',[0,0,0],'linestyle','none','marker','.');
% for i=1:k
%   line(X(find(ndx==i),1),X(find(ndx==i),2),...
%       'MarkerEdgeColor',colors(i,:),'linestyle','none','marker','.');
% end
% title(sprintf('Cost %g',cost))
% colorbar
%
% Copyright (c) 2004, Joao Hespanha
% All rights reserved.
if nargin<3
  nrep=1;
end

[n,m]=size(C);
if n~=m
  error('grPartition: Cost matrix is not square'); 
end  

if ~issparse(C)
  C=sparse(C);  
end

% Test for symmetry
if any(any(C~=C'))
  %warning('grPartition: Cost matrix not symmetric, making it symmetric')
  % Make C symmetric  
  C=(C+C')/2;
end  

% Test for double stochasticity
if any(sum(C,1)~=1)
  %warning('grPartition: Cost matrix not doubly stochastic, normalizing it.','grPartition:not doubly stochastic')
  % Make C double stochastic
  C=C/(1.001*max(sum(C)));  % make largest sum a little smaller
                            % than 1 to make sure no entry of C becomes negative
  C=C+sparse(1:n,1:n,1-sum(C));
  if any(C(:))<0
    error('grPartition: Normalization resulted in negative costs. BUG.')
  end
end  

if any(any(C<0))
  error('grPartition: Edge costs cannot be negative')
end  

% Spectral partition
options.issym=1;               % matrix is symmetric
options.isreal=1;              % matrix is real
options.tol=1e-6;              % decrease tolerance 
options.maxit=500;             % increase maximum number of iterations
options.disp=0;
[U,D]=eigs(C,k,'la',options);  % only compute 'k' largest eigenvalues/vectors


   ndx=mykmeans1(U,k,100,nrep);

if nargout>1
  Pi=sparse(1:length(ndx),ndx,1);
end  

if nargout>2
  cost=full(sum(sum(C))-trace(Pi'*C*Pi));
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bestNdx=mykmeans1(X,k,nReplicates,maxIterations)
%
% function bestNdx=mykmeans(X,k,nReplicates,maxIterations)
%
% Partitions the points in the data matrix X into k clusters. This
% function behaves much like the stats/kmeans from MATLAB's
% Statitics toolbox called as follows:
%   bestNdx = kmeans(X,k,'Distance','cosine',...
%                    'Replicates',nReplicates,'MaxIter',maxIterations)
% 
% Inputs:
% X    - n by p data matrix, with one row per point.
% k    - desired number of partitions
% nReplicates - number of repetion for the clustering algorithm 
%       (optional input, defaults to 1)
% maxIterations - maximum number of iterations for the k-means algorithm
%           (per repetition)
% 
% Outputs:
% ndx  - n-vector with the cluster index for every node 
%       (indices from 1 to k)
% Pi   - Projection matrix [see Technical report
% cost - cost of the partition (sum of broken edges)
%
% Copyright (c) 2006, Joao Hespanha
% All rights reserved.

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
%    * Redistributions of source code must retain the above copyright
%    notice, this list of conditions and the following disclaimer.
%
%    * Redistributions in binary form must reproduce the above
%    copyright notice, this list of conditions and the following
%    disclaimer in the documentation and/or other materials provided
%    with the distribution.
% 
%    * Neither the name of the <ORGANIZATION> nor the names of its
%    contributors may be used to endorse or promote products derived
%    from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
% FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
% COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
% INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
% BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
% LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
% ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
if nargin<4,
  maxIterations=100;
end
if nargin<3,
  nReplicates=1;  
end
    
nPoints=size(X,1);
if nPoints<=k, 
  bestNdx=1:nPoints;
  return
end

% normalize vectors so that inner product is a distance measure
normX=sqrt(sum(X.^2,2));
X=X./(normX*ones(1,size(X,2)));
bestInnerProd=0; % best distance so far

for rep=1:nReplicates

  % random sample for the centroids
  ndx = randperm(size(X,1));
  centroids=X(ndx(1:k),:);
  
  lastNdx=zeros(nPoints,1);
  
  for iter=1:maxIterations
    InnerProd=X*centroids'; % use inner product as distance
    [maxInnerProd,ndx]=max(InnerProd,[],2);  % find 
    if ndx==lastNdx,
      break;          % stop the iteration
    else
      lastNdx=ndx;      
    end
    for i=1:k
      j=find(ndx==i);
      if isempty(j)     
	%error('mykmeans: empty cluster')
      end
      centroids(i,:)=mean(X(j,:),1);
      centroids(i,:)=centroids(i,:)/norm(centroids(i,:)); % normalize centroids
    end
  end
  if sum(maxInnerProd)>bestInnerProd
    bestNdx=ndx;
    bestInnerProd=sum(maxInnerProd);
  end

end % for rep
 
end