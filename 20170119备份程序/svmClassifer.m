% % %% load data
% % MA=load('D:\OneDrive\���մ���M\lazar1228ѵ��\MA_MAT\Ftotal.mat');
% % nonMA=load('D:\OneDrive\���մ���M\lazar1228ѵ��\nonMA_MAT\nonFtotal.mat');
% % totol=[MA.m;nonMA.m];
% % X = totol(:,1:13);%%����150*4
% % Y = totol(:,14);%%��ǩ150*1
% % rng(1); % For reproducibility
% % %% Create an SVM template. It is good practice to standardize the predictors.
% % t = templateSVM('Standardize',1);%When the software trains the ECOC classifier, it sets the applicable properties to their default values.
% % %% Train the ECOC classifier. It is good practice to specify the class order.
% % Mdl = fitcecoc(X,Y,'Learners',t,...
% %     'ClassNames',{'1','0'});
% % %% Cross validate Mdl using 10-fold cross validation
% % CVMdl = crossval(Mdl);
% % %% Estimate the generalization error
% % oosLoss = kfoldLoss(CVMdl)%%% Ч���ܲͨ��������֤�õ���ʧ�����0.4774


% % % MA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\MA_MAT\Ftotal.mat');
% % % nonMA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\nonMA_MAT\nonFtotalall.mat');
% % % totol=[MA.m;nonMA.m];
% % % X = totol(:,1:15);%%����150*4
% % % Y = totol(:,16);%%��ǩ150*1
% % % %% Train an SVM classifier using the processed data set.
% % % SVMModel = fitcsvm(X,Y)
% % % %% Cross validate the SVM classifier. By default, the software uses 10-fold cross validation.
% % % CVSVMModel = crossval(SVMModel);
% % % %% Estimate the out-of-sample misclassification rate.
% % % classLoss = kfoldLoss(CVSVMModel)%%%��ʱ��ѵ��������199����0.4548��������ʱѵ������MA199��nonMA306�� 0.3999

%% δ���й�һ������
%% K���ڷ����� ��KNN��
% clc ;clear all
% MA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\MA_MAT\Ftotal.mat');
% nonMA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\nonMA_MAT\nonFtotalall.mat');
% totol=[MA.m;nonMA.m];
% train_datama = totol(1:300,1:15);%%����150*4
% train_datanon =totol(1:550,1:15);
% train_data = [train_datama;train_datanon];
% train_labelma = totol(1:300,16);
% train_labelnon = totol(1:550,16);
% train_label = [train_labelma;train_labelnon];%%��ǩ150*1
% % test_datama = totol(301:336,1:15);%%����150*4
% % test_datanon =totol(551:600,1:15);
% % test_data = [test_datama;test_datanon];
% % test_labelma = totol(301:336,16);%%����150*4
% % test_labelnon =totol(551:600,16);
% % test_label = [test_labelma;test_labelnon];%%��ǩ150*1
% %% KNN
% tophat=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\��ѡ����ȡtophat\testTop.mat');
% test_data=tophat.FF;
% mdl = ClassificationKNN.fit(train_data,train_label,'NumNeighbors',1);
%Mdl = fitcknn(X,Y,'NumNeighbors',5,'Standardize',1)
% predict_label   =       predict(mdl, test_data);
% accuracy         =       length(find(predict_label == test_label))/length(test_label)*100 %%% 52.0408  56.1224�� 75.5814(1)  66.2791
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
% % MA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\MA_MAT\Ftotal.mat');
% % nonMA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\nonMA_MAT\nonFtotalall.mat');
% % totol=[MA.m;nonMA.m];
% % X = totol(:,1:15);%%����150*4
% % Y = totol(:,16);%%��ǩ150*1
% % BaggedEnsemble = TreeBagger(150,X,Y,'OOBPrediction','On',...
% %     'Method','classification')%%%150��Ѳ�����
% % oobErrorBaggedEnsemble = oobError(BaggedEnsemble);
% % plot(oobErrorBaggedEnsemble)%%%ͼ����ʾ����������������
% % xlabel 'Number of grown trees';
% % ylabel 'Out-of-bag classification error';


%% ���й�һ���������ݣ�����ٽ��з���

clc ;clear all
MA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\MA_MAT\Ftotal.mat');
nonMA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\nonMA_MAT\nonFtotalall.mat');
totol=[MA.m;nonMA.m];
% totol = normalization(totol,1);%%��һ���ɹ�
train_datama = totol(1:300,1:15);%%����150*4
train_datanon =totol(1:550,1:15);
train_data = [train_datama;train_datanon];
train_labelma = totol(1:300,16);
train_labelnon = totol(1:550,16);
train_label = [train_labelma;train_labelnon];%%��ǩ150*1
test_datama = totol(301:336,1:15);%%����150*4
test_datanon =totol(551:600,1:15);
test_data = [test_datama;test_datanon];
test_labelma = totol(301:336,16);%%����150*4
test_labelnon =totol(551:600,16);
test_label = [test_labelma;test_labelnon];%%��ǩ150*1
%% KNN
tophat=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\��ѡ����ȡtophat\testTop27.mat');
test_data=tophat.FF;
% mdl = ClassificationKNN.fit(train_data,train_label,'NumNeighbors',1);
Mdl = fitcknn(train_data,train_label,'NumNeighbors',1,'Standardize',1)
predict_label   =       predict(Mdl, test_data);
save('predict_label27.mat','predict_label');
% accuracy         =       length(find(predict_label == test_label))/length(test_label)*100 %%% 52.0408  56.1224�� 75.5814(1)  66.2791  ��һ����74.4186��1��
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
% % MA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\MA_MAT\Ftotal.mat');
% % nonMA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\nonMA_MAT\nonFtotalall.mat');
% % totol=[MA.m;nonMA.m];
% % X = totol(:,1:15);%%����150*4
% % Y = totol(:,16);%%��ǩ150*1
% % BaggedEnsemble = TreeBagger(150,X,Y,'OOBPrediction','On',...
% %     'Method','classification')%%%150��Ѳ�����
% % oobErrorBaggedEnsemble = oobError(BaggedEnsemble);
% % plot(oobErrorBaggedEnsemble)%%%ͼ����ʾ����������������
% % xlabel 'Number of grown trees';
% % ylabel 'Out-of-bag classification error';









