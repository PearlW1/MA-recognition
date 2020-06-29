clc,clear all
MA=load('E:\WZZ\OneDrive\0407\MA_MAT\FMA.mat');%%不曾去除干扰数据
nonMA=load('E:\WZZ\OneDrive\0407\nonMA_MAT\FnonMA.mat');
f1=MA.F(:,1:21);
f2=nonMA.F(:,1:21);
lab1=ones(94,1);
lab2=zeros(143,1);
F=[f2;f1];
lab=[lab2;lab1];
lab=logical(lab);

%% svm模型生成
mdl = fitcknn(F,lab,'NumNeighbors',7,'Standardize',1);

%% 载入测试数据
imgnum=[3,10,13,21,22,24,28,33,42,46];
% 代表预测的结果label，还有数据
for i=1:length(imgnum)
    testMatName=strcat('E:\WZZ\OneDrive\0407\0519\test',num2str(imgnum(i)),'.mat');
    test=load(testMatName);
    testdataM{i}=test.F(:,1:21);%测试数据
end
save('testdataM.mat','testdataM');
ttt=[];
for i=1:10
    tt=testdataM{i};
    ttt=[ttt;tt];%% 测试数据
end
XTest=ttt;

%% knn
load('E:\WZZ\OneDrive\0407\0519\SCR\scores_maps.mat');
load('E:\WZZ\OneDrive\0407\0519\SCR\gt_labels.mat');
for  i= 1 : length(scores_maps)
    clear testlabel;
    current_count=0;
    coor=cell2mat(scores_maps(i)); 
    coorG=cell2mat(gt_labels(i));
    for j = 1:size(coor,1)
            x=coor(j,1);y=coor(j,2);
            for jj=1:size(coorG,1);
                X=coorG(jj,1);Y=coorG(jj,2);
                d=sqrt((x-X)*(x-X)+(y-Y)*(y-Y));
                if d<=10
                    testlabel(j,1)=1;
                else
                    testlabel(j,1)=0;
                end
            end
    end
    
   LABELEN{i}=testlabel(:,1);
end
save('E:\WZZ\OneDrive\0407\0519\SCR\LABELEN.mat','LABELEN');   
lll=[];
for i=1:10
    ll=LABELEN{i};
    lll=[lll;ll];%%label
end
lllabel=logical(lll);

%% 预测数据集合
[prelabel,score] = predict(mdl,XTest)

%% 绘制曲线
[Xsvm,Ysvm,Tsvm,AUCsvm] = perfcurve(lllabel,score(:,2),'true');
 
plot(Xsvm,Ysvm,'-r','LineWidth',1);
xlabel('假正例率');  
ylabel('真正例率'); 
hold on
AUCsvm

%% 开始计算se sp acc 最后将auc也放上去
tp=0;fn=0;fp=0;tn=0;
for i= 1:length(prelabel)
    if (prelabel(i)==1)&&(lllabel(i)==1)
        tp=tp+1;
    end
    if (prelabel(i)==0)&&(lllabel(i)==1)
        fn=fn+1;
    end
    if (prelabel(i)==1)&&(lllabel(i)==0)
        fp=fp+1;
    end
    if (prelabel(i)==0)&&(lllabel(i)==0)
        tn=tn+1;
    end
end


se=tp/(tp+fn)%查准率
sp=tn/(tn+fp)
acc=(tp+tn)/(tp+tn+fp+fn)
result=[se,sp,acc,AUCsvm];
save('E:\WZZ\OneDrive\0407\0519\SCR\result.mat','result');