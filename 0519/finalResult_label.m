clc
clear all
tic;
imgnum=13;%%ͼ��Ĵ���
nm=strcat('D:\wzz\ROC_db\ROCtraining\image',num2str(imgnum),'_training.jpg');
I=imread(nm);
f=im2double(I(:,:,2));f0=im2double(I(:,:,2));%%��ȡ��ɫͨ��
% figure,imshow(f,[]);
[m,n]=size(f0);Ibg=medfilt2(f,[25 25]);%%%����ͼ��Ļ�ȡ
% figure,imshow(Ibg,[]);
Isc=Ibg-f;%%%%����ɫͨ��ͼ�����Ƴ�����
% figure,imshow(Isc,[]);
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
% figure,imshow(foll,[]);
Ilesion=Isc-fo11;
% figure,imshow(Ilesion,[]);
%%%%%%%%the end of top-hat%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%ʹ΢СѪ�����ӱ����и��ӵ�͹�ԣ���Ilesion���и�˹�˲�
h = fspecial('gaussian',[11,11],1);
Imatchnew=conv2(Ilesion,h);
% figure,imshow(Imatchnew,[]);
Imatchnew1=Imatchnew./255;
IID=find(Imatchnew1<max(Imatchnew1(:)*0.3));%%%���������ֵ������һ������С��ѡ�������
Imatchnew1(IID)=0;
% figure,imshow(Imatchnew1,[]);
%%%%%%%%%%%%%%%%%%Ԥ������̽���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img=imresize(Imatchnew1,[m,n]);
% figure,imshow(img,[]);
clear LL1;
LL1=bwlabel(img);%%%����ͼ���е�ı߽�
% [r, c] = find(L==2);
s = regionprops(LL1,'centroid');
centroids = cat(1, s.Centroid);%%plot(centroids(:,1),centroids(:,2), 'b*')
[mm,nn]=size(centroids);
for ii=1:mm
    seed(ii,:)=[round(centroids(ii,1)),round(centroids(ii,2))];%%%���к���
end
%% �жϵ�ǰcentroids�Ƿ������֮��Ľ����ͬ�������ͬ������LL1��������ӫ����ɫ
load('E:\WZZ\OneDrive\0407\0519\EN\scores_maps.mat');
    coor=cell2mat(scores_maps(3)); 

            for jj=1:size(seed,1);
                X=seed(jj,1);Y=seed(jj,2);              
                    for j = 1:size(coor,1)
                        
                            x=coor(j,1);y=coor(j,2);
                             d=sqrt((x-X)*(x-X)+(y-Y)*(y-Y));
                                if d<=10
                                    index(jj)=1;
                                    break;
                                else
                                    index(jj)=0;
                                end
                     
                    end
            end
indexx=find(index(:)==1)
            Ig=I(:,:,2);

for i=1:length(indexx)           
    [r, c] = find(LL1==indexx(i));
    I(r,c)=0;
end
figure,imshow(I,[]);
imwrite(I,'label.png');




%% �ҳ���ǩΪ1�ĺ�ѡ�⣬�������ע
% load('E:\WZZ\OneDrive\0407\0519\EN\scores_maps.mat');
%     coor=cell2mat(scores_maps(3)); 
% 
%             for jj=1:size(seed,1);
%                 X=seed(jj,1);Y=seed(jj,2);
%                
%                     for j = 1:size(coor,1)
%                         if coor(j,4)==1
%                             x=coor(j,1);y=coor(j,2);
%                              d=sqrt((x-X)*(x-X)+(y-Y)*(y-Y));
%                                 if d<=10
%                                     index(jj)=1;
%                                     break;
%                                 else
%                                     index(jj)=0;
%                                 end
%                         end
%                     end
%             end
% indexx=find(index(:)==1)
%             Ig=I(:,:,2);
% for i=1:length(indexx)           
%     [r, c] = find(LL1==indexx(i));
%     I(r,c)=0;
% end
% figure,imshow(I,[]);
% 
