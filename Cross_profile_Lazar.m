% clc;
% clear all
% %%Ԥ����׶�++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% number=17;
% input=strcat('D:\wzz\AWZZ\ROCtraining_RGB\image',num2str(number),'_training.jpg');
% I = imread(input);
% Igreen=I(:,:,2);% Igreen = double(I(:,:,2));%%%��ɫͨ��
% figure,imshow(Igreen,[]);
% [x,y]=ginput(100);%%����ͼ�񣬵�������
% X = round(x)%%��С����Ϊ����
% Y =round(y)
% imtool(Igreen,[]);
% figure,imshow(Igreen,[]);
% imtool(Igreen,[]);
% % Ienh= adapthisteq(Igreen,'clipLimit',0.01,'Distribution','rayleigh');%%������Ҫ��uint8, uint16, int16, single, or double������double�ĺ����У�ԭʼ����ʱunit
% % % figure,imshow(Ienh,[]);
% % Iinv=255-Igreen;%%%%��ɫͨ��ȡ��
% % f = fspecial('gaussian',[3 3],1.0);%%h = fspecial('gaussian', hsize, sigma)
% % Ismooth = imfilter(Iinv,f,'same');%%%%%��˹ƽ�������߿���conv2,nlfilter,�ܹ��õ����ƻ�����Ч��
% % % Iresize = imresize(Ismooth,[540 540],'bilinear');
% % % figure,imshow(Ismooth,[]);
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Ԥ�������+++++++++++++++++++++++++++++++++
% % txt=dlmread('coornon1.txt');%%��ȡ����
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
% %     k=[names,'  ',strcat('img',num2str(number)),'  ',num2str(col),'  ',num2str(row)];%%mat�ļ����֣�ͼ����ţ�x���꣬y����
% %     fid=fopen('nonmat.txt','at');%%'wt'��д�ķ�ʽ���ļ�������at������д�ķ�ʽ���ļ�
% %     fprintf(fid,'\n%s %s %s  %s  %s %s  %s',k);
% %     fclose(fid);
% %     g=g+1;
% % end

%2017 1 10�����޸� 
clc,clear all;
% [ndata, text, alldata] = xlsread('C:\Users\Administrator\Desktop\roclabel.xls');
[ndata, text, alldata] = xlsread('E:\WZZ\OneDrive\�ĵ�\��д���Ĳ���\lazar���\pre20MA.xls');
% [ndata, text, alldata] = xlsread('E:\WZZ\OneDrive\�ĵ�\��д���Ĳ���\lazar���\nonMA.xlsx');
npose=size(ndata,1);
r=15;%x=1:31;%%	row=282;col=189;%%536	247%259	18
g=1;
 for i=1:1:size(ndata,1)%%i=54
     x(i)=ndata(i,1);
     y(i)=ndata(i,2);
     filename{i}=text(i+1,1);%%��Ҫ�ر�ע�⣬nonMA.xlsx�ļ��£�û�е�һ�е�˵�������Դ˴�������Ҫ����text(i+1,1),������MA.xlsx
     nm=strcat('E:\WZZ\ROC_db\ROCtraining\',char(filename{i}));
%      image=imread(char(filename{i}));
     image=imread(nm);
     Igreen=image(:,:,2);% Igreen = double(I(:,:,2));%%%��ɫͨ��
     Ienh= adapthisteq(Igreen,'clipLimit',0.01,'Distribution','rayleigh');%%������Ҫ��uint8, uint16, int16, single, or double������double�ĺ����У�ԭʼ����ʱunit
     Iinv=255-Igreen;%%%%��ɫͨ��ȡ��
     f = fspecial('gaussian',[3 3],1.0);%%h = fspecial('gaussian', hsize, sigma)
     Ismooth = imfilter(Iinv,f,'same');%%%%%��˹ƽ�������߿���conv2,nlfilter,�ܹ��õ����ƻ�����Ч��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Ԥ�������+++++++++++++++++++++++++++++++++
    row=y(i);
    col=x(i);
    Ismooth=double(Ismooth);
    [degrees,P]=cross_profile(Ismooth,row,col,r);%% ������������
    for j=1:8
        PP=P(j,:);
%     figure,plot(x,PP);
        [b1,c1,centeridx]=min_diff_height_gap(PP);
        [Fea]=feature_profile(b1,c1,PP,centeridx);
        Feat(j,:)=Fea(:); 
    end
    [F]=mu_xigma(Feat);
    names=strcat('E:\WZZ\OneDrive\���մ���M\lazar1228ѵ��\��ѡ����ȡtophat\MA_MATpre\','F',num2str(g),'.mat');
    save(names,'F');
    g=g+1;
 end
  

 
%   if(~isempty(char(filenameroi{i})))
%      patch=image(y(i)-r:y(i)+r,x(i)-r:x(i)+r);
%     % imwrite(patch,(strcat(num2str(j),'_',char(filename{i}),'_',char(filenameroi{i}),'_R_5.jpg')));
%       imwrite(patch,(strcat(num2str(j),'ROI_10.jpg')));%���˳���ROI���򣬲�����ʾ�����ĸ�ͼ���ROI�����������ĺô��Ǳ����´δ���ʱ��ѭ�����á������ָ��ַ���ճ����һ���ʱ����Ҫ����ת�����ַ���num2str�����֣�
%     j=j+1; 
%   end





% % %     r=15;x1=1:31;
% % %     [degrees,P]=cross_profile(Ismooth,row,col,r);%%%�������������ߣ����ؽǶ�ֵ����8*31��P���󣬰�������������ֵ��
% % %     Feat=[];
% % %     PP=P(3,:);
% % %     figure,plot(PP);
% % %     output=smooth(PP,5);%%%��������ƽ����
% % %     figure,plot(output); 
% % %     findpeaks(output,'MinPeakProminence',6,'Annotate','extents')
%    [pks,locs,widths,proms] = findpeaks(output)
%    [pks,locs,widths,proms] = findpeaks(PP)
      


        
% %     for i=1:8
% %         P1 = P(i,:);%%P����90����ֵ����
% %         figure(1),plot(x1,P1,'*r');
% % %         figure(2),bar(P(i,:)-155);
% %         [b1,c1,centeridx]=min_diff_height_gap(P1);
% %         [Fea]=feature_profile(b1,c1,P1,centeridx);
% %         Feat(i,:)=Fea(:); 
% %     end
% %     [F]=mu_xigma(Feat);%%%һ��MA�ó�һ��F����F����������ΪMA��ѵ������
% %     count_perimg=1;
% %     name=strcat('D:\OneDrive\���մ���M\lazarMAmat\F_MA_',num2str(number),'_',num2str(count_perimg),'.mat')
% %     save(name,'F');
%     FF(iii,:)=F(:);%%%ÿһ�д���һ����ѡ���mu_xigmaͳ����












% % row=351;col=197;% row=458;col=234;% row=351;col=197;%row=458;col=234;%row=312;col=271;% row=197;col=84;
% % r=15;
% x1=1:31;
% % [degrees,P]=cross_profile(Iresize,row,col,r);%%%�������������ߣ����ؽǶ�ֵ����8*31��P���󣬰�������������ֵ��
% P=[154.732337439556,154.349182227015,153.322796414260,153,152.677203585740,152.247682806306,151.876158596847,151.725931380939,151.849772784092,151.978839131709,151.779884120602,151.301635545969,150.854997728556,150.500590557076,150.328021358725,150.301635545969,150.602089977786,150.828611915801,150.526976369832,150.198955011107,151.000000000000,152.451862761878,153.252907750770,152.924886392046,151.801044988893,150.747092249229,150.274068619061,150.548137238122,150.924886392046,151.075113607954,151.198955011107];
% g=8;
% % P = P1(g,:);
% figure(1),plot(x1,P);
% % figure(2),bar(P1-155);
% % [b,c]=min_diff_height_gap(P)
% % [Fea]=feature_profile(b1,c1,P1)
% 
% [Valmax,maxdx]=max(P(:));%%Valmax������P�����ֵ��maxdx���������ֵ����
% %%% �Ҵ����ŷ������ҵ������Ժ󣬰�����ֵ*-1�������϶��Ͳ��������
% P1=P;
% % P1(maxdx)=Valmax-100;
% % [Valsub,subdx]=max(P1);
% [pks,locs]=findpeaks(P,'minpeakdistance',3)
% % findpeaks(P,'minpeakdistance',3)
% findpeaks(P,'Threshold',0.2)
% findpeaks(P,'MinPeakProminence',1)




% data = [2 12 4 6 9 4 3 1 19 7];
% [pks,locs]=findpeaks(data,'minpeakdistance',3);


% % % % center=16;%%�����ļ����У��������16������Ϊcenter����Ҫ��������valmax(����min_diff_gap.m����)��ͨ��ɸѡ�ó�����ֵ������������������ķ���ֵ��Ҫ���һ�� center����
% % % % %% ���������ֵ���״��û�����»���û�����£���ô�����Ŀ϶��Ͳ���MA�����Դ�ʱ���Ժ��ԣ�������Ӧ������Ϊ0��Ӧ���Ǻ���İɣ���Ϊû�����㣩
% % % % Bnum = length(b);%%�ҳ�b����ĳ���
% % % % Cnum = length(c);%%�ҳ�c����ĳ��� %%%12 26���� ��ʱc=0����Ϊ����min_diff_gap�����cû�������㣬��ֵ��c=0��Ĭ��Ϊ
% % % % if Bnum==1
% % % %     Fea=zeros(1,7);
% % % % else
% % % %     if Cnum==1
% % % %         Fea=zeros(1,7);
% % % %     else
% % % %         Wpeak = c(Cnum)-b(1);
% % % %         Wtop = c(1)-b(Bnum); %%%��ֵ15����û�д���min_diff,������ȥ
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
% % % %             Hpeak=P(center)-(center-b(1))/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(b(1));%%���մ˹�ʽ��������ȷ
% % % %         else
% % % %             Hpeak=Hinc;
% % % %         end
% % % %         Fea=[];Fea(1)=Wpeak;Fea(2)=Wtop;Fea(3)=Hinc;Fea(4)=Hdec;Fea(5)=Sinc;Fea(6)=Sdec;Fea(7)=Hpeak;
% % % %         fprintf('%f\n', Fea);
% % % %     end
% % % % end



















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%2016 12 22 ����6���޸� MA��min_diff_height_gap.m����˳���ܳ�����Ѫ�ܺͽ���Ѫ�ܵ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Feat=[];
% for i=1:8
% %     figure(1),plot(x1,P(i,:),'*r');
% %     figure(2),bar(P(i,:)-155);
%     P1 = P(i,:);%%P����90����ֵ����
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




%%%y=mean(x)%��x�ľ�ֵ
%%%ystd=std(x)%��x�ı�׼��
%%%cv=ystd/y.

% Feat=zeros();
% % % g=3;
% % % figure(1),plot(x1,P(g,:),'*r');
% % % figure(2),bar(P(g,:)-155);
% % % P = P(g,:);%%P����90����ֵ����
% % % [b1,c1]=min_diff_height_gap(P)
% % % [Fea]=feature_profile(b1,c1,P)
% Feat=zeros(8,7);
% Feat(g,:)=Fea;
%%%��� fea��
%20.7650   29.6555    6.9217    4.2365    1.0000   11.0000   26.7015
%27.7931   36.2656    3.0881    4.0295    1.0000   19.0000   27.5126
%21.6682   31.2556    7.2227    5.2093    1.0000   10.0000   24.0150
%15.4792   29.9877    7.7396    5.9975    1.0000    8.0000   24.7665
%12.1034   27.1177    4.0345    4.5196    1.0000   10.0000   25.6990
%19.0971   29.0990    6.3657    5.8198    1.0000    9.0000   25.9026
%23.9642   32.8102    5.9910    5.4684    1.0000   11.0000   24.4449
%14.5901   32.7094    4.8634    4.0887    1.0000   12.0000   26.7992




% % [b,c]=min_diff_height_gap(P);
% % [Fea]=feature_profile(b,c,P);%%%�����һ��P���߸�����ֵ��fea��һ��������
% for i=1:8
%     P=P(i,:);
%     [b,c]=min_diff_height_gap(P);
%     [Fea]=feature_profile(b,c,P);%%%�����һ��P���߸�����ֵ��fea��һ��������
%     Feat(i,:)=Fea;
% end
  
%%%��δ����mean standard difference cv�ȵļ���
%%%y=mean(x)%��x�ľ�ֵ
%%%ystd=std(x)%��x�ı�׼��
%%%cv=ystd/y.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2016 12 21 ��ȥcoding�������ֵ��֮�����߼бƣ��ҳ�increasing ramp����decreasing ramp
% % % % % % P = P(1,:);
% % % % % % [Valmax,maxdx]=max(P(:));%%Valmax������P�����ֵ��maxdx���������ֵ����
% % % % % % min_diff=2;
% % % % % % min_height=3;
% % % % % % max_gap=3;
% % % % % % b=zeros();%%���increase ramp
% % % % % % c=zeros();%%���decrease ramp
% % % % % % jj=0;
% % % % % % jjj=0;
% % % % % % for i=maxdx:-1:2%%%�� increase ramp
% % % % % %     jj=jj+1;
% % % % % %     if P(i)-P(i-1)>0 
% % % % % %         Inc(jj)=P(i-1);%%���ܱ������ֵP(maxdx),�����Ҫ��ΪWtop�����
% % % % % %         b(jj)=i-1;%%b��������
% % % % % %     else
% % % % % %         break;%%ֱ������ѭ�������ramp�Ͳ�����
% % % % % %     end
% % % % % % end
% % % % % % %%%%%%%%%%%%%%%���ж��Ƿ�����min_diff,֮���ٽ���gap���жϣ����gap���㣬��ȥ���Ĳ��ֲ���
% % % % % % b1=zeros();jjjj=1;
% % % % % % Inc1(1)=Inc(1);
% % % % % % b1(1)=b(1);
% % % % % % for ii=b(1):-1:b(end)%%%�� increase ramp
% % % % % %     jjjj=jjjj+1;
% % % % % %     if P(ii)-P(ii-1)>=min_diff 
% % % % % %         Inc1(jjjj)=P(ii-1);%%���ܱ������ֵP(maxdx),�����Ҫ��ΪWtop�����
% % % % % %         b1(jjjj)=ii-1;%%b��������
% % % % % %     end
% % % % % % end
% % % % % % % b=b(end:-1:1);%%����˳�򣬴�ramp�� increase ���½��м���
% % % % % % % b1=b1(end:-1:1);
% % % % % % Inc2=zeros();b2=zeros();
% % % % % % 
% % % % % % if length(b)-length(b1)>=2 %%%���ɸѡ���b1<b���򽫱�����Inc1�����һ��������һ���ֱ�����Inc2��
% % % % % % %     b=b(end:-1:1);%%����˳�򣬴�ramp�� increase ���½��м���
% % % % % % %     b1=b1(end:-1:1);
% % % % % %     for iii=b(1):1:b1(1)-1 %%��b�г�ȥb1����Ԫ�أ����б���
% % % % % %         jjj=jjj+1;
% % % % % %         if abs(P(iii)-P(iii+1))>=min_diff
% % % % % %             Inc2(jjj)=P(iii);
% % % % % %             b2(jjj)=iii;
% % % % % %         end
% % % % % %     end%%%�ó�increase ramp����һ�Σ�����жϣ��в�ǰ��
% % % % % %     if b1(1)-b2(end)<=max_gap
% % % % % %        b1=b(end:-1:1);%%��������Ҫ��һ���Ľ�
% % % % % %        b2=b(end:-1:1);
% % % % % %     end
% % % % % % else
% % % % % %        b1=b(end:-1:1);%%��������Ҫ��һ���Ľ�
% % % % % %        b2=b(end:-1:1);
% % % % % % end %%12/21����Ӧ������ȷ�ģ��߼���û�д�������Ϊ
% % % % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % % % Dec=zeros();
% % % % % % h=0;
% % % % % % for j=maxdx:1:31%%%�ҳ�decrease ramp
% % % % % %     h=h+1;
% % % % % %     if P(j)-P(j+1)>0
% % % % % %         Dec(h)=P(j+1);%%��ʱ��Dec�Ǵ�С�����˳�򣬽��������赹��
% % % % % %         c(h)=j;%%��ʱ��c�Ǵ�С�����˳�򣬽��������赹��
% % % % % %     else
% % % % % %         break;
% % % % % %     end
% % % % % % end
% % % % % % %%%%%%%%%%%%%%%���ж��Ƿ�����min_diff,֮���ٽ���gap���жϣ����gap���㣬��ȥ���Ĳ��ֲ���
% % % % % % c1=zeros();hh=1;Dec1=zeros();
% % % % % % Dec1(1)=Dec(1);
% % % % % % c1(1)=c(1);
% % % % % % for e=c(1):1:c(end)%%%�� increase ramp
% % % % % %     hh=hh+1;
% % % % % %     if P(e)-P(e+1)>=min_diff 
% % % % % %         Dec1(hh)=P(e+1);%%���ܱ������ֵP(maxdx),�����Ҫ��ΪWtop�����,��Inc1��2����ʼѭ��������һ��
% % % % % %         c1(hh)=e+1;%%b��������,��b��2����ʼѭ����������
% % % % % %     end
% % % % % % end
% % % % % % 
% % % % % % Dec2=zeros();c2=zeros();hhh=1;
% % % % % % Dec2(1)=P(c1(end)+1);%%%����һ�εĵ�һ����ֵ��dec2��1����
% % % % % % c2(1)=c1(end)+1;
% % % % % % % if length(c1)<length(c) %%%���ɸѡ���b1<b���򽫱�����Dec1�����һ��������һ���ֱ�����Dec2��
% % % % % %     if length(c)-length(c1)>2%%����2�������ٿ��Լ���һ��diff ��gap
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
% % % % % %     else%%%����˵��length��c��-length��c1��<=2��ʱ��ֱ�ӽ�����Ϊ��ֵ��һ���֡�
% % % % % %         c1=c;%%%�������յĸ�ֵ�������е��м�ֵ�������c 
% % % % % %         c2=c;
% % % % % %     end
% % % % % %     
        
    
    
    
    



% for i=maxdx:-1:2%%%�� increase ramp
%     jj=jj+1;
%     if P(i)-P(i-1)>=min_diff 
%         Inc(jj)=P(i-1);%%���ܱ������ֵP(maxdx),�����Ҫ��ΪWtop�����
%         b(jj)=i;%%b��������
%     else
%         break;%%ֱ������ѭ�������ramp�Ͳ�����
%     end
% end
% Inc=Inc(end:-1:1);%%���򣬰��ճ��棬��С�����˳��
% b=b(end:-1:1);%%���򣬰��ճ��棬��С�����˳��

% for j=maxdx:1:31%%%�ҳ�decrease ramp
%     jjj=jjj+1;
%     if P(j)-P(j+1)>=min_diff
%         Dec(jjj)=P(j+1);%%��ʱ��Dec�Ǵ�С�����˳�򣬽��������赹��
%         c(jjj)=j;%%��ʱ��c�Ǵ�С�����˳�򣬽��������赹��
%     else
%         break;
%     end
% end
%%%%%%%%������ó� Inc ��Dec ��b��c��������min_diff�ļ��㣬Ϊ�˿��Ʒ�ֵҪ����sharp��������ĵط����ţ����ڼ���������
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






%%%�����ֵ����
%%%���ȼ��������½�����sgn(P[i]-P[i-1])=sgn(P[i+1]-P[i]),������һ�£���������ͬһ��״̬����ţ�˵�������½������仯
%%%min_diff:���� ���ص����Ȳ�>=2,��Ϊ��ramp
%%%min_height:���Բ�between the first and last value,>=3,�ǲ���ramp��incs��inse��Ӧ�����Ȳ�ֵ�أ���������
%%%max_gap:��������ramp֮��Ĳ�����ֵ������<=3.
% figure(1),plot(x1,P(1,:),'*r');
% figure(3),plot(x1,P(1,:));
% figure(2),bar(P(1,:)-150);
% P = P(1,:);%%P��������ֵ����
% min_diff=2;
% min_height=3;
% max_gap=3;
% R=zeros();%%ramp����ֵ
% Inc=zeros();%%increase ����ֵ
% Dec=zeros();%%decrease����ֵ
% j=0;
% a=zeros();
% for i=2:31 %%��������ֵ���Ƚϴ�С����ramp
%     %% ����������ramp                       
%     if abs(P(i)-P(i-1))>=min_diff  %�������Ȳ����min_diff�ı��浽R������
%         j=j+1;
%         R(j)=P(i);%%��ramp�ı��� 11����
%         a(j)=i;%%%��R����Ӧ������������浽a������
% %         b=i;%%%����ѭ����ǰһ��i��ֵ��
%     end 
% end
% b=zeros();
% c=zeros();
% jj=0;
% jjj=0;
% for ii=2:length(a) %%����R��������ֵ���Ƚϴ�С���������½�
%     %% �ҳ� increase ��decrease
%     if R(ii)-R(ii-1)>=0
%         jj=jj+1;
%         Inc(jj)=R(ii);
%         b(jj)=a(ii);%%����R�����浽Inc��������������
%     else 
%         jjj=jjj+1;
%         Dec(jjj)=R(ii);
%         c(jjj)=a(ii);%%����R�����浽Dec���������������ܻص�ԭ����profile��
%     end
% end
% 
% 
% 
% 
% %% ��������ramp��ʹ��ͬһ�����ϵ�ramp���治�ܳ��������max_gap,,,
% %%1:increase ramp,�Ӵ�ֵ��Сֵ���� b=a(end:-1:1)
% B=zeros();u=0;
% B(1)=b(length(b));
% for t=length(b):-1:2
%         u=u+1;
%         B(u)=b(t);
%     if b(t)-b(t-1)<=max_gap
% %         u=u+1;
% %         B(u)=b(t);%%%���û��break�������Զ�ɸѡ�Աȣ���ʱ�����14 13 8 7��������˵��8 7 �Ͳ�Ӧ�ô����ˡ�����
%     else          %%%����break֮��һ��������<=max_gap,�ͻ���������ѭ����
%         break;%%%break��continue���ƣ�Ҳ�Ǿ�����for while���ã��������Ǽ���ִ����һ��ѭ���������˳�ѭ���壬����ִ��ѭ����֮��ĳ��򡣼���ֹѭ����
%     end
% end
% B=B(end:-1:1);%%%��ʱB=13 14����������˳�����,����������������b����B
% %%2:decrease ramp,��Сֵ���ֵ���� 
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
% %% �����ж�һ��gap���ж��Ƿ����㲻С��min_height����������㣬��ֱ�ӽ���������b��c��Ϊ0���ڽ������ĳ����У������ж�һ�£����b=0��c=0���򲻽��н������ļ�����
% bnum=length(B);
% cnum=length(C);
% if Inc(bnum)-Inc(1)<=min_height
%     b=0;
% end
% if Dec(1)-Dec(cnum)<=min_height
%     c=0;
% end







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%local maximum region extraction �ֲ�����ֵ�Ļ�ȡ��
% BW = imregionalmax(I)ʾ��BW = imregionalmax(I)���صĶ�����ͼ��BW��ʶ��������ֵ��I���������ֵ����ͨ�ĺ㶨ǿ��ֵ�� t�������е��ⲿ�߽����ص�ֵС��t�����ء�BW������Ϊ1������ʶ����������ֵ;�������������ض�����Ϊ 0��
% BW = imregionalmax(I,conn)BW = imregionalmax(I,conn)������������ֵ������connָ�������ӡ�Ĭ������£� imregionalmaxʹ�� 8 �������� 2 D ͼ�����άͼ�� 26 ����������
% gpuarrayBW = imregionalmax(gpuarrayI,___)
% BW = imregionalmax(Ismooth);
% figure(1),imshow(BW,[]),title('MAX');%%%Ч�������Ǻܺ��ء�����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%LMR��ȡ����+++++++++++++++++++++++++++++++++
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%cross profile scanning ����������߻�ȡ
% Irota=imrotate(Iresize,45);
% imtool(Irota,[]);%%%%%�� �����д������ش��󣬣�ÿ�ζ�Ҫ
%  imtool(Iresize,[]);%%%�ҵ�MA��������Ѫ�ܽ��������꣬�˴�ϵ�ֶ��ҵ�,�ó��������ǳ����������꣬��MATLAB�����ϵ������෴
%%%%%%%%%%%%%%%��MA��271,312��  С��84,197��  ������234��  458��  Ѫ�ܽ��棨197��351�����������ϵ�����
% %%%%%%�����ҳ�MA�Ľ��������ߣ�������ֱ��ͼ��ͨ����תԭʼͼ�񣬽�������������ȡ imrotate(a,35,'bilinear')
% %%%%%plot(Iresize((312-r):(312+r),271),'r');
% row=312;col=271;
% r=15;x1=1:31;
% y1=Iresize((row-r):(row+r),col);%%%��MA��90��
% figure,plot(x1,y1);legend('90��');
% min1=min(y1(:));
% ynew=y1-min1+1;figure,bar(ynew,'histc');
% hold on
% plot(x1,ynew,'r-');
% %%%�����ֵ����
% %%%���ȼ��������½�����sgn(P[i]-P[i-1])=sgn(P[i+1]-P[i]),������һ�£���������ͬһ��״̬����ţ�˵�������½������仯
% %%%min_diff:���� ���ص����Ȳ�>=2,��Ϊ��ramp
% %%%min_height:���Բ�between the first and last value,>=3,�ǲ���ramp��incs��inse��Ӧ�����Ȳ�ֵ�أ���������
% %%%max_gap:��������ramp֮��Ĳ�����ֵ������<=3.
% P = y1;%%P��������ֵ����
% min_diff=2;
% min_height=3;
% max_gap=3;
% R=zeros();%%ramp����ֵ
% Inc=zeros();%%increase ����ֵ
% Dec=zeros();%%decrease����ֵ
% j=0;
% a=zeros();
% for i=2:31 %%��������ֵ���Ƚϴ�С����ramp
%     %% ����������ramp                       
%     if abs(P(i)-P(i-1))>=min_diff  %�������Ȳ����min_diff�ı��浽R������
%         j=j+1;
%         R(j)=P(i);%%��ramp�ı��� 11����
%         a(j)=i;%%%��R����Ӧ������������浽a������
% %         b=i;%%%����ѭ����ǰһ��i��ֵ��
%     end 
% end
% b=zeros();
% c=zeros();
% jj=0;
% jjj=0;
% for ii=2:length(a) %%����R��������ֵ���Ƚϴ�С���������½�
%     %% �ҳ� increase ��decrease
%     if R(ii)-R(ii-1)>0
%         jj=jj+1;
%         Inc(jj)=R(ii);
%         b(jj)=a(ii);%%����R�����浽Inc��������������
%     else 
%         jjj=jjj+1;
%         Dec(jjj)=R(ii);
%         c(jjj)=a(ii);%%����R�����浽Dec���������������ܻص�ԭ����profile��
%     end
% end

% %% ��������ramp��ʹ��ͬһ�����ϵ�ramp���治�ܳ��������max_gap,,,
% %%1:increase ramp,�Ӵ�ֵ��Сֵ���� b=a(end:-1:1)
% B=zeros();u=0;
% B(1)=b(length(b));
% for t=length(b):-1:2
%     if b(t)-b(t-1)<=max_gap
%         u=u+1;
%         B(u)=b(t);%%%���û��break�������Զ�ɸѡ�Աȣ���ʱ�����14 13 8 7��������˵��8 7 �Ͳ�Ӧ�ô����ˡ�����
%     else          %%%����break֮��һ��������<=max_gap,�ͻ���������ѭ����
%         break;%%%break��continue���ƣ�Ҳ�Ǿ�����for while���ã��������Ǽ���ִ����һ��ѭ���������˳�ѭ���壬����ִ��ѭ����֮��ĳ��򡣼���ֹѭ����
%     end
% end
% B=B(end:-1:1);%%%��ʱB=13 14����������˳�����,����������������b����B
% %%2:decrease ramp,��Сֵ���ֵ���� 
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


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ٽ���һ�����жϸ�ramp�ǲ��������ģ�û���趨����С��max_gap��������Ҫ��������
% %%%%%%��ʼ��������
% center=16;%%���ֵ��λ�ã���������
% %% ����һ�� peak width=dec_e-inc_s
% Bnum = length(b);%%�ҳ�b����ĳ���
% Cnum = length(c);%%�ҳ�c����ĳ���
% Wpeak = c(Cnum)-b(1);
% %% ��������top width=dec_s-inc_e
% Wtop = c(1)-b(Bnum); %%%��ֵ15����û�д���min_diff,������ȥ��
% %% ��������increase ramp height Hinc=P[inc_e]-P[inc_s]
% Hinc=P(b(Bnum))-P(b(1));
% %% �����ġ�decrease ramp height Hdec=P[dec_s]-P[dec_e]
% Hdec=P(c(1))-P(c(Cnum));
% %% �����塢increase ramp slope Sinc=Hinc/��inc_e-inc_s��
% Sinc=Hinc/(b(Bnum)-b(1));
% %% ��������decrease ramp slope Sdec=Hdec/(dec_e-dec_s)
% Sdec=Hdec/(c(Cnum)-c(1));
% %% �����ߡ�peak height  Hpeak=P[center]-(P[dec_e]-P[inc_s])/Wpeak*(center-inc_s)+P[inc_s]
% %Hpeak=P(center)-abs(P(c(Cnum))-P(b(1)))/Wpeak*(center-b(1))+P(b(1));
% %%%%���1��P[inc_s]>P[dec_e]
% if P(b(1))>P(c(Cnum))
%     Hpeak=P(center)-(c(Cnum)-center)/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(c(Cnum));
% elseif P(b(1))<P(c(Cnum))
% %%%%���2��P[inc_s]>P[dec_e]
%     Hpeak=P(center)-(center-b(1))/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(b(1));%%���մ˹�ʽ��������ȷ
% else
% %%%%���3��P[inc_s]=P[dec_e]
%     Hpeak=Hinc;
% end
% 
% %% ������Щproperty��Fea��
% %Fea�е�˳��rhights set(inc dec),rslopes set(inc dec),Twidths set(top width),Pwidths set(peal width),Pheights set(peak height) 
% Fea=zeros();%%[31.320723457667300,23.473592304409350,3.915090432208412,7.824530768136451,2,13,23.427907440121260]
% Fea(1)=Hinc;
% Fea(2)=Hdec;
% Fea(3)=Sinc;
% Fea(4)=Sdec;
% Fea(5)=Wtop;
% Fea(6)=Wpeak;
% Fea(7)=Hpeak;
% save('Fea.mat','Fea');
% %%%�Զ�Ĭ��increase������16֮ǰ��decrease��֮��

%%%%%%%%%%%%%%%%%%%%%%%%%%������������ԭ���������߶Բ��Ϻţ��������±�������ֵ����󶼲�֪���ĸ�����ֵ��ԭʼ�������϶�Ӧ������ֵ
%%%%%���������ֵ��֮����ǰ�������increase�������������decrease,��������У�Ŀǰ���淽�����񲢲����ܣ�����һЩ���󡣡���14/12











% row=312;
% col=271;
% r=15;
% x0=1:31;
% y0=Iresize(row,(col-r):(col+r));%%%��MA��0��
% figure,plot(x0,y0);
% legend('0��');
% 
% r=15;
% x1=1:31;
% y1=Iresize((row-r):(row+r),col);%%%��MA��90��
% figure,plot(x1,y1);
% legend('90��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�������ڳɹ������MA�����ߵ�  0���90��
% figure,plot(Iresize((row+r):(row-r),(col-r):(col+r)))%%%%%%%%%%%%%%%%%%����ʦ��
% legend(' big MA 45');
% yy=Iresize((row+r):(row-r),(col-r):(col+r))%%%yy�ǿվ��󡣡�����
% % % x45=1:31;
% % % y=zeros(1,15);
% % % yy=zeros(1,16);
% % % % ii=0;
% % % for i=1:1:r%%%���ҳ���45�����������
% % %     y(i)=Iresize(row-i,col+i);%%%%���ұߵ�һ�����꿪ʼ���ó���y
% % % end
% % % for i=1:1:r%%%%%������ʾ��С����������µ����Ŀ���
% % %     yy(r+1-i)=Iresize(row+i,col-i);%%%%%���� ��ߵĵ�һ�����ؿ�ʼ���ߵ������������ 
% % % end
% % % yy(16)=Iresize(row,col);%%%%��yy��16����ֵΪ���ĵ�����                       ���к���ò�ƾͶԡ���������������������������
% % % yyy=[yy,y];%%%���⼸��y���긳ֵ��һ������yyy
% % % figure,plot(x45,yyy);legend('big MA 45��');
% figure,bar(yyy);
% xlabel('X axis');
%%%%%%%%%%%%%%%%%%%%%%%%%�����ǣ�big MA45��ĳ���Ӧ���ǶԵġ�������
% x135=1:31;
% y=zeros(1,16);
% yy=zeros(1,15);
% for i=1:1:r%%%�ҳ�135
%     y(r+1-i)=Iresize(row-i,col-i);%%%%���ұߵ�һ�����꿪ʼ���ó���y
% end
% for i=1:1:r%%%%%������ʾ��С����������µ����Ŀ���
%     yy(i)=Iresize(row+i,col+i);%%%%%���� ��ߵĵ�һ�����ؿ�ʼ���ߵ������������ 
% end
% y(16)=Iresize(row,col);%%%%��yy��16����ֵΪ���ĵ�����                       ���к���ò�ƾͶԡ���������������������������
% yyy=[y,yy];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x135,yyy);legend('big MA 135��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������big MA135�ĳ���Ӧ���ǶԵģ���Ҫע��ɨ���ߵ�����

% % x45=1:31;
% % y=zeros(1,16);
% % yy=zeros(1,15);
%%%���ҳ���tana=1/2,26.6�����������
%%%%���ұߵ�һ�����꿪ʼ���ó���y
% % y(1)=Iresize(row,col);%%��row�У���������
% % y(2)=Iresize(row,col+1);
% % y(3)=Iresize(row-1,col+2);%%��row-1�У���������
% % y(4)=Iresize(row-1,col+3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % y(5)=Iresize(row-2,col+4);%%��row-1�У���������
% % y(6)=Iresize(row-2,col+5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % y(7)=Iresize(row-3,col+6);%%��row-1�У���������
% % y(8)=Iresize(row-3,col+7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % y(9)=Iresize(row-4,col+8);%%��row-1�У���������
% % y(10)=Iresize(row-4,col+9);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % y(11)=Iresize(row-5,col+10);%%��row-1�У���������
% % y(12)=Iresize(row-5,col+11);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % y(13)=Iresize(row-6,col+12);%%��row-1�У���������
% % y(14)=Iresize(row-6,col+13);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % y(15)=Iresize(row-7,col+14);%%��row-1�У���������
% % y(16)=Iresize(row-7,col+15);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % %%%%%%%%%��ʼ��һ�룬���²��֣�����15������,��ʱ��Ҫ����
% % yy(15)=Iresize(row+1,col-1);%%��row�У���������
% % yy(14)=Iresize(row+1,col-2);
% % yy(13)=Iresize(row+2,col-3);%%��row-1�У���������
% % yy(12)=Iresize(row+2,col-4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % yy(11)=Iresize(row+3,col-5);%%��row-1�У���������
% % yy(10)=Iresize(row+3,col-6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % yy(9)=Iresize(row+4,col-7);%%��row-1�У���������
% % yy(8)=Iresize(row+4,col-8);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % yy(7)=Iresize(row+5,col-9);%%��row-1�У���������
% % yy(6)=Iresize(row+5,col-10);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % yy(5)=Iresize(row+6,col-11);%%��row-1�У���������
% % yy(4)=Iresize(row+6,col-12);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % yy(3)=Iresize(row+7,col-13);%%��row-1�У���������
% % yy(2)=Iresize(row+7,col-14);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % yy(1)=Iresize(row+8,col-15);%%%%���һ������Ϊ����������һ���棬���ԳɶԳ���
% % 
% % yyy=[yy,y];%%%���⼸��y���긳ֵ��һ������yyy
% % figure,plot(x45,yyy);legend('big MA 26.5��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%bigMA26.5������
% % % 
% % % x45=1:31;
% % % y=zeros(1,16);
% % % yy=zeros(1,15);
% % % %���ҳ���tana=1/2,-26.6�����������
% % % %%���ұߵ�һ�����꿪ʼ���ó���y
% % % %%%%%%%%%%%%%%%�ź����ǣ�����д���ˡ�������
% % % y(16)=Iresize(row,col);%%��row�У���������
% % % y(15)=Iresize(row,col-1);
% % % y(14)=Iresize(row-1,col-2);%%��row-1�У���������
% % % y(13)=Iresize(row-1,col-3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(12)=Iresize(row-2,col-4);%%��row-1�У���������
% % % y(11)=Iresize(row-2,col-5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(10)=Iresize(row-3,col-6);%%��row-1�У���������
% % % y(9)=Iresize(row-3,col-7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(8)=Iresize(row-4,col-8);%%��row-1�У���������
% % % y(7)=Iresize(row-4,col-9);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(6)=Iresize(row-5,col-10);%%��row-1�У���������
% % % y(5)=Iresize(row-5,col-11);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(4)=Iresize(row-6,col-12);%%��row-1�У���������
% % % y(3)=Iresize(row-6,col-13);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(2)=Iresize(row-7,col-14);%%��row-1�У���������
% % % y(1)=Iresize(row-7,col-15);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % %%%%%%%%%��ʼ��һ�룬���²��֣�����15������,��ʱ��Ҫ����
% % % yy(1)=Iresize(row+1,col+1);%%��row�У���������
% % % yy(2)=Iresize(row+1,col+2);
% % % yy(3)=Iresize(row+2,col+3);%%��row-1�У���������
% % % yy(4)=Iresize(row+2,col+4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(5)=Iresize(row+3,col+5);%%��row-1�У���������
% % % yy(6)=Iresize(row+3,col+6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(7)=Iresize(row+4,col+7);%%��row-1�У���������
% % % yy(8)=Iresize(row+4,col+8);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(9)=Iresize(row+5,col+9);%%��row-1�У���������
% % % yy(10)=Iresize(row+5,col+10);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(11)=Iresize(row+6,col+11);%%��row-1�У���������
% % % yy(12)=Iresize(row+6,col+12);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(13)=Iresize(row+7,col+13);%%��row-1�У���������
% % % yy(14)=Iresize(row+7,col+14);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(15)=Iresize(row+8,col+15);%%%%���һ������Ϊ����������һ���棬���ԳɶԳ���
% % % 
% % % yyy=[y,yy];%%%���⼸��y���긳ֵ��һ������yyy
% % % figure,plot(x45,yyy);legend('big MA -26.5��');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'big MA -26.5��
% % % x45=1:31;
% % % y=zeros(1,16);
% % % yy=zeros(1,15);
% % % y(1)=Iresize(row,col);%%��row�У���������
% % % y(2)=Iresize(row-1,col);
% % % y(3)=Iresize(row-2,col+1);%%��row-1�У���������
% % % y(4)=Iresize(row-3,col+1);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(5)=Iresize(row-4,col+2);%%��row-1�У���������
% % % y(6)=Iresize(row-5,col+2);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(7)=Iresize(row-6,col+3);%%��row-1�У���������
% % % y(8)=Iresize(row-7,col+3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(9)=Iresize(row-8,col+4);%%��row-1�У���������
% % % y(10)=Iresize(row-9,col+4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(11)=Iresize(row-10,col+5);%%��row-1�У���������
% % % y(12)=Iresize(row-11,col+5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(13)=Iresize(row-12,col+6);%%��row-1�У���������
% % % y(14)=Iresize(row-13,col+6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(15)=Iresize(row-14,col+7);%%��row-1�У���������
% % % y(16)=Iresize(row-15,col+7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % %%%%%%%%%��ʼ��һ�룬���²��֣�����15������,��ʱ��Ҫ����
% % % yy(15)=Iresize(row+1,col-1);%%��row�У���������
% % % yy(14)=Iresize(row+2,col-1);
% % % yy(13)=Iresize(row+3,col-2);%%��row-1�У���������
% % % yy(12)=Iresize(row+4,col-2);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(11)=Iresize(row+5,col-3);%%��row-1�У���������
% % % yy(10)=Iresize(row+6,col-3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(9)=Iresize(row+7,col-4);%%��row-1�У���������
% % % yy(8)=Iresize(row+8,col-4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(7)=Iresize(row+9,col-5);%%��row-1�У���������
% % % yy(6)=Iresize(row+10,col-5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(5)=Iresize(row+11,col-6);%%��row-1�У���������
% % % yy(4)=Iresize(row+12,col-6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(3)=Iresize(row+13,col-7);%%��row-1�У���������
% % % yy(2)=Iresize(row+14,col-7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(1)=Iresize(row+15,col-8);%%%%���һ������Ϊ����������һ���棬���ԳɶԳ���
% % % 
% % % yyy=[yy,y];%%%���⼸��y���긳ֵ��һ������yyy
% % % figure,plot(x45,yyy);legend('big MA 63.5��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%bigMA63.5������

% % % x45=1:31;
% % % y=zeros(1,16);
% % % yy=zeros(1,15);
% % % y(1)=Iresize(row,col);%%��row�У���������
% % % y(2)=Iresize(row+1,col);
% % % y(3)=Iresize(row+2,col+1);%%��row-1�У���������
% % % y(4)=Iresize(row+3,col+1);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(5)=Iresize(row+4,col+2);%%��row-1�У���������
% % % y(6)=Iresize(row+5,col+2);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(7)=Iresize(row+6,col+3);%%��row-1�У���������
% % % y(8)=Iresize(row+7,col+3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(9)=Iresize(row+8,col+4);%%��row-1�У���������
% % % y(10)=Iresize(row+9,col+4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(11)=Iresize(row+10,col+5);%%��row-1�У���������
% % % y(12)=Iresize(row+11,col+5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(13)=Iresize(row+12,col+6);%%��row-1�У���������
% % % y(14)=Iresize(row+13,col+6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % y(15)=Iresize(row+14,col+7);%%��row-1�У���������
% % % y(16)=Iresize(row+15,col+7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % %%%%%%%%%��ʼ��һ�룬���²��֣�����15������,��ʱ��Ҫ����
% % % yy(15)=Iresize(row-1,col-1);%%��row�У���������
% % % yy(14)=Iresize(row-2,col-1);
% % % yy(13)=Iresize(row-3,col-2);%%��row-1�У���������
% % % yy(12)=Iresize(row-4,col-2);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(11)=Iresize(row-5,col-3);%%��row-1�У���������
% % % yy(10)=Iresize(row-6,col-3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(9)=Iresize(row-7,col-4);%%��row-1�У���������
% % % yy(8)=Iresize(row-8,col-4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(7)=Iresize(row-9,col-5);%%��row-1�У���������
% % % yy(6)=Iresize(row-10,col-5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(5)=Iresize(row-11,col-6);%%��row-1�У���������
% % % yy(4)=Iresize(row-12,col-6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(3)=Iresize(row-13,col-7);%%��row-1�У���������
% % % yy(2)=Iresize(row-14,col-7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
% % % yy(1)=Iresize(row-15,col-8);%%%%���һ������Ϊ����������һ���棬���ԳɶԳ���
% % % 
% % % yyy=[yy,y];%%%���⼸��y���긳ֵ��һ������yyy
% % % figure,plot(x45,yyy);legend('big MA -63.5��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'big MA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-63.5��ɹ��ĳ���


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% row=197;
% col=84;
% r=15;
% x0=1:31;
% y0=Iresize(197,(84-r):(84+r));%%%��MA��0��
% figure,plot(x0,y0);
% legend('0��');
% 
% r=15;
% x1=1:31;
% y1=Iresize((197-r):(197+r),84);%%%��MA��90��
% figure,plot(x1,y1);
% legend('90��');
%%%%%%%%%%%%%%%%%%%%%%%%%%���������ڳɹ���СMA�������ߵ�  0���90��
% x45=1:31;
% y=zeros(1,15);
% yy=zeros(1,16);
% % ii=0;
% for i=1:1:r%%%���ҳ���45�����������
%     y(i)=Iresize(row-i,col+i);%%%%���ұߵ�һ�����꿪ʼ���ó���y
% end
% for i=1:1:r%%%%%������ʾ��С����������µ����Ŀ���
%     yy(r+1-i)=Iresize(row+i,col-i);%%%%%���� ��ߵĵ�һ�����ؿ�ʼ���ߵ������������ 
% end
% yy(16)=Iresize(row,col);%%%%��yy��16����ֵΪ���ĵ�����                       ���к���ò�ƾͶԡ���������������������������
% yyy=[yy,y];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x45,yyy);legend('small MA 45��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������СMA��45�����߳���
% x135=1:31;
% y=zeros(1,16);
% yy=zeros(1,15);
% for i=1:1:r%%%�ҳ�135
%     y(r+1-i)=Iresize(row-i,col-i);%%%%���ұߵ�һ�����꿪ʼ���ó���y
% end
% for i=1:1:r%%%%%������ʾ��С����������µ����Ŀ���
%     yy(i)=Iresize(row+i,col+i);%%%%%���� ��ߵĵ�һ�����ؿ�ʼ���ߵ������������ 
% end
% y(16)=Iresize(row,col);%%%%��yy��16����ֵΪ���ĵ�����                       ���к���ò�ƾͶԡ���������������������������
% yyy=[y,yy];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x135,yyy);legend('small MA 135��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������СMA135��������


% r=15;
% x0=1:31;
% y0=Iresize(458,(234-r):(234+r));%%%��MA��0��
% figure,plot(x0,y0);
% legend('0��');
% 
% r=15;
% x1=1:31;
% y1=Iresize((458-r):(458+r),234);%%%��MA��90��
% figure,plot(x1,y1);
% legend('90��');
%%%%%%%%%%%%%%%%%%%%%%%%%%���������ڳɹ���ϸ�����ĳ������ߵ�  0���90��
% row=458;
% col=234;
% r=15;
% x45=1:31;
% y=zeros(1,15);
% yy=zeros(1,16);
% % ii=0;
% for i=1:1:r%%%���ҳ���45�����������
%     y(i)=Iresize(row-i,col+i);%%%%���ұߵ�һ�����꿪ʼ���ó���y
% end
% for i=1:1:r%%%%%������ʾ��С����������µ����Ŀ���
%     yy(r+1-i)=Iresize(row+i,col-i);%%%%%���� ��ߵĵ�һ�����ؿ�ʼ���ߵ������������ 
% end
% yy(16)=Iresize(row,col);%%%%��yy��16����ֵΪ���ĵ�����                       ���к���ò�ƾͶԡ���������������������������
% yyy=[yy,y];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x45,yyy);legend('thin line 45��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������ϸ������45�����߳���
% row=458;
% col=234;
% r=15;
% x135=1:31;
% y=zeros(1,16);
% yy=zeros(1,15);
% for i=1:1:r%%%�ҳ�135
%     y(r+1-i)=Iresize(row-i,col-i);%%%%���ұߵ�һ�����꿪ʼ���ó���y
% end
% for i=1:1:r%%%%%������ʾ��С����������µ����Ŀ���
%     yy(i)=Iresize(row+i,col+i);%%%%%���� ��ߵĵ�һ�����ؿ�ʼ���ߵ������������ 
% end
% y(16)=Iresize(row,col);%%%%��yy��16����ֵΪ���ĵ�����                       ���к���ò�ƾͶԡ���������������������������
% yyy=[y,yy];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x135,yyy);legend('thin line 135��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������ϸ����135��������
% row=351;
% col=197;
% r=15;
% x0=1:31;
% y0=Iresize(row,(col-r):(col+r));%%%��MA��0��
% figure,plot(x0,y0);
% legend('0��');
% 
% r=15;
% x1=1:31;
% y1=Iresize((row-r):(row+r),col);%%%��MA��90��
% figure,plot(x1,y1);
% legend('90��');
% %%%%%%%%%%%%%%%%%%%%%%%%%%���������ڳɹ���Ѫ�ܽ���ĳ������ߵ�  0���90��Ѫ�ܽ��棨197��351��
% row=351;
% col=197;
% r=15;
% x45=1:31;
% y=zeros(1,15);
% yy=zeros(1,16);
% % ii=0;
% for i=1:1:r%%%���ҳ���45�����������
%     y(i)=Iresize(row-i,col+i);%%%%���ұߵ�һ�����꿪ʼ���ó���y
% end
% for i=1:1:r%%%%%������ʾ��С����������µ����Ŀ���
%     yy(r+1-i)=Iresize(row+i,col-i);%%%%%���� ��ߵĵ�һ�����ؿ�ʼ���ߵ������������ 
% end
% yy(16)=Iresize(row,col);%%%%��yy��16����ֵΪ���ĵ�����                       ���к���ò�ƾͶԡ���������������������������
% yyy=[yy,y];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x45,yyy);legend('vessel cross 45��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ǽ���Ѫ��45�����߳���
% row=351;
% col=197;
% r=15;
% x135=1:31;
% y=zeros(1,16);
% yy=zeros(1,15);
% for i=1:1:r%%%�ҳ�135
%     y(r+1-i)=Iresize(row-i,col-i);%%%%���ұߵ�һ�����꿪ʼ���ó���y
% end
% for i=1:1:r%%%%%������ʾ��С����������µ����Ŀ���
%     yy(i)=Iresize(row+i,col+i);%%%%%���� ��ߵĵ�һ�����ؿ�ʼ���ߵ������������ 
% end
% y(16)=Iresize(row,col);%%%%��yy��16����ֵΪ���ĵ�����                       ���к���ò�ƾͶԡ���������������������������
% yyy=[y,yy];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x135,yyy);legend('vessel cross 135��');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ǽ���Ѫ��135�����߳���


% x45=1:31;
% y=zeros(1,15);
% yy=zeros(1,16);
% % ii=0;
% for i=1:1:r%%%���ҳ���45���������
%     for j=1:1:r%%%%%������ʾ�����ĵ����Ͻ�
% %       ii=i+ii;  
%     y(i)=Iresize(312+j,271-i);%%%%���ұߵ�һ�����꿪ʼ���ó���y
%     end
% end
% 
% for i=1:1:r
%     for j=1:1:r%%%%%������ʾ��С����������µ����Ŀ���
%     yy(r+1-i)=Iresize(312-j,271+i);%%%%%���� ��ߵĵ�һ�����ؿ�ʼ���ߵ������������ 
%     end
% end
% yy(16)=Iresize(312,271);%%%%��yy��16����ֵΪ���ĵ�����                       ���к���ò�ƾͶԡ���������������������������
% yyy=[yy,y];
% [m,n]=size(yyy);
% figure,plot(x45,yyy);legend('45��');
% figure,bar(yyy);
% xlabel('X axis');



