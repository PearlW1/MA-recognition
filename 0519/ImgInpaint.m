clc
clear all
% read img
imgnum=10;%%图像的次序
nm=strcat('D:\wzz\ROC_db\ROCtraining\image',num2str(imgnum),'_training.jpg');
I=imread(nm);
Igreen = I(:,:,2);
[m,n]=size(Igreen);
mask=Igreen<30;%% 获取眼膜，并用腐蚀膨胀的方法去掉那些杂点，要一个干净的眼膜。
se=strel('disk',2);
mask1=imdilate(mask,se);
mask2=imerode(mask1,se);
mask3=~mask2;
mask4=imdilate(mask3,se);
mask5=imerode(mask4,se);%%最终的纯净的眼膜图像，FOV是白色，其他是黑色
imshow(mask5,[]);
%% CSP特征提取之前的处理
Ienh= adapthisteq(Igreen,'clipLimit',0.03,'Distribution','rayleigh');%%输入需要是uint8, uint16, int16, single, or double，不过double的好像不行，原始数据时unit
Iinv=255-Ienh;%%%%绿色通道取反
f = fspecial('gaussian',[11 11],1.0);%%h = fspecial('gaussian', hsize, sigma)
Ismooth = imfilter(Iinv,f,'same');%%%%%高斯平滑，或者可用conv2,nlfilter,能够得到类似滑窗的效果
% imtool(Ismooth,[]);
Ibg=medfilt2(Ismooth,[25 25]);%%%背景图像的获取
% imshow(Ibg,[]); imtool(Ibg,[]);
%% 以周围邻域像素的平均值作为拓展的像素值亮度，选取【25，25】的小窗进行均值计算，
%% 以保证不能干扰到候选解的判别，不选择邻域小窗口像素的原因：窗口太小，本身会造成亮度诧异，形成峰值，干扰识别
a2=round(mean2(Ismooth)); %第二种方法：用函数mean2求总均值
a3=im2uint8(a2/255);
%B = reshape(A,[5,2])
I1=reshape(Ismooth,[m*n,1]);
M1=reshape(mask5,[m*n,1]);
Is=I1&M1;
Iss=reshape(Is,[m,n]);
imshow(Iss,[]);
IL=zeros(m,n);
 for i=1:1:m
     for j=1:1:n
         if mask5(i,j)==1
             IL(i,j)=Ismooth(i,j);%% FOV 外面是纯黑的
         end
     end
 end
 imshow(IL,[]);
 %% 第一行进行图像修补
out=zeros(m+40,n);
out=im2uint8(out);
for ii=20:-1:1
    i=1;
    for j=1:1:n
        if mask5(i,j)==1
           out(ii,j)=a3;
        end
    end
end
for ii=m+21:1:m+40
    i=m;
    for j=1:1:n
        if mask5(i,j)==1
            out(ii,j)=a3;
        end
    end
end
out(21:m+20,1:n)=Ismooth;
imshow(out,[]);








%     ii=0;jj=0;
% for i=21:1:m+21
%     ii=ii+1;
%     for j=1:1:n-1
%         jj=jj+1;
%         out(i,j)=Ismooth(ii,jj);
%     end
% end
% 
%   imshow(out,[]);title('ss');      
% 
% for i=1:1:1
%     for j=1:1:n
%         if mask5(i,j)==1
%             if j<round(n/2)
%                 out(i+19,j)=a3;
%             else
%                 out(i+19,j)=a3;
%             end
%         end
%     end
% end
% 
% 


% % for i=1:1:1
% %     for j=1:1:n
% %         if mask5(i,j)==1
% %             if j<round(n/2)
% %                 out(i+19,j)=round(mean2(Ismooth(i:i+19,j:j+19)));
% %             else
% %                 out(i+19,j)=round(mean2(Ismooth(i:i-19,j:j+19)));
% %             end
% %         end
% %     end
% % end