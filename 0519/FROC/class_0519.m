clc,clear all
MA=load('E:\WZZ\OneDrive\0407\MA_MAT\FMA.mat');%%不曾去除干扰数据
nonMA=load('E:\WZZ\OneDrive\0407\nonMA_MAT\FnonMA.mat');
f1=MA.F(:,1:21);
f2=nonMA.F(:,1:21);
lab1=ones(94,1);
lab2=zeros(143,1);
F=[f2;f1];
lab=[lab2;lab1];
mdl=fitcnb(F,lab);
imgnum=[3,10,13,21,22,24,28,33,42,46];
root = pwd;
addpath(genpath(fullfile(root,'FROC')));
% addpath(genpath(fullfile('D:\')))
%% get scores_maps.mat
for i=1:length(imgnum)
    testMatName=strcat('test',num2str(imgnum(i)),'.mat');
    test=load(testMatName);
    TT=test.F(:,1:21);
    [label2,score2] = predict(mdl,TT);
    excelName=strcat('D:\test',num2str(imgnum(i)),'.xlsx');
%     [ndata,test,alldata]=xlsread(excelName);
    [ndata]=xlsread(excelName);
    coor(:,1)=ndata(:,1);coor(:,2)=ndata(:,2);
%     scores_mapsName=strcat('scores_maps',num2str(imgnum));
    scores_maps{i}=[coor,score2(:,2),label2];
    clear coor;
end

save('scores_maps.mat','scores_maps');
%         maps=scores_maps{1};
%         mapss=cell2mat(scores_maps(1));
%         scores_in=[scores_in,mapss(:,3)];

%% get gt_labels.mat

load('gt_labels.mat');
load('scores_maps.mat');
[fpi, per_lesion_sensitivity] = froc(scores_maps, gt_labels,0)
plot_froc(per_lesion_sensitivity, fpi)


test=load('E:\WZZ\OneDrive\0407\未进行增强的实验数据mat矩阵\test3\F.mat');
TT=test.F(:,1:21);
%% NB
mdl=fitcnb(F,lab);
[label2,score2] = predict(mdl,TT) %score 第一列返回负类概率，第二列返回正类概率
[ndata, text, alldata] = xlsread('D:\wzz\0407文件夹数据备份\未进行增强的实验数据mat矩阵\test3.xlsx');
coor(:,1)=ndata(:,1);coor(:,2)=ndata(:,2);

scores_maps13=[coor,score2(:,2)];
save('scores_maps3.mat','scores_maps3');


gt_labels13=[623,1121];
save('gt_labels3.mat','gt_labels3');


[fpi, per_lesion_sensitivity] = froc(scores_maps, gt_labels,0)
plot_froc(per_lesion_sensitivity, fpi)

%% KNN
Mdl = fitcknn(F,lab,'NumNeighbors',1,'Standardize',1)
[label3,score3]   =   predict(Mdl, TT)
%% src
obj = fitcdiscr(F,lab);
[label4,score4]   =   predict(obj, TT)
%% svm
SVMModel = fitcsvm(F,lab,'KernelScale','auto','Standardize',true,...
    'OutlierFraction',0.05)
[label5,score5]   =   predict(SVMModel, TT)

