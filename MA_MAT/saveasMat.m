%% ������mat������һ��mat�����ҽ����ǩע��Ftotal.mat��
a=load('F1.mat');
m=a.F;
for i=2:164
    nam=strcat('F',num2str(i),'.mat');
    b=load(nam);
    m=[m;b.F];
end
MAlabel=ones(164,1);
m=[m,MAlabel];
save('Ftotal.mat','m');
