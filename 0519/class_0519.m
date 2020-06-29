clc,clear all
MA=load('E:\WZZ\OneDrive\0407\MA_MAT\FMA.mat');%%不曾去除干扰数据
nonMA=load('E:\WZZ\OneDrive\0407\nonMA_MAT\FnonMA.mat');
f1=MA.F(:,1:21);
f2=nonMA.F(:,1:21);
lab1=ones(94,1);
lab2=zeros(143,1);
F=[f2;f1];
lab=[lab2;lab1];
% mdl= fitensemble(F,lab,'GentleBoost',200,'Tree'); %%分类器建立模型
ClassTreeEns = fitensemble(F,lab,'GentleBoost',50,'Tree')
rsLoss = resubLoss(ClassTreeEns,'Mode','Cumulative')
ss = sum(rsLoss(:))/50
plot(rsLoss);
xlabel('Number of trees');  
ylabel('Regression error');  
imgnum=[3,10,13,21,22,24,28,33,42,46];
%% get scores_maps.mat
for i=1:length(imgnum)
    testMatName=strcat('test',num2str(imgnum(i)),'.mat');
    test=load(testMatName);
    TT=test.F(:,1:21);
    [label2,score2] = predict(mdl,TT);
    excelName=strcat('D:\test',num2str(imgnum(i)),'.xlsx');
    [ndata]=xlsread(excelName);
    coor(:,1)=ndata(:,1);coor(:,2)=ndata(:,2);
    scores_maps{i}=[coor,score2(:,2),label2];
    clear coor;
end
save('scores_maps.mat','scores_maps');
%% 读取label=1的，对其进行与groundtruth对比,找出TP和FP。
load('scores_maps.mat');
load('gt_labels.mat');
for i = 1 : length(scores_maps)
    current_count=0;
    coor=cell2mat(scores_maps(i)); 
    coorG=cell2mat(gt_labels(i));
    for j = 1:size(coor,1)
        if coor(j,4)==1
            x=coor(j,1);y=coor(j,2);
            for jj=1:size(coorG,1);
                X=coorG(jj,1);Y=coorG(jj,2);
                d=sqrt((x-X)*(x-X)+(y-Y)*(y-Y));
                if d<=10
                    current_count=current_count+1;
                    break;
                end
            end
        end
    end
    TP(i)=current_count;FP(i)=length(find(coor(:,4)==1))-current_count;
end
save('TPsvm.mat','TP');
save('FPsvm.mat','FP');
%% 绘制FROC
froc(TP,FP)
%% 五个curve 绘制
root =pwd;
addpath(genpath(fullfile(root,'EN'))) ;
addpath(genpath(fullfile(root,'KNN'))) ;
addpath(genpath(fullfile(root,'NB'))) ;
addpath(genpath(fullfile(root,'SCR'))) ;
addpath(genpath(fullfile(root,'SVM'))) ;
FP=load('FPen.mat');
TP=load('TPen.mat');
[fpAVE,tpr]=froc(TP.TP,FP.FP);
plot(fpAVE,tpr,'-r','LineWidth',1);
axis([10^(-1) 90 0 0.8])
xlabel('Average number of FPs per image');  
ylabel('Sensitivity');  
hold on

FP=load('FPNB.mat');
TP=load('TPNB.mat');
[fpAVE,tpr]=froc(TP.TP,FP.FP);
plot(fpAVE,tpr,'-b','LineWidth',1);
hold on
FP=load('FPscr.mat');
TP=load('TPscr.mat');
[fpAVE,tpr]=froc(TP.TP,FP.FP);
plot(fpAVE,tpr,'-.m','LineWidth',1);
hold on

FP=load('FPsvm.mat');
TP=load('TPsvm.mat');
[fpAVE,tpr]=froc(TP.TP,FP.FP);
plot(fpAVE,tpr,'--g','LineWidth',1);
hold on

FP=load('FPknn.mat');
TP=load('TPknn.mat');
[fpAVE,tpr]=froc(TP.TP,FP.FP);
plot(fpAVE,tpr,':b','LineWidth',1);
h=legend('ENs','NB','DISCR','SVM','KNN','Location','southeast');


%% ensemble
ClassTreeEns = fitensemble(F,lab,'GentleBoost',200,'Tree')
%% NB
mdl = fitcnb(F,lab);
%% KNN
Mdl = fitcknn(F,lab,'NumNeighbors',1,'Standardize',1)
[label3,score3]   =   predict(Mdl, TT)
%% src
obj = fitcdiscr(F,lab);
[label4,score4]   =   predict(obj, TT)
%% svm
SVMModel = fitcsvm(F,lab,'KernelScale','auto','Standardize',true, 'OutlierFraction',0.05);
[label5,score5]   =   predict(SVMModel, TT)

%% 与lazar对比FROC curve

FP=load('FPen.mat');
TP=load('TPen.mat');
[fpAVE,tpr]=froc(TP.TP,FP.FP);
plot(fpAVE,tpr,'-r','LineWidth',1);
axis([10^(-1) 90 0 0.8])
xlabel('Average number of FPs per image');  
ylabel('Sensitivity');  
hold on

FP=load('FPNB.mat');
TP=load('TPNB.mat');
[fpAVE,tpr]=froc(TP.TP,FP.FP);
plot(fpAVE,tpr,'-b','LineWidth',1);
hold on


FP=load('E:\WZZ\OneDrive\0407\0519\Lazar\EN\FPen.mat');
TP=load('E:\WZZ\OneDrive\0407\0519\Lazar\EN\TPen.mat');
[fpAVE,tpr]=froc(TP.TP,FP.FP);
plot(fpAVE,tpr,'--r','LineWidth',1);
hold on

FP=load('E:\WZZ\OneDrive\0407\0519\Lazar\NB\FPNB.mat');
TP=load('E:\WZZ\OneDrive\0407\0519\Lazar\NB\TPNB.mat');
[fpAVE,tpr]=froc(TP.TP,FP.FP);
plot(fpAVE,tpr,'--b','LineWidth',1);

h=legend('ENs','NB','ENs_L','NB_L','Location','southeast');
