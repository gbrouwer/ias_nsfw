clear all
clc

[A,V0]=GGGirvanNewman(32,4,13,3,0);
V=GCModulMax1(A);
N=length(V);
K=max(V);
Q1=PSNMI(V,V0);
disp(['The NMI metric between V0 and Vest is ' num2str(Q1)]);
figure(1); plot([V V0])
axis([0 N+1 0 K+1])
xlabel('Node no.')
ylabel('Cluster membership')