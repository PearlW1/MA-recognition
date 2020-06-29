function [F]=Intensity_fea(image,row,col)
% 输入：image：rgb图像
%     坐标点的row，col::::图像是先行后列，就是先
%输出： 八个特征
%****************预处理************
Igreen=image(:,:,2);% Igreen = double(I(:,:,2));%%%绿色通道
Ienh= adapthisteq(Igreen,'clipLimit',0.01,'Distribution','rayleigh');%%输入需要是uint8, uint16, int16, single, or double，不过double的好像不行，原始数据时unit
Iinv=255-Ienh;%%%%绿色通道取反
f = fspecial('gaussian',[11 11],1.0);%%h = fspecial('gaussian', hsize, sigma)
Ismooth = imfilter(Iinv,f,'same');%%%%%高斯平滑，或者可用conv2,nlfilter,能够得到类似滑窗的效果
%% 1 取反平滑后点亮度,越大越好
F1 = Ismooth(row,col);
%% 2 rgb变成灰度后的亮度，越小越好，不过这个不咋明显
Igray = rgb2gray(image);
Igray = imfilter(Igray,f,'same');
F2 = Igray(row,col);
%% 3 绿色通道下亮度值，越小越好，不过这个不咋明显
Igreen = imfilter(image(:,:,2),f,'same');
F3=Igreen(row,col);
%% 4 S 通道下，病灶较为明显 ，越大越好，能差十几二十几个像素
HSV = rgb2hsv(image);%%将S通道作为多通道中的一个通道
S=HSV(:,:,2);%figure,imshow(S,[]);title('S');%%MA比较明显，直接就是亮色图像
Su=im2uint8(S);
Su = imfilter(Su,f,'same');
F4 = Su(row,col);
%% 5 V通道下，亮度值，不明显
V=HSV(:,:,3);%figure,imshow(V,[]);title('V');%%MA比较明显，都是暗色图像,将V通道作为一个通道
Vu=im2uint8(V);
Vu = imfilter(Vu,f,'same');
F5 = Vu(row,col);
%% 6 Y通道下，亮度值，MA的能大点越大越好
Y=255-image(:,:,3);
Y = imfilter(Y,f,'same');
F6 = Y(row,col);
%% 7 ycbcr通道下 y通道下，亮度值，越小越好，不过也还是不明显，类似与灰度图像
ycbcr = rgb2ycbcr(image);
y=ycbcr(:,:,1);
y = imfilter(y,f,'same');
F7 = y(row,col);
%% MSCF 高斯相关系数，这个差距较为明显，MA的数值很大，能超过普通像素点，一般差=100左右
% [COE]=MSCF(image);
% F8 = COE(row,col);%% 能否给重要的特征赋予大点的权重。
% F=[F1,F2,F3,F4,F5,F6,F7,F8];
% F=double(F);
F=[F1,F2,F3,F4,F5,F6,F7];
F=double(F);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%预处理结束+++++++++++++++++++++++++++++++++
% x_in=385;y_in=330;%%坐标正常摆放% % % x_in=120;y_in=210;
% row=330;
% col=385;
% row=210;
% col=120;
% row=226; col=428;% xueguan fenzhi 
% row=269; col=126;% 血管交叉
