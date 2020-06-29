clc
clear all
I=imread('E:\WZZ\ROC_db\ROCtraining\image29_training.jpg');%figure;imshow(I,[]);
% I=imread('D:\wzz\AWZZ\ROCtraining_RGB\image13_training.jpg');
% I=imread('C:\Users\Administrator\Desktop\35.png');
f=double(I(:,:,2));
f0=double(I(:,:,2));%%��ȡ��ɫͨ��
[m,n]=size(f0);
Ibg=medfilt2(f,[25 25]);%%%����ͼ��Ļ�ȡ
Isc=Ibg-f;%%%%����ɫͨ��ͼ�����Ƴ�����
%%%%%%the start of top-hat%%%%%
pic=[];degrees=[0,15,30,45,60,75,90,105,120,135,150,165];
for i=1:12
    se = strel('line',9,degrees(i));     % line, length 9, angle 45 degrees
    fo=imopen(Isc,se);%ֱ�ӿ�����
    [m,n]=size(fo);
    fonew=reshape(fo,m*n,1);
    pic=[pic,fonew];
end
picnew=max(pic,[],2);
fo11=reshape(picnew,m,n);%%%top-hat results
Ilesion=Isc-fo11;
%%%%%%%%the end of top-hat%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%ʹ΢СѪ�����ӱ����и��ӵ�͹�ԣ���Ilesion���и�˹�˲�
h = fspecial('gaussian',[11,11],1);
Imatchnew=conv2(Ilesion,h);
% figure,imshow(Imatchnew,[]);
Imatchnew1=Imatchnew./255;
IID=find(Imatchnew1<max(Imatchnew1(:)*0.2));%%%���������ֵ������һ������С��ѡ�������
Imatchnew1(IID)=0;
%%%%%%%%%%%%%%%%%%Ԥ������̽���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img=imresize(Imatchnew1,[576,768]);
clear LL1;
LL1=bwlabel(img);%%%����ͼ���е�ı߽�
Ibg=medfilt2(f,[25 25]);%%%����ͼ��Ļ�ȡ
s = regionprops(LL1,'centroid');
centroids = cat(1, s.Centroid);%%plot(centroids(:,1),centroids(:,2), 'b*')
[mm,nn]=size(centroids);
for ii=1:mm
    seed(ii,:)=[round(centroids(ii,1)),round(centroids(ii,2))];%%%���к���
end
% figure,imshow(I,[]),hold on
% plot(centroids(:,1),centroids(:,2), 'b*')%%centroids(:,1)ʱ X��,centroids(:,2)ʱY
%% �õ������ӵ���Ҫ���Ƚ���ɸѡ����Ϊ��Щ����ڱ�Ե������Ե���ܽ���15�����صļ��㣬���Դ˴����Խ���һ����Ե��������ӵ㷽Բ15������֮��û���صģ�������ȥ
k=1;%clear seed1  
for t=1:mm
    if (seed(t,1)-20)>0 && (seed(t,1)+20)<n && (seed(t,2)-20)>0 && (seed(t,2)+20)<m %%m���У�n����
        seed1(k,1)=seed(t,1);
        seed1(k,2)=seed(t,2);%%������������ͳ�������ĵ�
        k=k+1;
    end
end
% for t=1:mm
%     if (abs(seed(t,1)-n)>30)&&(abs(seed(t,2)-m)>30)%%m���У�n����
%         seed1(k,1)=seed(t,1);
%         seed1(k,2)=seed(t,2);%%������������ͳ�������ĵ�
%         k=k+1;
%     end
% end

figure,imshow(I,[]),hold on
plot(seed1(:,1),seed1(:,2), 'g*')%%centroids(:,1)ʱ X��,centroids(:,2)ʱY
G=[116	402
127	346
104	336
58	313
643	525
59	232
74	349
100	262
126	389
111	366
113	346
25	270
107	262
31	243
110	306
105	392
94	323
135	376
612	498
107	358
131	360
28	263
]
plot(G(:,1),G(:,2),'k*')
% imtool(I,[]);
%% %%%%%%%%%%%%%ǰ����Ԥ����ͺ�ѡ����ȡ��������õ��Ƕ�ñ�任�����꣬ԭ��lazar��Ԥ������resize����Ļ���������Ҫ�ģ�����������������ȡ
Igreen = I(:,:,2);%%%��ɫͨ��
% figure,imshow(Igreen,[]);
Ienh= adapthisteq(Igreen,'clipLimit',0.01,'Distribution','rayleigh');%%������Ҫ��uint8, uint16, int16, single, or double������double�ĺ����У�ԭʼ����ʱunit
Iinv=255-Ienh;%%%%��ɫͨ��ȡ��
f = fspecial('gaussian',[3 3],1.0);%%h = fspecial('gaussian', hsize, sigma)
Ismooth = imfilter(Iinv,f,'same');%%%%%��˹ƽ�������߿���conv2,nlfilter,�ܹ��õ����ƻ�����Ч��
Ismooth=double(Ismooth);
% imshow(Ismooth,[]);
r=15;x1=1:31;tt=1;
[mmm,nnn]=size(seed1);
for iii=1:mmm
    row=seed1(iii,2);col=seed1(iii,1);
    [degrees,P]=cross_profile(Ismooth,row,col,r);%%%�������������ߣ����ؽǶ�ֵ����8*31��P���󣬰�������������ֵ��
    for j=1:8
        PP=P(j,:);
%         figure,plot(PP);      
        [pks,locs,widths,proms] = findpeaks(PP,'MinPeakProminence',2)%%pks:���ǵ�����ֵ��locs:����ǵĺ�����������widths:���ǵ�����ȣ�pros:͹���ĳ̶ȣ���߶ȡ�
        if isempty(locs)%%isempty(A) returns logical 1 (true) if A is an empty array
            break;
        else
            [wvalmax,locsidx]=max(widths(:))
            [pvalmax,pidx]=max(proms(:))
            centeridx=locs(pidx)%%%����ÿһ�������µķ�ֵ���ġ�
        end
        [b1,c1,centeridx]=min_diff_height_gap(PP);
        [Fea]=feature_profile(b1,c1,PP,centeridx);
        Feat(j,:)=Fea(:); 
    end
    if isempty(locs)
        continue;%%continueʱ�����ټ���ִ�е�ǰѭ�����ڵĳ������
    else
        [F]=mu_xigma(Feat);
%     names=strcat('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\nonMA_MAT\','F',num2str(g),'.mat');
%     save(names,'F');
        FF(tt,:)=F(:);%%%ÿһ�д���һ����ѡ���mu_xigmaͳ����
        %����һ�´�ʱ�ܹ����µĺ�ѡ�����ꡣ
        seedend(tt,:)=[col,row];%%��X Y������ʽ
        tt=tt+1;
    end
end
save('testTop29.mat','FF');

%% ���з���
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
tophat=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\��ѡ����ȡtophat\testTop29.mat');
test_data=tophat.FF;
% mdl = ClassificationKNN.fit(train_data,train_label,'NumNeighbors',1);
Mdl = fitcknn(train_data,train_label,'NumNeighbors',15,'Standardize',1)
predict_label   =       predict(Mdl, test_data);
save('predict_label29.mat','predict_label');
% accuracy         =       length(find(predict_label == test_label))/length(test_label)*100 %%% 52.0408  56.1224�� 75.5814(1)  66.2791  ��һ����74.4186��1��




predict=load('predict_label29.mat');
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
plot(seedlabel(:,1),seedlabel(:,2),'b*');title('final');%%��ʱ������8����ѡ�⣬��������3����Ѫ������������
G=[116	402
127	346
104	336
58	313
643	525
59	232
74	349
100	262
126	389
111	366
113	346
25	270
107	262
31	243
110	306
105	392
94	323
135	376
612	498
107	358
131	360
28	263
]
plot(G(:,1),G(:,2),'k*')
       
%% lazar tabelI �����ݼ��㣬�����Ǹ�ɶ��˼    
MA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\MA_MAT\Ftotal.mat');
nonMA=load('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\nonMA_MAT\nonFtotalall.mat');
YY=MA.m;
mu_pw=mean(YY(:,1))
xigma_pw=std(YY(:,1))

xigma_tw=std(YY(:,4))
xigma_tw=std(YY(:,6))

cvheight=mean(YY(:,9))/(std(YY(:,9))+eps)

% for t=1:max(LL1(:))
%      LL=find(LL1==t);
%      img(LL)=1;%%%��ȡ��Ӧ�߽�����
%      boundary(:,:,t)=img;%%%������Ӧͼ���е�ÿһ������߽�
% end
 