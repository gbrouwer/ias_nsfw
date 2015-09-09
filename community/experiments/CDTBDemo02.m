clear all; clc
N1=32; K=4; Diag=1;
Scale=[2 1.5 0.5 0.4 0.3 0.2];
for i=0:8
 	zi=16-i;
 	zo=i;
	[A,V0]=GGGirvanNewman(N1,K,zi,zo,Diag);
	N=length(V0);
	VV=GCAFG(A,Scale);
	Mbst=CNLocDens(VV,A);
	V=VV(:,Mbst);
	Q1(i+1,1)=PSNMI(V,V0);
	K1(i+1,1)=max(V);
	figure(1); plot([V V0])
	axis([0 N+1 0 K1(i+1)+1])
	xlabel('Node no.');	ylabel('Cluster membership');	pause(0.5);
end
figure(2); plot(Q1); axis([1 9 -0.05 1.05]); 
xlabel('zo'); ylabel('NMI(V,V0)')
figure(3); plot(K1); axis([1 9 0 max(K1)])
xlabel('zo'); ylabel('NMI(V,V0)')
