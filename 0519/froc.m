function [fpAVE,tpr]=froc(TP,FP)
%% TP���������ֹ���Ľ��
%% FP���������ֹ���Ľ��
rate=TP./FP;
[~,index2]=sort(rate(:),'descend');
for i=1:10
    TPnew(i)=TP(index2(i));
    FPnew(i)=FP(index2(i));
end
sum=0;sum1=0;
for i=1:10
    sum=sum+TPnew(i);
   tpr(i)=sum/20;% 20 ��test sample ����MA����
    sum1=sum1+FPnew(i);
    fpAVE(i)=sum1/10;%% 10 ��test sample ����ͼ�����
end
% plot(fpAVE,tpr);
% axis([10^(-1) 90 0 0.8])
% xlabel('Average number of FPs per image');  
% ylabel('sensitivity');  