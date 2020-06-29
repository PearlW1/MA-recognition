% clc;
% clear all
% %%预处理阶段++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% number=17;
% input=strcat('D:\wzz\AWZZ\ROCtraining_RGB\image',num2str(number),'_training.jpg');
% I = imread(input);
% Igreen=I(:,:,2);% Igreen = double(I(:,:,2));%%%绿色通道
% figure,imshow(Igreen,[]);
% [x,y]=ginput(100);%%读入图像，点上坐标
% X = round(x)%%将小数变为整数
% Y =round(y)
% imtool(Igreen,[]);
% figure,imshow(Igreen,[]);
% imtool(Igreen,[]);
% % Ienh= adapthisteq(Igreen,'clipLimit',0.01,'Distribution','rayleigh');%%输入需要是uint8, uint16, int16, single, or double，不过double的好像不行，原始数据时unit
% % % figure,imshow(Ienh,[]);
% % Iinv=255-Igreen;%%%%绿色通道取反
% % f = fspecial('gaussian',[3 3],1.0);%%h = fspecial('gaussian', hsize, sigma)
% % Ismooth = imfilter(Iinv,f,'same');%%%%%高斯平滑，或者可用conv2,nlfilter,能够得到类似滑窗的效果
% % % Iresize = imresize(Ismooth,[540 540],'bilinear');
% % % figure,imshow(Ismooth,[]);
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%预处理结束+++++++++++++++++++++++++++++++++
% % txt=dlmread('coornon1.txt');%%读取坐标
% % g=261;
% % for j=1:100
% %     row=txt(j,2);
% %     col=txt(j,1);
% %     r=15;x=1:31;%%	row=282;col=189;%%536	247%259	18
% %     Ismooth=double(Ismooth);
% %     [degrees,P]=cross_profile(Ismooth,row,col,r);
% %     Feat=[];
% %     for i=1:8
% %         PP=P(i,:);
% % %     figure,plot(x,PP);
% %         [b1,c1,centeridx]=min_diff_height_gap(PP);
% %         [Fea]=feature_profile(b1,c1,PP,centeridx);
% %         Feat(i,:)=Fea(:); 
% %     end
% %     [F]=mu_xigma(Feat)
% %     names=strcat('F',num2str(g),'.mat');
% %     save(names,'F');
% %     k=[names,'  ',strcat('img',num2str(number)),'  ',num2str(col),'  ',num2str(row)];%%mat文件名字，图像序号，x坐标，y坐标
% %     fid=fopen('nonmat.txt','at');%%'wt'以写的方式打开文件，，‘at’以续写的方式打开文件
% %     fprintf(fid,'\n%s %s %s  %s  %s %s  %s',k);
% %     fclose(fid);
% %     g=g+1;
% % end

%2017 1 10上午修改 
clc,clear all;
% [ndata, text, alldata] = xlsread('C:\Users\Administrator\Desktop\roclabel.xls');
[ndata, text, alldata] = xlsread('E:\WZZ\OneDrive\文档\所写论文材料\lazar相关\pre20MA.xls');
% [ndata, text, alldata] = xlsread('E:\WZZ\OneDrive\文档\所写论文材料\lazar相关\nonMA.xlsx');
npose=size(ndata,1);
r=15;%x=1:31;%%	row=282;col=189;%%536	247%259	18
g=1;
 for i=1:1:size(ndata,1)%%i=54
     x(i)=ndata(i,1);
     y(i)=ndata(i,2);
     filename{i}=text(i+1,1);%%需要特别注意，nonMA.xlsx文件下，没有第一行的说明，所以此处：不需要进行text(i+1,1),区别于MA.xlsx
     nm=strcat('E:\WZZ\ROC_db\ROCtraining\',char(filename{i}));
%      image=imread(char(filename{i}));
     image=imread(nm);
     Igreen=image(:,:,2);% Igreen = double(I(:,:,2));%%%绿色通道
     Ienh= adapthisteq(Igreen,'clipLimit',0.01,'Distribution','rayleigh');%%输入需要是uint8, uint16, int16, single, or double，不过double的好像不行，原始数据时unit
     Iinv=255-Igreen;%%%%绿色通道取反
     f = fspecial('gaussian',[3 3],1.0);%%h = fspecial('gaussian', hsize, sigma)
     Ismooth = imfilter(Iinv,f,'same');%%%%%高斯平滑，或者可用conv2,nlfilter,能够得到类似滑窗的效果
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%预处理结束+++++++++++++++++++++++++++++++++
    row=y(i);
    col=x(i);
    Ismooth=double(Ismooth);
    [degrees,P]=cross_profile(Ismooth,row,col,r);%% 返回三个参数
    for j=1:8
        PP=P(j,:);
%     figure,plot(x,PP);
        [b1,c1,centeridx]=min_diff_height_gap(PP);
        [Fea]=feature_profile(b1,c1,PP,centeridx);
        Feat(j,:)=Fea(:); 
    end
    [F]=mu_xigma(Feat);
    names=strcat('E:\WZZ\OneDrive\掌握代码M\lazar1228训练\候选解提取tophat\MA_MATpre\','F',num2str(g),'.mat');
    save(names,'F');
    g=g+1;
 end
  

 
%   if(~isempty(char(filenameroi{i})))
%      patch=image(y(i)-r:y(i)+r,x(i)-r:x(i)+r);
%     % imwrite(patch,(strcat(num2str(j),'_',char(filename{i}),'_',char(filenameroi{i}),'_R_5.jpg')));
%       imwrite(patch,(strcat(num2str(j),'ROI_10.jpg')));%标出顺序的ROI区域，不能显示出是哪副图像的ROI，这样命名的好处是便于下次处理时的循环调用。将数字个字符串粘贴在一起的时，需要将其转换成字符，num2str（数字）
%     j=j+1; 
%   end





% % %     r=15;x1=1:31;
% % %     [degrees,P]=cross_profile(Ismooth,row,col,r);%%%计算横截面轮廓线，返回角度值，和8*31的P矩阵，包含轮廓线亮度值。
% % %     Feat=[];
% % %     PP=P(3,:);
% % %     figure,plot(PP);
% % %     output=smooth(PP,5);%%%加入数据平滑项
% % %     figure,plot(output); 
% % %     findpeaks(output,'MinPeakProminence',6,'Annotate','extents')
%    [pks,locs,widths,proms] = findpeaks(output)
%    [pks,locs,widths,proms] = findpeaks(PP)
      


        
% %     for i=1:8
% %         P1 = P(i,:);%%P代表90亮度值数组
% %         figure(1),plot(x1,P1,'*r');
% % %         figure(2),bar(P(i,:)-155);
% %         [b1,c1,centeridx]=min_diff_height_gap(P1);
% %         [Fea]=feature_profile(b1,c1,P1,centeridx);
% %         Feat(i,:)=Fea(:); 
% %     end
% %     [F]=mu_xigma(Feat);%%%一个MA得出一个F，此F保存下来作为MA的训练样本
% %     count_perimg=1;
% %     name=strcat('D:\OneDrive\掌握代码M\lazarMAmat\F_MA_',num2str(number),'_',num2str(count_perimg),'.mat')
% %     save(name,'F');
%     FF(iii,:)=F(:);%%%每一行代表一个候选解的mu_xigma统计量












% % row=351;col=197;% row=458;col=234;% row=351;col=197;%row=458;col=234;%row=312;col=271;% row=197;col=84;
% % r=15;
% x1=1:31;
% % [degrees,P]=cross_profile(Iresize,row,col,r);%%%计算横截面轮廓线，返回角度值，和8*31的P矩阵，包含轮廓线亮度值。
% P=[154.732337439556,154.349182227015,153.322796414260,153,152.677203585740,152.247682806306,151.876158596847,151.725931380939,151.849772784092,151.978839131709,151.779884120602,151.301635545969,150.854997728556,150.500590557076,150.328021358725,150.301635545969,150.602089977786,150.828611915801,150.526976369832,150.198955011107,151.000000000000,152.451862761878,153.252907750770,152.924886392046,151.801044988893,150.747092249229,150.274068619061,150.548137238122,150.924886392046,151.075113607954,151.198955011107];
% g=8;
% % P = P1(g,:);
% figure(1),plot(x1,P);
% % figure(2),bar(P1-155);
% % [b,c]=min_diff_height_gap(P)
% % [Fea]=feature_profile(b1,c1,P1)
% 
% [Valmax,maxdx]=max(P(:));%%Valmax：返回P中最大值，maxdx：返回最大值索引
% %%% 找次最优方法：找到最大的以后，把最大的值*-1，这样肯定就不是最大了
% P1=P;
% % P1(maxdx)=Valmax-100;
% % [Valsub,subdx]=max(P1);
% [pks,locs]=findpeaks(P,'minpeakdistance',3)
% % findpeaks(P,'minpeakdistance',3)
% findpeaks(P,'Threshold',0.2)
% findpeaks(P,'MinPeakProminence',1)




% data = [2 12 4 6 9 4 3 1 19 7];
% [pks,locs]=findpeaks(data,'minpeakdistance',3);


% % % % center=16;%%在随后的计算中，这个中心16不能做为center，需要由真正的valmax(来自min_diff_gap.m函数)中通过筛选得出的最值，看来上面这个函数的返回值需要多加一个 center！！
% % % % %% 如果超级奇怪的形状（没有下坡或者没有上坡，那么这样的肯定就不是MA，所以此时可以忽略，将其相应特征置为0，应该是合理的吧，因为没法计算）
% % % % Bnum = length(b);%%找出b数组的长度
% % % % Cnum = length(c);%%找出c数组的长度 %%%12 26晚上 此时c=0，因为我在min_diff_gap中如果c没进行运算，则赋值给c=0，默认为
% % % % if Bnum==1
% % % %     Fea=zeros(1,7);
% % % % else
% % % %     if Cnum==1
% % % %         Fea=zeros(1,7);
% % % %     else
% % % %         Wpeak = c(Cnum)-b(1);
% % % %         Wtop = c(1)-b(Bnum); %%%峰值15处，没有大于min_diff,所以舍去
% % % %         if length(b)==0
% % % %             Hinc=0;
% % % %         else
% % % %             Hinc=P(b(Bnum))-P(b(1));
% % % %         end
% % % %         if length(c)==0%%isempty(c)
% % % %             Hdec=0;
% % % %         else
% % % %             Hdec=P(c(1))-P(c(Cnum));
% % % %         end
% % % %         Sinc=Hinc/(b(Bnum)-b(1));
% % % %         Sdec=Hdec/(c(Cnum)-c(1));
% % % %         if P(b(1))>P(c(Cnum))
% % % %             Hpeak=P(center)-(c(Cnum)-center)/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(c(Cnum));
% % % %         elseif P(b(1))<P(c(Cnum))
% % % %             Hpeak=P(center)-(center-b(1))/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(b(1));%%按照此公式计算结果正确
% % % %         else
% % % %             Hpeak=Hinc;
% % % %         end
% % % %         Fea=[];Fea(1)=Wpeak;Fea(2)=Wtop;Fea(3)=Hinc;Fea(4)=Hdec;Fea(5)=Sinc;Fea(6)=Sdec;Fea(7)=Hpeak;
% % % %         fprintf('%f\n', Fea);
% % % %     end
% % % % end



















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%2016 12 22 晚上6点修改 MA的min_diff_height_gap.m不能顺利跑出线性血管和交叉血管的问题
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feat=[];
% for i=1:8
% %     figure(1),plot(x1,P(i,:),'*r');
% %     figure(2),bar(P(i,:)-155);
%     P1 = P(i,:);%%P代表90亮度值数组
%     [b1,c1]=min_diff_height_gap(P1)
%     [Fea]=feature_profile(b1,c1,P1)
%     Feat(i,:)=Fea(:);
% %     Feat(:,i)=Fea;
% end
% save('Feat_bigMA.mat','Feat');
% mu_pw=mean(Feat(:,1));
% xigma_pw=std(Feat(:,1));
% mu_tw=mean(Feat(:,2));
% xigma_tw=std(Feat(:,2));
% xigma_sinc=std(Feat(:,5));
% xigma_sdec=std(Feat(:,6));
% cv_hinc=std(Feat(:,3))/mean(Feat(:,3));
% cv_hdec=std(Feat(:,4))/mean(Feat(:,4));
% cv_pheight=std(Feat(:,7))/mean(Feat(:,7));
% F=[mu_pw,xigma_pw,mu_tw,xigma_tw,xigma_sinc,xigma_sdec,cv_hinc,cv_hdec,cv_pheight];
% save('FsmallMA.mat','F');




%%%y=mean(x)%求x的均值
%%%ystd=std(x)%求x的标准差
%%%cv=ystd/y.

% Feat=zeros();
% % % g=3;
% % % figure(1),plot(x1,P(g,:),'*r');
% % % figure(2),bar(P(g,:)-155);
% % % P = P(g,:);%%P代表90亮度值数组
% % % [b1,c1]=min_diff_height_gap(P)
% % % [Fea]=feature_profile(b1,c1,P)
% Feat=zeros(8,7);
% Feat(g,:)=Fea;
%%%结果 fea：
%20.7650   29.6555    6.9217    4.2365    1.0000   11.0000   26.7015
%27.7931   36.2656    3.0881    4.0295    1.0000   19.0000   27.5126
%21.6682   31.2556    7.2227    5.2093    1.0000   10.0000   24.0150
%15.4792   29.9877    7.7396    5.9975    1.0000    8.0000   24.7665
%12.1034   27.1177    4.0345    4.5196    1.0000   10.0000   25.6990
%19.0971   29.0990    6.3657    5.8198    1.0000    9.0000   25.9026
%23.9642   32.8102    5.9910    5.4684    1.0000   11.0000   24.4449
%14.5901   32.7094    4.8634    4.0887    1.0000   12.0000   26.7992




% % [b,c]=min_diff_height_gap(P);
% % [Fea]=feature_profile(b,c,P);%%%计算出一个P的七个属性值，fea是一个行向量
% for i=1:8
%     P=P(i,:);
%     [b,c]=min_diff_height_gap(P);
%     [Fea]=feature_profile(b,c,P);%%%计算出一个P的七个属性值，fea是一个行向量
%     Feat(i,:)=Fea;
% end
  
%%%还未进行mean standard difference cv等的计算
%%%y=mean(x)%求x的均值
%%%ystd=std(x)%求x的标准差
%%%cv=ystd/y.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2016 12 21 下去coding先找最大值，之后两边夹逼，找出increasing ramp，和decreasing ramp
% % % % % % P = P(1,:);
% % % % % % [Valmax,maxdx]=max(P(:));%%Valmax：返回P中最大值，maxdx：返回最大值索引
% % % % % % min_diff=2;
% % % % % % min_height=3;
% % % % % % max_gap=3;
% % % % % % b=zeros();%%存放increase ramp
% % % % % % c=zeros();%%存放decrease ramp
% % % % % % jj=0;
% % % % % % jjj=0;
% % % % % % for i=maxdx:-1:2%%%找 increase ramp
% % % % % %     jj=jj+1;
% % % % % %     if P(i)-P(i-1)>0 
% % % % % %         Inc(jj)=P(i-1);%%不能保存最大值P(maxdx),这个是要作为Wtop计算的
% % % % % %         b(jj)=i-1;%%b保存索引
% % % % % %     else
% % % % % %         break;%%直接跳出循环，别的ramp就不考虑
% % % % % %     end
% % % % % % end
% % % % % % %%%%%%%%%%%%%%%线判断是否满足min_diff,之后再进行gap的判断，如果gap满足，则将去掉的部分补上
% % % % % % b1=zeros();jjjj=1;
% % % % % % Inc1(1)=Inc(1);
% % % % % % b1(1)=b(1);
% % % % % % for ii=b(1):-1:b(end)%%%找 increase ramp
% % % % % %     jjjj=jjjj+1;
% % % % % %     if P(ii)-P(ii-1)>=min_diff 
% % % % % %         Inc1(jjjj)=P(ii-1);%%不能保存最大值P(maxdx),这个是要作为Wtop计算的
% % % % % %         b1(jjjj)=ii-1;%%b保存索引
% % % % % %     end
% % % % % % end
% % % % % % % b=b(end:-1:1);%%调整顺序，从ramp的 increase 左下进行计算
% % % % % % % b1=b1(end:-1:1);
% % % % % % Inc2=zeros();b2=zeros();
% % % % % % 
% % % % % % if length(b)-length(b1)>=2 %%%如果筛选后的b1<b，则将保留在Inc1的最后一个数，另一部分保留在Inc2中
% % % % % % %     b=b(end:-1:1);%%调整顺序，从ramp的 increase 左下进行计算
% % % % % % %     b1=b1(end:-1:1);
% % % % % %     for iii=b(1):1:b1(1)-1 %%从b中出去b1里面元素，进行遍历
% % % % % %         jjj=jjj+1;
% % % % % %         if abs(P(iii)-P(iii+1))>=min_diff
% % % % % %             Inc2(jjj)=P(iii);
% % % % % %             b2(jjj)=iii;
% % % % % %         end
% % % % % %     end%%%得出increase ramp的另一段，随后判断，夹层前后
% % % % % %     if b1(1)-b2(end)<=max_gap
% % % % % %        b1=b(end:-1:1);%%这里尚需要进一步改进
% % % % % %        b2=b(end:-1:1);
% % % % % %     end
% % % % % % else
% % % % % %        b1=b(end:-1:1);%%这里尚需要进一步改进
% % % % % %        b2=b(end:-1:1);
% % % % % % end %%12/21以上应该是正确的，逻辑上没有错误，我认为
% % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % Dec=zeros();
% % % % % % h=0;
% % % % % % for j=maxdx:1:31%%%找出decrease ramp
% % % % % %     h=h+1;
% % % % % %     if P(j)-P(j+1)>0
% % % % % %         Dec(h)=P(j+1);%%此时的Dec是从小到大的顺序，接下来无需倒序
% % % % % %         c(h)=j;%%此时的c是从小到大的顺序，接下来无需倒序
% % % % % %     else
% % % % % %         break;
% % % % % %     end
% % % % % % end
% % % % % % %%%%%%%%%%%%%%%线判断是否满足min_diff,之后再进行gap的判断，如果gap满足，则将去掉的部分补上
% % % % % % c1=zeros();hh=1;Dec1=zeros();
% % % % % % Dec1(1)=Dec(1);
% % % % % % c1(1)=c(1);
% % % % % % for e=c(1):1:c(end)%%%找 increase ramp
% % % % % %     hh=hh+1;
% % % % % %     if P(e)-P(e+1)>=min_diff 
% % % % % %         Dec1(hh)=P(e+1);%%不能保存最大值P(maxdx),这个是要作为Wtop计算的,从Inc1（2）开始循环保存下一个
% % % % % %         c1(hh)=e+1;%%b保存索引,从b（2）开始循环保存索引
% % % % % %     end
% % % % % % end
% % % % % % 
% % % % % % Dec2=zeros();c2=zeros();hhh=1;
% % % % % % Dec2(1)=P(c1(end)+1);%%%将下一段的第一个赋值给dec2（1），
% % % % % % c2(1)=c1(end)+1;
% % % % % % % if length(c1)<length(c) %%%如果筛选后的b1<b，则将保留在Dec1的最后一个数，另一部分保留在Dec2中
% % % % % %     if length(c)-length(c1)>2%%大于2，我至少可以计算一次diff 和gap
% % % % % %         for ee=c1(end)+1:1:c(end)-1
% % % % % %             hhh=hhh+1;
% % % % % %             if P(ee)-P(ee+1)>=min_diff
% % % % % %                 Dec2(hhh)=P(ee+1);
% % % % % %                 c2(hhh)=ee+1;
% % % % % %             end
% % % % % %         end
% % % % % %        if c2(1)-c1(end)<=max_gap
% % % % % %        c1=c;
% % % % % %        c2=c;
% % % % % %        end   
% % % % % %     else%%%就是说：length（c）-length（c1）<=2的时候，直接将其算为峰值的一部分。
% % % % % %         c1=c;%%%这是最终的赋值，将所有的中间值，都变成c 
% % % % % %         c2=c;
% % % % % %     end
% % % % % %     
        
    
    
    
    



% for i=maxdx:-1:2%%%找 increase ramp
%     jj=jj+1;
%     if P(i)-P(i-1)>=min_diff 
%         Inc(jj)=P(i-1);%%不能保存最大值P(maxdx),这个是要作为Wtop计算的
%         b(jj)=i;%%b保存索引
%     else
%         break;%%直接跳出循环，别的ramp就不考虑
%     end
% end
% Inc=Inc(end:-1:1);%%倒序，按照常规，由小到大的顺序
% b=b(end:-1:1);%%倒序，按照常规，由小到大的顺序

% for j=maxdx:1:31%%%找出decrease ramp
%     jjj=jjj+1;
%     if P(j)-P(j+1)>=min_diff
%         Dec(jjj)=P(j+1);%%此时的Dec是从小到大的顺序，接下来无需倒序
%         c(jjj)=j;%%此时的c是从小到大的顺序，接下来无需倒序
%     else
%         break;
%     end
% end
%%%%%%%%由上面得出 Inc ，Dec ，b，c，进行了min_diff的计算，为了控制峰值要锋利sharp，将尖锐的地方留着，用于计算特征们
% if Inc(end)-Inc(1)>=min_height
%     disp('right')
% else
%     b=0;
% end
% if Dec(1)-Dec(end)>=min_height
%     disp('left')
% else
%     c=0;
% end






%%%计算峰值属性
%%%首先计算上升下降，，sgn(P[i]-P[i-1])=sgn(P[i+1]-P[i]),正负号一致，表明处于同一个状态，异号：说明上升下降发生变化
%%%min_diff:相邻 像素的亮度差>=2,认为是ramp
%%%min_height:绝对差between the first and last value,>=3,是不是ramp的incs和inse对应的亮度差值呢？？？？？
%%%max_gap:两个连续ramp之间的差的最大值，必须<=3.
% figure(1),plot(x1,P(1,:),'*r');
% figure(3),plot(x1,P(1,:));
% figure(2),bar(P(1,:)-150);
% P = P(1,:);%%P代表亮度值数组
% min_diff=2;
% min_height=3;
% max_gap=3;
% R=zeros();%%ramp亮度值
% Inc=zeros();%%increase 亮度值
% Dec=zeros();%%decrease亮度值
% j=0;
% a=zeros();
% for i=2:31 %%遍历像素值，比较大小，找ramp
%     %% 先找哪里是ramp                       
%     if abs(P(i)-P(i-1))>=min_diff  %相邻亮度差大于min_diff的保存到R数组中
%         j=j+1;
%         R(j)=P(i);%%是ramp的保存 11个数
%         a(j)=i;%%%将R中相应坐标的索引保存到a数组中
% %         b=i;%%%保存循环中前一个i的值，
%     end 
% end
% b=zeros();
% c=zeros();
% jj=0;
% jjj=0;
% for ii=2:length(a) %%遍历R数组像素值，比较大小，上升和下降
%     %% 找出 increase 和decrease
%     if R(ii)-R(ii-1)>=0
%         jj=jj+1;
%         Inc(jj)=R(ii);
%         b(jj)=a(ii);%%保存R中留存到Inc数组的索引，序号
%     else 
%         jjj=jjj+1;
%         Dec(jjj)=R(ii);
%         c(jjj)=a(ii);%%保存R中留存到Dec数组的索引，序号能回到原来的profile中
%     end
% end
% 
% 
% 
% 
% %% 限制连续ramp，使得同一方向上的ramp里面不能超过最大间距max_gap,,,
% %%1:increase ramp,从大值向小值靠近 b=a(end:-1:1)
% B=zeros();u=0;
% B(1)=b(length(b));
% for t=length(b):-1:2
%         u=u+1;
%         B(u)=b(t);
%     if b(t)-b(t-1)<=max_gap
% %         u=u+1;
% %         B(u)=b(t);%%%如果没有break，还会自动筛选对比，此时结果：14 13 8 7，正常来说，8 7 就不应该存在了。。。
%     else          %%%加入break之后，一旦不满足<=max_gap,就会跳出整个循环。
%         break;%%%break与continue相似，也是经常与for while合用，但它不是继续执行下一个循环，而是退出循环体，继续执行循环体之外的程序。即终止循环！
%     end
% end
% B=B(end:-1:1);%%%此时B=13 14，按照正常顺序存在,随后特征程序里面的b换成B
% %%2:decrease ramp,从小值向大值靠近 
% C=zeros();v=1;
% C(1)=c(1);
% for tt=2:length(c)
%         v=v+1;
%         C(v)=c(tt);
%     if c(tt)-c(tt-1)<=max_gap
% %         v=v+1;
% %         C(v)=c(tt);
%     else
%         break;
%     end
% end
% %% 首先判断一下gap，判断是否满足不小于min_height，如果不满足，则直接将坐标索引b，c置为0，在接下来的程序中，可以判断一下，如果b=0，c=0，则不进行接下来的计算了
% bnum=length(B);
% cnum=length(C);
% if Inc(bnum)-Inc(1)<=min_height
%     b=0;
% end
% if Dec(1)-Dec(cnum)<=min_height
%     c=0;
% end







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%local maximum region extraction 局部极大值的获取，
% BW = imregionalmax(I)示例BW = imregionalmax(I)返回的二进制图像BW标识区域的最大值在I。区域最大值是连通的恒定强度值， t，其所有的外部边界像素的值小于t的像素。BW，设置为1的像素识别区域的最大值;其他的所有像素都设置为 0。
% BW = imregionalmax(I,conn)BW = imregionalmax(I,conn)计算区域的最大值，其中conn指定的连接。默认情况下， imregionalmax使用 8 连接社区 2 D 图像和三维图像 26 连接社区。
% gpuarrayBW = imregionalmax(gpuarrayI,___)
% BW = imregionalmax(Ismooth);
% figure(1),imshow(BW,[]),title('MAX');%%%效果并不是很好呢。。。

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LMR获取结束+++++++++++++++++++++++++++++++++
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cross profile scanning 横截面轮廓线获取
% Irota=imrotate(Iresize,45);
% imtool(Irota,[]);%%%%%以 上两行代码严重错误，，每次都要
%  imtool(Iresize,[]);%%%找到MA，长条，血管交叉点的坐标，此处系手动找点,得出的坐标是常规理解的坐标，跟MATLAB意义上的正好相反
%%%%%%%%%%%%%%%大MA（271,312）  小（84,197）  长条（234，  458）  血管交叉（197，351）常规意义上的坐标
% %%%%%%首先找出MA的交叉轮廓线，并绘制直方图，通过旋转原始图像，进行像素亮度提取 imrotate(a,35,'bilinear')
% %%%%%plot(Iresize((312-r):(312+r),271),'r');
% row=312;col=271;
% r=15;x1=1:31;
% y1=Iresize((row-r):(row+r),col);%%%大MA：90°
% figure,plot(x1,y1);legend('90°');
% min1=min(y1(:));
% ynew=y1-min1+1;figure,bar(ynew,'histc');
% hold on
% plot(x1,ynew,'r-');
% %%%计算峰值属性
% %%%首先计算上升下降，，sgn(P[i]-P[i-1])=sgn(P[i+1]-P[i]),正负号一致，表明处于同一个状态，异号：说明上升下降发生变化
% %%%min_diff:相邻 像素的亮度差>=2,认为是ramp
% %%%min_height:绝对差between the first and last value,>=3,是不是ramp的incs和inse对应的亮度差值呢？？？？？
% %%%max_gap:两个连续ramp之间的差的最大值，必须<=3.
% P = y1;%%P代表亮度值数组
% min_diff=2;
% min_height=3;
% max_gap=3;
% R=zeros();%%ramp亮度值
% Inc=zeros();%%increase 亮度值
% Dec=zeros();%%decrease亮度值
% j=0;
% a=zeros();
% for i=2:31 %%遍历像素值，比较大小，找ramp
%     %% 先找哪里是ramp                       
%     if abs(P(i)-P(i-1))>=min_diff  %相邻亮度差大于min_diff的保存到R数组中
%         j=j+1;
%         R(j)=P(i);%%是ramp的保存 11个数
%         a(j)=i;%%%将R中相应坐标的索引保存到a数组中
% %         b=i;%%%保存循环中前一个i的值，
%     end 
% end
% b=zeros();
% c=zeros();
% jj=0;
% jjj=0;
% for ii=2:length(a) %%遍历R数组像素值，比较大小，上升和下降
%     %% 找出 increase 和decrease
%     if R(ii)-R(ii-1)>0
%         jj=jj+1;
%         Inc(jj)=R(ii);
%         b(jj)=a(ii);%%保存R中留存到Inc数组的索引，序号
%     else 
%         jjj=jjj+1;
%         Dec(jjj)=R(ii);
%         c(jjj)=a(ii);%%保存R中留存到Dec数组的索引，序号能回到原来的profile中
%     end
% end

% %% 限制连续ramp，使得同一方向上的ramp里面不能超过最大间距max_gap,,,
% %%1:increase ramp,从大值向小值靠近 b=a(end:-1:1)
% B=zeros();u=0;
% B(1)=b(length(b));
% for t=length(b):-1:2
%     if b(t)-b(t-1)<=max_gap
%         u=u+1;
%         B(u)=b(t);%%%如果没有break，还会自动筛选对比，此时结果：14 13 8 7，正常来说，8 7 就不应该存在了。。。
%     else          %%%加入break之后，一旦不满足<=max_gap,就会跳出整个循环。
%         break;%%%break与continue相似，也是经常与for while合用，但它不是继续执行下一个循环，而是退出循环体，继续执行循环体之外的程序。即终止循环！
%     end
% end
% B=B(end:-1:1);%%%此时B=13 14，按照正常顺序存在,随后特征程序里面的b换成B
% %%2:decrease ramp,从小值向大值靠近 
% C=zeros();v=1;
% C(1)=c(1);
% for tt=2:length(c)
%     if c(tt)-c(tt-1)<=max_gap
%         v=v+1;
%         C(v)=c(tt);
%     else
%         break;
%     end
% end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%这里少进行一步：判断该ramp是不是连续的，没有设定必须小于max_gap，如有需要，随后进行
% %%%%%%开始计算特征
% center=16;%%最大值的位置，就是中心
% %% 特征一、 peak width=dec_e-inc_s
% Bnum = length(b);%%找出b数组的长度
% Cnum = length(c);%%找出c数组的长度
% Wpeak = c(Cnum)-b(1);
% %% 特征二、top width=dec_s-inc_e
% Wtop = c(1)-b(Bnum); %%%峰值15处，没有大于min_diff,所以舍去了
% %% 特征三、increase ramp height Hinc=P[inc_e]-P[inc_s]
% Hinc=P(b(Bnum))-P(b(1));
% %% 特征四、decrease ramp height Hdec=P[dec_s]-P[dec_e]
% Hdec=P(c(1))-P(c(Cnum));
% %% 特征五、increase ramp slope Sinc=Hinc/（inc_e-inc_s）
% Sinc=Hinc/(b(Bnum)-b(1));
% %% 特征六、decrease ramp slope Sdec=Hdec/(dec_e-dec_s)
% Sdec=Hdec/(c(Cnum)-c(1));
% %% 特征七、peak height  Hpeak=P[center]-(P[dec_e]-P[inc_s])/Wpeak*(center-inc_s)+P[inc_s]
% %Hpeak=P(center)-abs(P(c(Cnum))-P(b(1)))/Wpeak*(center-b(1))+P(b(1));
% %%%%情况1：P[inc_s]>P[dec_e]
% if P(b(1))>P(c(Cnum))
%     Hpeak=P(center)-(c(Cnum)-center)/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(c(Cnum));
% elseif P(b(1))<P(c(Cnum))
% %%%%情况2：P[inc_s]>P[dec_e]
%     Hpeak=P(center)-(center-b(1))/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(b(1));%%按照此公式计算结果正确
% else
% %%%%情况3：P[inc_s]=P[dec_e]
%     Hpeak=Hinc;
% end
% 
% %% 保存这些property于Fea中
% %Fea中的顺序：rhights set(inc dec),rslopes set(inc dec),Twidths set(top width),Pwidths set(peal width),Pheights set(peak height) 
% Fea=zeros();%%[31.320723457667300,23.473592304409350,3.915090432208412,7.824530768136451,2,13,23.427907440121260]
% Fea(1)=Hinc;
% Fea(2)=Hdec;
% Fea(3)=Sinc;
% Fea(4)=Sdec;
% Fea(5)=Wtop;
% Fea(6)=Wpeak;
% Fea(7)=Hpeak;
% save('Fea.mat','Fea');
% %%%自动默认increase在坐标16之前，decrease在之后

%%%%%%%%%%%%%%%%%%%%%%%%%%找着找着最后跟原来的轮廓线对不上号，来回重新保存亮度值，最后都不知道哪个亮度值是原始轮廓线上对应的亮度值
%%%%%找亮度最大值，之后往前面计算是increase，往后面计算是decrease,这个随后进行，目前上面方法好像并不智能，存在一些错误。。。14/12











% row=312;
% col=271;
% r=15;
% x0=1:31;
% y0=Iresize(row,(col-r):(col+r));%%%大MA：0°
% figure,plot(x0,y0);
% legend('0°');
% 
% r=15;
% x1=1:31;
% y1=Iresize((row-r):(row+r),col);%%%大MA：90°
% figure,plot(x1,y1);
% legend('90°');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以上属于成功求出大MA轮廓线的  0°和90°
% figure,plot(Iresize((row+r):(row-r),(col-r):(col+r)))%%%%%%%%%%%%%%%%%%问问师姐
% legend(' big MA 45');
% yy=Iresize((row+r):(row-r),(col-r):(col+r))%%%yy是空矩阵。。。。
% % % x45=1:31;
% % % y=zeros(1,15);
% % % yy=zeros(1,16);
% % % % ii=0;
% % % for i=1:1:r%%%线找出正45°的轮廓线行
% % %     y(i)=Iresize(row-i,col+i);%%%%从右边第一个坐标开始，得出的y
% % % end
% % % for i=1:1:r%%%%%这样表示最小的坐标从坐下到中心靠近
% % %     yy(r+1-i)=Iresize(row+i,col-i);%%%%%从最 左边的第一个像素开始，走到标记中心坐标 
% % % end
% % % yy(16)=Iresize(row,col);%%%%将yy（16）赋值为中心点坐标                       线列后行貌似就对。。。。。。。。。。。。。。
% % % yyy=[yy,y];%%%将这几个y坐标赋值给一个数组yyy
% % % figure,plot(x45,yyy);legend('big MA 45°');
% figure,bar(yyy);
% xlabel('X axis');
%%%%%%%%%%%%%%%%%%%%%%%%%以上是：big MA45°的程序，应该是对的。。。。
% x135=1:31;
% y=zeros(1,16);
% yy=zeros(1,15);
% for i=1:1:r%%%找出135
%     y(r+1-i)=Iresize(row-i,col-i);%%%%从右边第一个坐标开始，得出的y
% end
% for i=1:1:r%%%%%这样表示最小的坐标从坐下到中心靠近
%     yy(i)=Iresize(row+i,col+i);%%%%%从最 左边的第一个像素开始，走到标记中心坐标 
% end
% y(16)=Iresize(row,col);%%%%将yy（16）赋值为中心点坐标                       线列后行貌似就对。。。。。。。。。。。。。。
% yyy=[y,yy];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x135,yyy);legend('big MA 135°');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以上是big MA135的程序，应该是对的，主要注意扫描线的走向

% % x45=1:31;
% % y=zeros(1,16);
% % yy=zeros(1,15);
%%%线找出正tana=1/2,26.6°的轮廓线行
%%%%从右边第一个坐标开始，得出的y
% % y(1)=Iresize(row,col);%%第row行，两个像素
% % y(2)=Iresize(row,col+1);
% % y(3)=Iresize(row-1,col+2);%%第row-1行，两个像素
% % y(4)=Iresize(row-1,col+3);%%%%列一直在更新，只是行，更新的慢了一个步长
% % y(5)=Iresize(row-2,col+4);%%第row-1行，两个像素
% % y(6)=Iresize(row-2,col+5);%%%%列一直在更新，只是行，更新的慢了一个步长
% % y(7)=Iresize(row-3,col+6);%%第row-1行，两个像素
% % y(8)=Iresize(row-3,col+7);%%%%列一直在更新，只是行，更新的慢了一个步长
% % y(9)=Iresize(row-4,col+8);%%第row-1行，两个像素
% % y(10)=Iresize(row-4,col+9);%%%%列一直在更新，只是行，更新的慢了一个步长
% % y(11)=Iresize(row-5,col+10);%%第row-1行，两个像素
% % y(12)=Iresize(row-5,col+11);%%%%列一直在更新，只是行，更新的慢了一个步长
% % y(13)=Iresize(row-6,col+12);%%第row-1行，两个像素
% % y(14)=Iresize(row-6,col+13);%%%%列一直在更新，只是行，更新的慢了一个步长
% % y(15)=Iresize(row-7,col+14);%%第row-1行，两个像素
% % y(16)=Iresize(row-7,col+15);%%%%列一直在更新，只是行，更新的慢了一个步长
% % %%%%%%%%%开始另一半，左下部分，包含15个像素,此时需要倒序
% % yy(15)=Iresize(row+1,col-1);%%第row行，两个像素
% % yy(14)=Iresize(row+1,col-2);
% % yy(13)=Iresize(row+2,col-3);%%第row-1行，两个像素
% % yy(12)=Iresize(row+2,col-4);%%%%列一直在更新，只是行，更新的慢了一个步长
% % yy(11)=Iresize(row+3,col-5);%%第row-1行，两个像素
% % yy(10)=Iresize(row+3,col-6);%%%%列一直在更新，只是行，更新的慢了一个步长
% % yy(9)=Iresize(row+4,col-7);%%第row-1行，两个像素
% % yy(8)=Iresize(row+4,col-8);%%%%列一直在更新，只是行，更新的慢了一个步长
% % yy(7)=Iresize(row+5,col-9);%%第row-1行，两个像素
% % yy(6)=Iresize(row+5,col-10);%%%%列一直在更新，只是行，更新的慢了一个步长
% % yy(5)=Iresize(row+6,col-11);%%第row-1行，两个像素
% % yy(4)=Iresize(row+6,col-12);%%%%列一直在更新，只是行，更新的慢了一个步长
% % yy(3)=Iresize(row+7,col-13);%%第row-1行，两个像素
% % yy(2)=Iresize(row+7,col-14);%%%%列一直在更新，只是行，更新的慢了一个步长
% % yy(1)=Iresize(row+8,col-15);%%%%多出一个，因为这里是两个一更替，所以成对出现
% % 
% % yyy=[yy,y];%%%将这几个y坐标赋值给一个数组yyy
% % figure,plot(x45,yyy);legend('big MA 26.5°');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%bigMA26.5轮廓线
% % % 
% % % x45=1:31;
% % % y=zeros(1,16);
% % % yy=zeros(1,15);
% % % %线找出正tana=1/2,-26.6°的轮廓线行
% % % %%从右边第一个坐标开始，得出的y
% % % %%%%%%%%%%%%%%%遗憾的是，坐标写反了。。。。
% % % y(16)=Iresize(row,col);%%第row行，两个像素
% % % y(15)=Iresize(row,col-1);
% % % y(14)=Iresize(row-1,col-2);%%第row-1行，两个像素
% % % y(13)=Iresize(row-1,col-3);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(12)=Iresize(row-2,col-4);%%第row-1行，两个像素
% % % y(11)=Iresize(row-2,col-5);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(10)=Iresize(row-3,col-6);%%第row-1行，两个像素
% % % y(9)=Iresize(row-3,col-7);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(8)=Iresize(row-4,col-8);%%第row-1行，两个像素
% % % y(7)=Iresize(row-4,col-9);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(6)=Iresize(row-5,col-10);%%第row-1行，两个像素
% % % y(5)=Iresize(row-5,col-11);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(4)=Iresize(row-6,col-12);%%第row-1行，两个像素
% % % y(3)=Iresize(row-6,col-13);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(2)=Iresize(row-7,col-14);%%第row-1行，两个像素
% % % y(1)=Iresize(row-7,col-15);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % %%%%%%%%%开始另一半，左下部分，包含15个像素,此时需要倒序
% % % yy(1)=Iresize(row+1,col+1);%%第row行，两个像素
% % % yy(2)=Iresize(row+1,col+2);
% % % yy(3)=Iresize(row+2,col+3);%%第row-1行，两个像素
% % % yy(4)=Iresize(row+2,col+4);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(5)=Iresize(row+3,col+5);%%第row-1行，两个像素
% % % yy(6)=Iresize(row+3,col+6);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(7)=Iresize(row+4,col+7);%%第row-1行，两个像素
% % % yy(8)=Iresize(row+4,col+8);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(9)=Iresize(row+5,col+9);%%第row-1行，两个像素
% % % yy(10)=Iresize(row+5,col+10);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(11)=Iresize(row+6,col+11);%%第row-1行，两个像素
% % % yy(12)=Iresize(row+6,col+12);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(13)=Iresize(row+7,col+13);%%第row-1行，两个像素
% % % yy(14)=Iresize(row+7,col+14);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(15)=Iresize(row+8,col+15);%%%%多出一个，因为这里是两个一更替，所以成对出现
% % % 
% % % yyy=[y,yy];%%%将这几个y坐标赋值给一个数组yyy
% % % figure,plot(x45,yyy);legend('big MA -26.5°');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'big MA -26.5°
% % % x45=1:31;
% % % y=zeros(1,16);
% % % yy=zeros(1,15);
% % % y(1)=Iresize(row,col);%%第row行，两个像素
% % % y(2)=Iresize(row-1,col);
% % % y(3)=Iresize(row-2,col+1);%%第row-1行，两个像素
% % % y(4)=Iresize(row-3,col+1);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(5)=Iresize(row-4,col+2);%%第row-1行，两个像素
% % % y(6)=Iresize(row-5,col+2);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(7)=Iresize(row-6,col+3);%%第row-1行，两个像素
% % % y(8)=Iresize(row-7,col+3);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(9)=Iresize(row-8,col+4);%%第row-1行，两个像素
% % % y(10)=Iresize(row-9,col+4);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(11)=Iresize(row-10,col+5);%%第row-1行，两个像素
% % % y(12)=Iresize(row-11,col+5);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(13)=Iresize(row-12,col+6);%%第row-1行，两个像素
% % % y(14)=Iresize(row-13,col+6);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(15)=Iresize(row-14,col+7);%%第row-1行，两个像素
% % % y(16)=Iresize(row-15,col+7);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % %%%%%%%%%开始另一半，左下部分，包含15个像素,此时需要倒序
% % % yy(15)=Iresize(row+1,col-1);%%第row行，两个像素
% % % yy(14)=Iresize(row+2,col-1);
% % % yy(13)=Iresize(row+3,col-2);%%第row-1行，两个像素
% % % yy(12)=Iresize(row+4,col-2);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(11)=Iresize(row+5,col-3);%%第row-1行，两个像素
% % % yy(10)=Iresize(row+6,col-3);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(9)=Iresize(row+7,col-4);%%第row-1行，两个像素
% % % yy(8)=Iresize(row+8,col-4);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(7)=Iresize(row+9,col-5);%%第row-1行，两个像素
% % % yy(6)=Iresize(row+10,col-5);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(5)=Iresize(row+11,col-6);%%第row-1行，两个像素
% % % yy(4)=Iresize(row+12,col-6);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(3)=Iresize(row+13,col-7);%%第row-1行，两个像素
% % % yy(2)=Iresize(row+14,col-7);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(1)=Iresize(row+15,col-8);%%%%多出一个，因为这里是两个一更替，所以成对出现
% % % 
% % % yyy=[yy,y];%%%将这几个y坐标赋值给一个数组yyy
% % % figure,plot(x45,yyy);legend('big MA 63.5°');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%bigMA63.5轮廓线

% % % x45=1:31;
% % % y=zeros(1,16);
% % % yy=zeros(1,15);
% % % y(1)=Iresize(row,col);%%第row行，两个像素
% % % y(2)=Iresize(row+1,col);
% % % y(3)=Iresize(row+2,col+1);%%第row-1行，两个像素
% % % y(4)=Iresize(row+3,col+1);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(5)=Iresize(row+4,col+2);%%第row-1行，两个像素
% % % y(6)=Iresize(row+5,col+2);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(7)=Iresize(row+6,col+3);%%第row-1行，两个像素
% % % y(8)=Iresize(row+7,col+3);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(9)=Iresize(row+8,col+4);%%第row-1行，两个像素
% % % y(10)=Iresize(row+9,col+4);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(11)=Iresize(row+10,col+5);%%第row-1行，两个像素
% % % y(12)=Iresize(row+11,col+5);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(13)=Iresize(row+12,col+6);%%第row-1行，两个像素
% % % y(14)=Iresize(row+13,col+6);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % y(15)=Iresize(row+14,col+7);%%第row-1行，两个像素
% % % y(16)=Iresize(row+15,col+7);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % %%%%%%%%%开始另一半，左下部分，包含15个像素,此时需要倒序
% % % yy(15)=Iresize(row-1,col-1);%%第row行，两个像素
% % % yy(14)=Iresize(row-2,col-1);
% % % yy(13)=Iresize(row-3,col-2);%%第row-1行，两个像素
% % % yy(12)=Iresize(row-4,col-2);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(11)=Iresize(row-5,col-3);%%第row-1行，两个像素
% % % yy(10)=Iresize(row-6,col-3);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(9)=Iresize(row-7,col-4);%%第row-1行，两个像素
% % % yy(8)=Iresize(row-8,col-4);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(7)=Iresize(row-9,col-5);%%第row-1行，两个像素
% % % yy(6)=Iresize(row-10,col-5);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(5)=Iresize(row-11,col-6);%%第row-1行，两个像素
% % % yy(4)=Iresize(row-12,col-6);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(3)=Iresize(row-13,col-7);%%第row-1行，两个像素
% % % yy(2)=Iresize(row-14,col-7);%%%%列一直在更新，只是行，更新的慢了一个步长
% % % yy(1)=Iresize(row-15,col-8);%%%%多出一个，因为这里是两个一更替，所以成对出现
% % % 
% % % yyy=[yy,y];%%%将这几个y坐标赋值给一个数组yyy
% % % figure,plot(x45,yyy);legend('big MA -63.5°');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'big MA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-63.5°成功的程序


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% row=197;
% col=84;
% r=15;
% x0=1:31;
% y0=Iresize(197,(84-r):(84+r));%%%大MA：0°
% figure,plot(x0,y0);
% legend('0°');
% 
% r=15;
% x1=1:31;
% y1=Iresize((197-r):(197+r),84);%%%大MA：90°
% figure,plot(x1,y1);
% legend('90°');
%%%%%%%%%%%%%%%%%%%%%%%%%%以上是属于成功求小MA出轮廓线的  0°和90°
% x45=1:31;
% y=zeros(1,15);
% yy=zeros(1,16);
% % ii=0;
% for i=1:1:r%%%线找出正45°的轮廓线行
%     y(i)=Iresize(row-i,col+i);%%%%从右边第一个坐标开始，得出的y
% end
% for i=1:1:r%%%%%这样表示最小的坐标从坐下到中心靠近
%     yy(r+1-i)=Iresize(row+i,col-i);%%%%%从最 左边的第一个像素开始，走到标记中心坐标 
% end
% yy(16)=Iresize(row,col);%%%%将yy（16）赋值为中心点坐标                       线列后行貌似就对。。。。。。。。。。。。。。
% yyy=[yy,y];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x45,yyy);legend('small MA 45°');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以上是小MA的45轮廓线程序
% x135=1:31;
% y=zeros(1,16);
% yy=zeros(1,15);
% for i=1:1:r%%%找出135
%     y(r+1-i)=Iresize(row-i,col-i);%%%%从右边第一个坐标开始，得出的y
% end
% for i=1:1:r%%%%%这样表示最小的坐标从坐下到中心靠近
%     yy(i)=Iresize(row+i,col+i);%%%%%从最 左边的第一个像素开始，走到标记中心坐标 
% end
% y(16)=Iresize(row,col);%%%%将yy（16）赋值为中心点坐标                       线列后行貌似就对。。。。。。。。。。。。。。
% yyy=[y,yy];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x135,yyy);legend('small MA 135°');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以上是小MA135的轮廓线


% r=15;
% x0=1:31;
% y0=Iresize(458,(234-r):(234+r));%%%大MA：0°
% figure,plot(x0,y0);
% legend('0°');
% 
% r=15;
% x1=1:31;
% y1=Iresize((458-r):(458+r),234);%%%大MA：90°
% figure,plot(x1,y1);
% legend('90°');
%%%%%%%%%%%%%%%%%%%%%%%%%%以上是属于成功求细长条的出轮廓线的  0°和90°
% row=458;
% col=234;
% r=15;
% x45=1:31;
% y=zeros(1,15);
% yy=zeros(1,16);
% % ii=0;
% for i=1:1:r%%%线找出正45°的轮廓线行
%     y(i)=Iresize(row-i,col+i);%%%%从右边第一个坐标开始，得出的y
% end
% for i=1:1:r%%%%%这样表示最小的坐标从坐下到中心靠近
%     yy(r+1-i)=Iresize(row+i,col-i);%%%%%从最 左边的第一个像素开始，走到标记中心坐标 
% end
% yy(16)=Iresize(row,col);%%%%将yy（16）赋值为中心点坐标                       线列后行貌似就对。。。。。。。。。。。。。。
% yyy=[yy,y];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x45,yyy);legend('thin line 45°');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以上是细长条的45轮廓线程序
% row=458;
% col=234;
% r=15;
% x135=1:31;
% y=zeros(1,16);
% yy=zeros(1,15);
% for i=1:1:r%%%找出135
%     y(r+1-i)=Iresize(row-i,col-i);%%%%从右边第一个坐标开始，得出的y
% end
% for i=1:1:r%%%%%这样表示最小的坐标从坐下到中心靠近
%     yy(i)=Iresize(row+i,col+i);%%%%%从最 左边的第一个像素开始，走到标记中心坐标 
% end
% y(16)=Iresize(row,col);%%%%将yy（16）赋值为中心点坐标                       线列后行貌似就对。。。。。。。。。。。。。。
% yyy=[y,yy];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x135,yyy);legend('thin line 135°');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以上是细长条135的轮廓线
% row=351;
% col=197;
% r=15;
% x0=1:31;
% y0=Iresize(row,(col-r):(col+r));%%%大MA：0°
% figure,plot(x0,y0);
% legend('0°');
% 
% r=15;
% x1=1:31;
% y1=Iresize((row-r):(row+r),col);%%%大MA：90°
% figure,plot(x1,y1);
% legend('90°');
% %%%%%%%%%%%%%%%%%%%%%%%%%%以上是属于成功求血管交叉的出轮廓线的  0°和90°血管交叉（197，351）
% row=351;
% col=197;
% r=15;
% x45=1:31;
% y=zeros(1,15);
% yy=zeros(1,16);
% % ii=0;
% for i=1:1:r%%%线找出正45°的轮廓线行
%     y(i)=Iresize(row-i,col+i);%%%%从右边第一个坐标开始，得出的y
% end
% for i=1:1:r%%%%%这样表示最小的坐标从坐下到中心靠近
%     yy(r+1-i)=Iresize(row+i,col-i);%%%%%从最 左边的第一个像素开始，走到标记中心坐标 
% end
% yy(16)=Iresize(row,col);%%%%将yy（16）赋值为中心点坐标                       线列后行貌似就对。。。。。。。。。。。。。。
% yyy=[yy,y];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x45,yyy);legend('vessel cross 45°');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以上是交叉血管45轮廓线程序
% row=351;
% col=197;
% r=15;
% x135=1:31;
% y=zeros(1,16);
% yy=zeros(1,15);
% for i=1:1:r%%%找出135
%     y(r+1-i)=Iresize(row-i,col-i);%%%%从右边第一个坐标开始，得出的y
% end
% for i=1:1:r%%%%%这样表示最小的坐标从坐下到中心靠近
%     yy(i)=Iresize(row+i,col+i);%%%%%从最 左边的第一个像素开始，走到标记中心坐标 
% end
% y(16)=Iresize(row,col);%%%%将yy（16）赋值为中心点坐标                       线列后行貌似就对。。。。。。。。。。。。。。
% yyy=[y,yy];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x135,yyy);legend('vessel cross 135°');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%以上是交叉血管135轮廓线程序


% x45=1:31;
% y=zeros(1,15);
% yy=zeros(1,16);
% % ii=0;
% for i=1:1:r%%%线找出正45°的轮廓线
%     for j=1:1:r%%%%%这样表示从中心到右上角
% %       ii=i+ii;  
%     y(i)=Iresize(312+j,271-i);%%%%从右边第一个坐标开始，得出的y
%     end
% end
% 
% for i=1:1:r
%     for j=1:1:r%%%%%这样表示最小的坐标从坐下到中心靠近
%     yy(r+1-i)=Iresize(312-j,271+i);%%%%%从最 左边的第一个像素开始，走到标记中心坐标 
%     end
% end
% yy(16)=Iresize(312,271);%%%%将yy（16）赋值为中心点坐标                       线列后行貌似就对。。。。。。。。。。。。。。
% yyy=[yy,y];
% [m,n]=size(yyy);
% figure,plot(x45,yyy);legend('45°');
% figure,bar(yyy);
% xlabel('X axis');



