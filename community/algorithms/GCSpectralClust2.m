function VV=GCSpectralClust2(A,Kmax,T)
% function VV=GCSpectralClust2(A,Kmax,T)
% Community detection by spectral  clustering
%
% Community detection by spectral  clustering. See for example
% "J. Shi and J. Malik. Normalized cuts and image segmentation. 
% IEEE Transactions on Pattern Analysis and Machine Intelligence
% 22(8):888–905, 2000."
% 
% INPUT
% A:      adjacency matrix of graph
% Kmax:   maximum number of clusters to consider
% T:      Number of times to repeat the k-means clustering, each  
%         with a new set of initial cluster centroid positions 
%         (option for Matlab Statistics toolbox kmeans function)
%
% OUTPUT
% VV:     N-ny-K matrix, VV(n,k) is the cluster to which node n  
%         belongswhen algorithm uses Gamma(k)
%  
% EXAMPLE
% [A,V0]=GGGirvanNewman(32,4,13,3,0);
% VV=GCSpectralClust2(A,6,10)
%
N=length(A);
for n1=1:N;                                    % adding a few random edges improves performance
    for n2=n1+1:N; 
        if rand(1)<0.05; 
          A(n1,n2)=1; A(n2,n1)=1; 
        end; 
    end; 
end
D=zeros(N,N);
for n=1:N
	D(n,n)=sum(A(n,:));
end
AA=inv(D)*A;
[U,L]=eig(AA);
for K=1:Kmax
	[IDX,C]=kmeans(U(:,1:K),K,'EmptyAction','singleton','Start','uniform','Replicates',T); %,'Distance','cityblock');
	VV(:,K)=IDX;
end
