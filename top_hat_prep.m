clc
clear all
imgnum=2;%%图像的次序
% imgnames=strcat('E:\WZZ\ROC_db\ROCtraining\image',num2str(imgnum),'_training.jpg');
% imgnames=strcat('D:\wzz\AWZZ\ROCtraining_RGB\image',num2str(imgnum),'_training.jpg');
imgnames=strcat('D:\wzz\AWZZ\DB\diaretdb1_v_1_1\diaretdb1_v_1_1\resources\images\ddb1_fundusimages\image00',num2str(imgnum),'.png');
I=imread(imgnames);figure;imshow(I,[]);
% I=imread('D:\wzz\AWZZ\ROCtraining_RGB\image13_training.jpg');
% I=imread('C:\Users\Administrator\Desktop\35.png');
f=double(I(:,:,2));
f0=double(I(:,:,2));%%提取绿色通道
% f= adapthisteq(f,'clipLimit',0.01,'Distribution','rayleigh');%%输入需要是uint8, uint16, int16, single, or double，不过double的好像不行，原始数据时unit
[m,n]=size(f0);
Ibg=medfilt2(f,[25 25]);%%%背景图像的获取
Isc=Ibg-f;%%%%从绿色通道图像中移除背景
%%%%%%the start of top-hat%%%%%
pic=[];degrees=[0,15,30,45,60,75,90,105,120,135,150,165];
for i=1:12
    se = strel('line',9,degrees(i));     % line, length 9, angle 45 degrees
    fo=imopen(Isc,se);%直接开运算
    [m,n]=size(fo);
    fonew=reshape(fo,m*n,1);
    pic=[pic,fonew];
end
picnew=max(pic,[],2);
fo11=reshape(picnew,m,n);%%%top-hat results
Ilesion=Isc-fo11;
%%%%%%%%the end of top-hat%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%使微小血管瘤从背景中更加的凸显，对Ilesion进行高斯滤波
h = fspecial('gaussian',[11,11],1);
Imatchnew=conv2(Ilesion,h);
% figure,imshow(Imatchnew,[]);
Imatchnew1=Imatchnew./255;
IID=find(Imatchnew1<max(Imatchnew1(:)*0.3));%%%对其进行阈值化，进一步来缩小候选解的数量
Imatchnew1(IID)=0;
figure,imshow(Imatchnew1,[]);
%%%%%%%%%%%%%%%%%%预处理过程结束%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img=imresize(Imatchnew1,[m,n]);
clear LL1;
LL1=bwlabel(img);%%%求解出图像中点的边界
Ibg=medfilt2(f,[25 25]);%%%背景图像的获取
s = regionprops(LL1,'centroid');
centroids = cat(1, s.Centroid);%%plot(centroids(:,1),centroids(:,2), 'b*')
[mm,nn]=size(centroids);
for ii=1:mm
    seed(ii,:)=[round(centroids(ii,1)),round(centroids(ii,2))];%%%先行后列
end
% figure,imshow(I,[]),hold on
% plot(centroids(:,1),centroids(:,2), 'b*')%%centroids(:,1)时 X、,centroids(:,2)时Y
%% 得到的种子点需要首先进行筛选，因为有些点会在边缘处，边缘不能进行15个像素的计算，所以此处可以进行一个边缘，如果种子点方圆15个像素之外没像素的，则将其舍去
k=1;%clear seed1  
for t=1:mm
    if (seed(t,1)-16)>0 && (seed(t,1)+16)<n && (seed(t,2)-16)>0 && (seed(t,2)+16)<m %%m是行，n是列
        seed1(k,1)=seed(t,1);
        seed1(k,2)=seed(t,2);%%保存坐标满足统计特征的点
        k=k+1;
    end
end

%% %%%%%%%%%%%%%前面是预处理和候选解提取，这里采用的是顶帽变换的坐标，原来lazar的预处理处理resize，别的还是正常需要的，接下来是轮廓线提取
Igreen = I(:,:,2);%%%绿色通道
% figure,imshow(Igreen,[]);
Ienh= adapthisteq(Igreen,'clipLimit',0.01,'Distribution','rayleigh');%%输入需要是uint8, uint16, int16, single, or double，不过double的好像不行，原始数据时unit
Iinv=255-Ienh;%%%%绿色通道取反
f = fspecial('gaussian',[3 3],1.0);%%h = fspecial('gaussian', hsize, sigma)
Ismooth = imfilter(Iinv,f,'same');%%%%%高斯平滑，或者可用conv2,nlfilter,能够得到类似滑窗的效果
Ismooth=double(Ismooth);
% imshow(Ismooth,[]);
r=15;x1=1:31;tt=1;
[mmm,nnn]=size(seed1);
for iii=1:mmm
    row=seed1(iii,2);col=seed1(iii,1);
    [degrees,P]=cross_profile(Ismooth,row,col,r);%%%计算横截面轮廓线，返回角度值，和8*31的P矩阵，包含轮廓线亮度值。
    for j=1:8
        PP=P(j,:);
%         figure,plot(PP);      
        [pks,locs,widths,proms] = findpeaks(PP,'MinPeakProminence',2)%%pks:峰们的亮度值，locs:峰尖们的横坐标索引，widths:峰们的腰宽度，pros:凸出的程度，峰高度。
        if isempty(locs)%%isempty(A) returns logical 1 (true) if A is an empty array
            break;
        else
            [wvalmax,locsidx]=max(widths(:))
            [pvalmax,pidx]=max(proms(:))
            centeridx=locs(pidx)%%%返回每一个方向下的峰值中心。
        end
        [b1,c1,centeridx]=min_diff_height_gap(PP);
        [Fea]=feature_profile(b1,c1,PP,centeridx);
        Feat(j,:)=Fea(:); 
    end
    if isempty(locs)
        continue;%%continue时，则不再继续执行当前循环体内的程序语句
    else
        [F]=mu_xigma(Feat);
        FF(tt,:)=F(:);%%%每一行代表一个候选解的mu_xigma统计量
        seedend(tt,:)=[col,row];%%【X Y】的形式          %保存一下此时能够留下的候选解坐标。
        tt=tt+1;
    end
end
savename=strcat('testTop',num2str(imgnum),'.mat')
save(savename,'FF');

%% 进行分类
% MA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\候选解提取tophat\MA_MATpost\Ftotal.mat');%%只包含MA，不包含excel表格中roi部分
% nonMA=load('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\nonMA_MAT\nonFtotalall.mat');
MA=load('D:\OneDrive\掌握代码M\lazar1228训练\候选解提取tophat\MA_MATpost\Ftotal.mat');%%只包含MA，不包含excel表格中roi部分
nonMA=load('D:\OneDrive\掌握代码M\lazar1228训练\nonMA_MAT\nonFtotalall.mat');

totol=[MA.m;nonMA.m];
% totol = normalization(totol,1);%%归一化成功
train_datama = totol(1:104,1:15);%%数据150*4
train_datanon =totol(1:400,1:15);
train_data = [train_datama;train_datanon];
train_labelma = totol(1:104,16);
train_labelnon = totol(1:400,16);
train_label = [train_labelma;train_labelnon];%%标签150*1
% % % test_datama = totol(131:164,1:15);%%数据150*4
% % % test_datanon =totol(551:600,1:15);
% % % test_data = [test_datama;test_datanon];
% % % test_labelma = totol(131:164,16);%%数据150*4
% % % test_labelnon =totol(551:600,16);

%% KNN
tophat=load(savename);
test_data=tophat.FF;
% mdl = ClassificationKNN.fit(train_data,train_label,'NumNeighbors',1);
Mdl = fitcknn(train_data,train_label,'NumNeighbors',1,'Standardize',1)
predict_label   =       predict(Mdl, test_data);
predictname=strcat('predict_label',num2str(imgnum),'.mat');
save(predictname,'predict_label');
% accuracy         =       length(find(predict_label == test_label))/length(test_label)*100 %%% 52.0408  56.1224， 75.5814(1)  66.2791  归一化：74.4186（1）

predict=load(predictname);
predict_label=predict.predict_label;
numm=size(predict_label,1);
h=1;
for e=1:numm
    if predict_label(e)==1
        seedlabel(h,:)=seedend(e,:);
        h=h+1;
    end
end
figure,imshow(I,[]);hold on
plot(seedlabel(:,1),seedlabel(:,2),'b*');title('final');%%此时留下了8个候选解，视盘上有3个，血管上有两个。
G=[206	455
178	458
231	472
199	451
];
plot(G(:,1),G(:,2),'k*')
%% 距离计算，方圆是个像素都算准确
TPnum=0;
for eee=1:size(G,1)
    for ee=1:size(seedlabel,1)
        A=G(eee,:);
        B=seedlabel(ee,:);
        dist = norm(A-B);
%         dist=(G(eee,1)-seedlabel(ee,1))^2+
        if dist<=10
            TPnum=TPnum+1;%%返回能够正确检测的个数
        end
    end
end
 
fprintf('groundtruth 数量%d\n',size(G,1))%%groundtruth的数量
fprintf('TP %d\n', TPnum)%%MA检测倒的数量，与groundtruth对照后的结果
% fprintf('检测倒的候选解 %d\n', size(seedlabel,1))%%检测倒所有MA的数量
fprintf('检测倒的候选解FP %d\n', size(seedlabel,1)-TPnum)%%FP ：nonMA found as MA

  %d\n    

 %% 绘制FROC
 G=[1	5	7	4	4	4	1	10	10  2	2	1	9 ];%%groundtruth中坐标个数
 TP=[0	1	4	1	1	0	1	2	2  2	2	0	1 ];%%所能检测倒的坐标个数
 FP=[151	5	111 	583	 293	10  3  7  3  5	1001	5	79];%%经过筛选之后，去掉
 
 for u=1:length(G)
     sensitivity(u)=TP(u)/G(u);
     ave_Fp(u)=FP(u)/(sum(FP(:))/length(FP));
 end
 figure,plot(sort(ave_Fp(:)),sort(sensitivity(:)),'b*');
%  figure,plot(ave_Fp(:),sensitivity(:));
 xlabel 'average number of false positives per image';
 ylabel 'sensitivity';
  
 