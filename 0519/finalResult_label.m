clc
clear all
tic;
imgnum=13;%%图像的次序
nm=strcat('D:\wzz\ROC_db\ROCtraining\image',num2str(imgnum),'_training.jpg');
I=imread(nm);
f=im2double(I(:,:,2));f0=im2double(I(:,:,2));%%提取绿色通道
% figure,imshow(f,[]);
[m,n]=size(f0);Ibg=medfilt2(f,[25 25]);%%%背景图像的获取
% figure,imshow(Ibg,[]);
Isc=Ibg-f;%%%%从绿色通道图像中移除背景
% figure,imshow(Isc,[]);
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
% figure,imshow(foll,[]);
Ilesion=Isc-fo11;
% figure,imshow(Ilesion,[]);
%%%%%%%%the end of top-hat%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%使微小血管瘤从背景中更加的凸显，对Ilesion进行高斯滤波
h = fspecial('gaussian',[11,11],1);
Imatchnew=conv2(Ilesion,h);
% figure,imshow(Imatchnew,[]);
Imatchnew1=Imatchnew./255;
IID=find(Imatchnew1<max(Imatchnew1(:)*0.3));%%%对其进行阈值化，进一步来缩小候选解的数量
Imatchnew1(IID)=0;
% figure,imshow(Imatchnew1,[]);
%%%%%%%%%%%%%%%%%%预处理过程结束%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img=imresize(Imatchnew1,[m,n]);
% figure,imshow(img,[]);
clear LL1;
LL1=bwlabel(img);%%%求解出图像中点的边界
% [r, c] = find(L==2);
s = regionprops(LL1,'centroid');
centroids = cat(1, s.Centroid);%%plot(centroids(:,1),centroids(:,2), 'b*')
[mm,nn]=size(centroids);
for ii=1:mm
    seed(ii,:)=[round(centroids(ii,1)),round(centroids(ii,2))];%%%先行后列
end
%% 判断当前centroids是否与分类之后的结果相同，如果相同，返回LL1，将其变成荧光绿色
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




%% 找出标签为1的候选解，并将其标注
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
