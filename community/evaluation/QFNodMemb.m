function Q=QFNodMemb(V,A)
% function Q=QFNodMemb(V,A)
% A node-membership-based quality function
%
% A node-membership-based quality function
% For more details see the ComDet Toolbox manual
%
% INPUT
% V:      N-by-1 matrix describes a partition
% A:      adjacency matrix of graph
%
% OUTPUT
% Q:      node-membership-based quality function of V given graph 
%         with adj. matrix A
% 
% EXAMPLE
% [A,V0]=GGPlantedPartition([0 10 20 30 40],0.9,0.1,0);
% VV=GCDanon(A);
% Kbst=CNNodMemb(VV,A);
% V=VV(:,Kbst);
% Q=QFNodMemb(V,A)
%
N=length(V);
K=max(V);
Q=0;
for n1=1:N
	mi=0; ni=0;
	me=0; ne=0;
	for n2=1:N
		if V(n2)==V(n1);
			ni=ni+1;
			if A(n1,n2)==1;	mi=mi+1; end
		else
			ne=ne+1;
			if A(n1,n2)==1;	me=me+1; end
		end	
	end
	if ni>0; di=mi/ni; else di=0; end
	if ne>0; de=me/ne; else de=1; end
	Q=Q+di*(1-de);
end
Q=Q/N;
