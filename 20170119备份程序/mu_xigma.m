function [F]=mu_xigma(Feat)
% mu_xigma Computes the mean and standar diffirence of Feat;
%该函数用于计算Feat（轮廓线的property们）的均值（mu）、方差（xigam）和相关差（cv）
%input：
%   Feat：轮廓线的属性值，一般是8*7列，八个方向，一个方向上有七个属性值,在12 27又添加两个特征作为我的new feature
%output:
%   F:1*9的行向量，代表均值和方差(也叫标准偏差)的集合，每一个候选解区域，会得出一个F，在12 27 那天又多出了四个F作为输出，都是基于统计的。
mu_pw=mean(Feat(:,1));
xigma_pw=std(Feat(:,1)); 
mu_tw=mean(Feat(:,2));
xigma_tw=std(Feat(:,2));
xigma_sinc=std(Feat(:,5));
xigma_sdec=std(Feat(:,6));
cv_hinc=std(Feat(:,3))/(mean(Feat(:,3))+eps);%防止分母为0；
cv_hdec=std(Feat(:,4))/(mean(Feat(:,4))+eps);
cv_pheight=std(Feat(:,7))/(mean(Feat(:,7))+eps);
mu_wid=mean(Feat(:,8));
xigma_wid=std(Feat(:,8));
cv_wid=std(Feat(:,8))/(mean(Feat(:,8))+eps);%%新增
mu_proms=mean(Feat(:,9));
xigma_proms=std(Feat(:,9));
cv_proms=std(Feat(:,9))/(mean(Feat(:,9))+eps);%%新增

F=[mu_pw,xigma_pw,mu_tw,xigma_tw,xigma_sinc,xigma_sdec,cv_hinc,cv_hdec,cv_pheight,mu_wid,xigma_wid,cv_wid,mu_proms,xigma_proms,cv_proms];
