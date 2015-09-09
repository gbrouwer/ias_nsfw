function CV=CVIdx(V,A)
% function CV=CVIdx(V,A)
% cluster validity index
%
% This function returns a clustering validity index CV
% which assigns higher values to clusterings such that
% every node has more edges linking to the cluster in
% which it belongs (than to any other cluster). Minimum
% value is 0, maximum value is 0.
% For more details see the ComDet Toolbox Manual  
%
% INPUT
% V    partition vector, n-th entry contains the cluster
%      to which node n belongs
% A    adjacency matrix of the graph
%
% OUTPUT
% CV   Cluster validity index
%
N=size(V,1);
K=max(V);
Links=zeros(N,K);
for n=1:N
    for k=1:K
      V1=find(A(n,:)==1);
	  V2=find(V==k);
      Links(n,k)=length(intersect(V1,V2));
    end
    k0=V(n);
	[Lmax kmax]=max(Links(n,:));
	if k0==kmax
       	CVi(n,1)=1;
    else
        CVi(n,1)=0;	
    end
end
CV=sum(CVi)/N;
