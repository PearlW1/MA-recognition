function [F]=mu_xigma(Feat)
% mu_xigma Computes the mean and standar diffirence of Feat;
%�ú������ڼ���Feat�������ߵ�property�ǣ��ľ�ֵ��mu�������xigam������زcv��
%input��
%   Feat�������ߵ�����ֵ��һ����8*7�У��˸�����һ�����������߸�����ֵ,��12 27���������������Ϊ�ҵ�new feature
%output:
%   F:1*9���������������ֵ�ͷ���(Ҳ�б�׼ƫ��)�ļ��ϣ�ÿһ����ѡ�����򣬻�ó�һ��F����12 27 �����ֶ�����ĸ�F��Ϊ��������ǻ���ͳ�Ƶġ�
mu_pw=mean(Feat(:,1));
xigma_pw=std(Feat(:,1)); 
mu_tw=mean(Feat(:,2));
xigma_tw=std(Feat(:,2));
xigma_sinc=std(Feat(:,5));
xigma_sdec=std(Feat(:,6));
cv_hinc=std(Feat(:,3))/(mean(Feat(:,3))+eps);%��ֹ��ĸΪ0��
cv_hdec=std(Feat(:,4))/(mean(Feat(:,4))+eps);
cv_pheight=std(Feat(:,7))/(mean(Feat(:,7))+eps);
mu_wid=mean(Feat(:,8));
xigma_wid=std(Feat(:,8));
cv_wid=std(Feat(:,8))/(mean(Feat(:,8))+eps);%%����
mu_proms=mean(Feat(:,9));
xigma_proms=std(Feat(:,9));
cv_proms=std(Feat(:,9))/(mean(Feat(:,9))+eps);%%����

F=[mu_pw,xigma_pw,mu_tw,xigma_tw,xigma_sinc,xigma_sdec,cv_hinc,cv_hdec,cv_pheight,mu_wid,xigma_wid,cv_wid,mu_proms,xigma_proms,cv_proms];
