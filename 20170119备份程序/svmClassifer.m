% % %% load data
% % MA=load('D:\OneDrive\掌握代码M\lazar1228训练\MA_MAT\Ftotal.mat');
% % nonMA=load('D:\OneDrive\掌握代码M\lazar1228训练\nonMA_MAT\nonFtotal.mat');
% % totol=[MA.m;nonMA.m];
% % X = totol(:,1:13);%%数据150*4
% % Y = totol(:,14);%%标签150*1
% % rng(1); % For reproducibility
% % %% Create an SVM template. It is good practice to standardize the predictors.
% % t = templateSVM('Standardize',1);%When the software trains the ECOC classifier, it sets the applicable properties to their default values.
% % %% Train the ECOC classifier. It is good practice to specify the class order.
% % Mdl = fitcecoc(X,Y,'Learners',t,...
% %     'ClassNames',{'1','0'});
% % %% Cross validate Mdl using 10-fold cross validation
% % CVMdl = crossval(Mdl);
% % %% Estimate the generalization error
% % oosLoss = kfoldLoss(CVMdl)%%% 效果很差，通过交叉验证得到损失误差是0.4774


% % % MA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\MA_MAT\Ftotal.mat');
% % % nonMA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\nonMA_MAT\nonFtotalall.mat');
% % % totol=[MA.m;nonMA.m];
% % % X = totol(:,1:15);%%数据150*4
% % % Y = totol(:,16);%%标签150*1
% % % %% Train an SVM classifier using the processed data set.
% % % SVMModel = fitcsvm(X,Y)
% % % %% Cross validate the SVM classifier. By default, the software uses 10-fold cross validation.
% % % CVSVMModel = crossval(SVMModel);
% % % %% Estimate the out-of-sample misclassification rate.
% % % classLoss = kfoldLoss(CVSVMModel)%%%此时《训练样本各199个，0.4548，，，此时训练样本MA199，nonMA306个 0.3999

%% 未进行归一化处理
%% K近邻分类器 （KNN）
% clc ;clear all
% MA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\MA_MAT\Ftotal.mat');
% nonMA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\nonMA_MAT\nonFtotalall.mat');
% totol=[MA.m;nonMA.m];
% train_datama = totol(1:300,1:15);%%数据150*4
% train_datanon =totol(1:550,1:15);
% train_data = [train_datama;train_datanon];
% train_labelma = totol(1:300,16);
% train_labelnon = totol(1:550,16);
% train_label = [train_labelma;train_labelnon];%%标签150*1
% % test_datama = totol(301:336,1:15);%%数据150*4
% % test_datanon =totol(551:600,1:15);
% % test_data = [test_datama;test_datanon];
% % test_labelma = totol(301:336,16);%%数据150*4
% % test_labelnon =totol(551:600,16);
% % test_label = [test_labelma;test_labelnon];%%标签150*1
% %% KNN
% tophat=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\候选解提取tophat\testTop.mat');
% test_data=tophat.FF;
% mdl = ClassificationKNN.fit(train_data,train_label,'NumNeighbors',1);
%Mdl = fitcknn(X,Y,'NumNeighbors',5,'Standardize',1)
% predict_label   =       predict(mdl, test_data);
% accuracy         =       length(find(predict_label == test_label))/length(test_label)*100 %%% 52.0408  56.1224， 75.5814(1)  66.2791
%% naive bayes
% nb = NaiveBayes.fit(train_data, train_label);
% predict_label   =       predict(nb, test_data);
% accuracy         =       length(find(predict_label == test_label))/length(test_label)*100 %%% 47.9592%%53.0612   %%% 66.2791

% Mdl = fitcnb(tbl,ResponseVarName);
%% discriminant 
% obj = ClassificationDiscriminant.fit(train_data, train_label);
% predict_label   =       predict(obj, test_data);
% accuracy         =       length(find(predict_label == test_label))/length(test_label)%%%  0.4898@@ 0.5204
%% Random Forest
% B = TreeBagger(13,train_data,train_label);
% predict_label = predict(B,test_data);
% accuracy         =       length(find(predict_label == test_label))/length(test_label)
% % clc ;clear all
% % MA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\MA_MAT\Ftotal.mat');
% % nonMA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\nonMA_MAT\nonFtotalall.mat');
% % totol=[MA.m;nonMA.m];
% % X = totol(:,1:15);%%数据150*4
% % Y = totol(:,16);%%标签150*1
% % BaggedEnsemble = TreeBagger(150,X,Y,'OOBPrediction','On',...
% %     'Method','classification')%%%150最佳参数树
% % oobErrorBaggedEnsemble = oobError(BaggedEnsemble);
% % plot(oobErrorBaggedEnsemble)%%%图像显示：不收敛。。。。
% % xlabel 'Number of grown trees';
% % ylabel 'Out-of-bag classification error';


%% 进行归一化处理数据，最后再进行分类

clc ;clear all
MA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\MA_MAT\Ftotal.mat');
nonMA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\nonMA_MAT\nonFtotalall.mat');
totol=[MA.m;nonMA.m];
% totol = normalization(totol,1);%%归一化成功
train_datama = totol(1:300,1:15);%%数据150*4
train_datanon =totol(1:550,1:15);
train_data = [train_datama;train_datanon];
train_labelma = totol(1:300,16);
train_labelnon = totol(1:550,16);
train_label = [train_labelma;train_labelnon];%%标签150*1
test_datama = totol(301:336,1:15);%%数据150*4
test_datanon =totol(551:600,1:15);
test_data = [test_datama;test_datanon];
test_labelma = totol(301:336,16);%%数据150*4
test_labelnon =totol(551:600,16);
test_label = [test_labelma;test_labelnon];%%标签150*1
%% KNN
tophat=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\候选解提取tophat\testTop27.mat');
test_data=tophat.FF;
% mdl = ClassificationKNN.fit(train_data,train_label,'NumNeighbors',1);
Mdl = fitcknn(train_data,train_label,'NumNeighbors',1,'Standardize',1)
predict_label   =       predict(Mdl, test_data);
save('predict_label27.mat','predict_label');
% accuracy         =       length(find(predict_label == test_label))/length(test_label)*100 %%% 52.0408  56.1224， 75.5814(1)  66.2791  归一化：74.4186（1）
%% naive bayes
% nb = NaiveBayes.fit(train_data, train_label);
% predict_label   =       predict(nb, test_data);
% accuracy         =       length(find(predict_label == test_label))/length(test_label)*100 %%% 47.9592%%53.0612   %%% 66.2791

% Mdl = fitcnb(tbl,ResponseVarName);
%% discriminant 
% obj = ClassificationDiscriminant.fit(train_data, train_label);
% predict_label   =       predict(obj, test_data);
% accuracy         =       length(find(predict_label == test_label))/length(test_label)%%%  0.4898@@ 0.5204
%% Random Forest
% B = TreeBagger(13,train_data,train_label);
% predict_label = predict(B,test_data);
% accuracy         =       length(find(predict_label == test_label))/length(test_label)
% % clc ;clear all
% % MA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\MA_MAT\Ftotal.mat');
% % nonMA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\nonMA_MAT\nonFtotalall.mat');
% % totol=[MA.m;nonMA.m];
% % X = totol(:,1:15);%%数据150*4
% % Y = totol(:,16);%%标签150*1
% % BaggedEnsemble = TreeBagger(150,X,Y,'OOBPrediction','On',...
% %     'Method','classification')%%%150最佳参数树
% % oobErrorBaggedEnsemble = oobError(BaggedEnsemble);
% % plot(oobErrorBaggedEnsemble)%%%图像显示：不收敛。。。。
% % xlabel 'Number of grown trees';
% % ylabel 'Out-of-bag classification error';









