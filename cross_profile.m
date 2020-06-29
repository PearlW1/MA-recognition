function [degrees,P]=cross_profile(Iresize,row,col,r)
%CROSS_PROFILE Computes the cross sectional profile. 
%centering of maximum value with the position (row,col),range from [-r,r].
%[X,Y]=cross_profile(row,col,r)
%    input:
%           Iresize:input image, draw the profile in the image using its
%           corresponding pixels value
%           row:  row of local maximum value 
%           col:  column of local maximum value 
%           r  ： default value is 31, (row,col)is the center of the profile
%           and left side with 15 pixels, right side with 15 pixels.
%    output:
%           output the profile in different degrees. show on axis.
%
%           maybe some features properties of the profiles, now, i have no
%           idea about the output...
%           degree:degrees of each profile in order
%           P:is an array in size 8*31
%           centeridx:is the center location of the only peak,select in the
%           31 pixels by which is Most occurrences.
%   finally,I add the data smooth for obtaining smooth curve.
%% first, draw the profile in 0°
x0=1:31;
y0=Iresize(row,(col-r):(col+r));%%%大MA：0°
% figure,plot(x0,y0);legend('0°');
%% second, draw the profile in 90°
x1=1:31;
y90=Iresize((row-r):(row+r),col)';%%%大MA：90°
% figure,plot(x1,y90);legend('90°');
%% third, draw the profile in 45°
x45=1:31;
y=zeros(1,15);
yy=zeros(1,16);
for i=1:1:r%%%线找出正45°的轮廓线行
    y(i)=Iresize(row-i,col+i);%%%%从右边第一个坐标开始，得出的y
end
for i=1:1:r%%%%%这样表示最小的坐标从坐下到中心靠近
    yy(r+1-i)=Iresize(row+i,col-i);%%%%%从最 左边的第一个像素开始，走到标记中心坐标 
end
yy(16)=Iresize(row,col);%%%%将yy（16）赋值为中心点坐标                       线列后行貌似就对。。。。。。。。。。。。。。
y45=[yy,y];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x45,y45);legend('45°');
%% forth, draw the profile in -45°,also in 135°
x135=1:31;
y=zeros(1,16);
yy=zeros(1,15);
for i=1:1:r%%%找出135
    y(r+1-i)=Iresize(row-i,col-i);%%%%从右边第一个坐标开始，得出的y
end
for i=1:1:r%%%%%这样表示最小的坐标从坐下到中心靠近
    yy(i)=Iresize(row+i,col+i);%%%%%从最 左边的第一个像素开始，走到标记中心坐标 
end
y(16)=Iresize(row,col);%%%%将yy（16）赋值为中心点坐标                       线列后行貌似就对。。。。。。。。。。。。。。
yp45=[y,yy];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x135,yp45);legend('-45°');
%% fifth, draw the profile in 26.6°
x45=1:31;
y=zeros(1,16);
yy=zeros(1,15);
%线找出正tana=1/2,26.6°的轮廓线行
%%从右边第一个坐标开始，得出的y
y(1)=Iresize(row,col);%%第row行，两个像素
y(2)=Iresize(row,col+1);
y(3)=Iresize(row-1,col+2);%%第row-1行，两个像素
y(4)=Iresize(row-1,col+3);%%%%列一直在更新，只是行，更新的慢了一个步长
y(5)=Iresize(row-2,col+4);%%第row-1行，两个像素
y(6)=Iresize(row-2,col+5);%%%%列一直在更新，只是行，更新的慢了一个步长
y(7)=Iresize(row-3,col+6);%%第row-1行，两个像素
y(8)=Iresize(row-3,col+7);%%%%列一直在更新，只是行，更新的慢了一个步长
y(9)=Iresize(row-4,col+8);%%第row-1行，两个像素
y(10)=Iresize(row-4,col+9);%%%%列一直在更新，只是行，更新的慢了一个步长
y(11)=Iresize(row-5,col+10);%%第row-1行，两个像素
y(12)=Iresize(row-5,col+11);%%%%列一直在更新，只是行，更新的慢了一个步长
y(13)=Iresize(row-6,col+12);%%第row-1行，两个像素
y(14)=Iresize(row-6,col+13);%%%%列一直在更新，只是行，更新的慢了一个步长
y(15)=Iresize(row-7,col+14);%%第row-1行，两个像素
y(16)=Iresize(row-7,col+15);%%%%列一直在更新，只是行，更新的慢了一个步长
%%%%%%%%%开始另一半，左下部分，包含15个像素,此时需要倒序
yy(15)=Iresize(row+1,col-1);%%第row行，两个像素
yy(14)=Iresize(row+1,col-2);
yy(13)=Iresize(row+2,col-3);%%第row-1行，两个像素
yy(12)=Iresize(row+2,col-4);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(11)=Iresize(row+3,col-5);%%第row-1行，两个像素
yy(10)=Iresize(row+3,col-6);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(9)=Iresize(row+4,col-7);%%第row-1行，两个像素
yy(8)=Iresize(row+4,col-8);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(7)=Iresize(row+5,col-9);%%第row-1行，两个像素
yy(6)=Iresize(row+5,col-10);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(5)=Iresize(row+6,col-11);%%第row-1行，两个像素
yy(4)=Iresize(row+6,col-12);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(3)=Iresize(row+7,col-13);%%第row-1行，两个像素
yy(2)=Iresize(row+7,col-14);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(1)=Iresize(row+8,col-15);%%%%多出一个，因为这里是两个一更替，所以成对出现

y26=[yy,y];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x45,y26);legend('26.5°');
%% sixth, draw the profile in -26.5°

x45=1:31;
y=zeros(1,16);
yy=zeros(1,15);
%线找出正tana=1/2,-26.6°的轮廓线行
%%从右边第一个坐标开始，得出的y
y(16)=Iresize(row,col);%%第row行，两个像素
y(15)=Iresize(row,col-1);
y(14)=Iresize(row-1,col-2);%%第row-1行，两个像素
y(13)=Iresize(row-1,col-3);%%%%列一直在更新，只是行，更新的慢了一个步长
y(12)=Iresize(row-2,col-4);%%第row-1行，两个像素
y(11)=Iresize(row-2,col-5);%%%%列一直在更新，只是行，更新的慢了一个步长
y(10)=Iresize(row-3,col-6);%%第row-1行，两个像素
y(9)=Iresize(row-3,col-7);%%%%列一直在更新，只是行，更新的慢了一个步长
y(8)=Iresize(row-4,col-8);%%第row-1行，两个像素
y(7)=Iresize(row-4,col-9);%%%%列一直在更新，只是行，更新的慢了一个步长
y(6)=Iresize(row-5,col-10);%%第row-1行，两个像素
y(5)=Iresize(row-5,col-11);%%%%列一直在更新，只是行，更新的慢了一个步长
y(4)=Iresize(row-6,col-12);%%第row-1行，两个像素
y(3)=Iresize(row-6,col-13);%%%%列一直在更新，只是行，更新的慢了一个步长
y(2)=Iresize(row-7,col-14);%%第row-1行，两个像素
y(1)=Iresize(row-7,col-15);%%%%列一直在更新，只是行，更新的慢了一个步长
%%%%%%%%%开始另一半，左下部分，包含15个像素,此时需要倒序
yy(1)=Iresize(row+1,col+1);%%第row行，两个像素
yy(2)=Iresize(row+1,col+2);
yy(3)=Iresize(row+2,col+3);%%第row-1行，两个像素
yy(4)=Iresize(row+2,col+4);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(5)=Iresize(row+3,col+5);%%第row-1行，两个像素
yy(6)=Iresize(row+3,col+6);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(7)=Iresize(row+4,col+7);%%第row-1行，两个像素
yy(8)=Iresize(row+4,col+8);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(9)=Iresize(row+5,col+9);%%第row-1行，两个像素
yy(10)=Iresize(row+5,col+10);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(11)=Iresize(row+6,col+11);%%第row-1行，两个像素
yy(12)=Iresize(row+6,col+12);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(13)=Iresize(row+7,col+13);%%第row-1行，两个像素
yy(14)=Iresize(row+7,col+14);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(15)=Iresize(row+8,col+15);%%%%多出一个，因为这里是两个一更替，所以成对出现

yp26=[y,yy];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x45,yp26);legend('-26.5°');
%% seventh, draw the profile in 63.5°
x45=1:31;
y=zeros(1,16);
yy=zeros(1,15);
y(1)=Iresize(row,col);%%第row行，两个像素
y(2)=Iresize(row-1,col);
y(3)=Iresize(row-2,col+1);%%第row-1行，两个像素
y(4)=Iresize(row-3,col+1);%%%%列一直在更新，只是行，更新的慢了一个步长
y(5)=Iresize(row-4,col+2);%%第row-1行，两个像素
y(6)=Iresize(row-5,col+2);%%%%列一直在更新，只是行，更新的慢了一个步长
y(7)=Iresize(row-6,col+3);%%第row-1行，两个像素
y(8)=Iresize(row-7,col+3);%%%%列一直在更新，只是行，更新的慢了一个步长
y(9)=Iresize(row-8,col+4);%%第row-1行，两个像素
y(10)=Iresize(row-9,col+4);%%%%列一直在更新，只是行，更新的慢了一个步长
y(11)=Iresize(row-10,col+5);%%第row-1行，两个像素
y(12)=Iresize(row-11,col+5);%%%%列一直在更新，只是行，更新的慢了一个步长
y(13)=Iresize(row-12,col+6);%%第row-1行，两个像素
y(14)=Iresize(row-13,col+6);%%%%列一直在更新，只是行，更新的慢了一个步长
y(15)=Iresize(row-14,col+7);%%第row-1行，两个像素
y(16)=Iresize(row-15,col+7);%%%%列一直在更新，只是行，更新的慢了一个步长
%%%%%%%%%开始另一半，左下部分，包含15个像素,此时需要倒序
yy(15)=Iresize(row+1,col-1);%%第row行，两个像素
yy(14)=Iresize(row+2,col-1);
yy(13)=Iresize(row+3,col-2);%%第row-1行，两个像素
yy(12)=Iresize(row+4,col-2);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(11)=Iresize(row+5,col-3);%%第row-1行，两个像素
yy(10)=Iresize(row+6,col-3);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(9)=Iresize(row+7,col-4);%%第row-1行，两个像素
yy(8)=Iresize(row+8,col-4);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(7)=Iresize(row+9,col-5);%%第row-1行，两个像素
yy(6)=Iresize(row+10,col-5);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(5)=Iresize(row+11,col-6);%%第row-1行，两个像素
yy(4)=Iresize(row+12,col-6);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(3)=Iresize(row+13,col-7);%%第row-1行，两个像素
yy(2)=Iresize(row+14,col-7);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(1)=Iresize(row+15,col-8);%%%%多出一个，因为这里是两个一更替，所以成对出现

y63=[yy,y];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x45,y63);legend('63.5°');
%% eighth, draw the profile in -63.5°
x45=1:31;
y=zeros(1,16);
yy=zeros(1,15);
y(1)=Iresize(row,col);%%第row行，两个像素
y(2)=Iresize(row+1,col);
y(3)=Iresize(row+2,col+1);%%第row-1行，两个像素
y(4)=Iresize(row+3,col+1);%%%%列一直在更新，只是行，更新的慢了一个步长
y(5)=Iresize(row+4,col+2);%%第row-1行，两个像素
y(6)=Iresize(row+5,col+2);%%%%列一直在更新，只是行，更新的慢了一个步长
y(7)=Iresize(row+6,col+3);%%第row-1行，两个像素
y(8)=Iresize(row+7,col+3);%%%%列一直在更新，只是行，更新的慢了一个步长
y(9)=Iresize(row+8,col+4);%%第row-1行，两个像素
y(10)=Iresize(row+9,col+4);%%%%列一直在更新，只是行，更新的慢了一个步长
y(11)=Iresize(row+10,col+5);%%第row-1行，两个像素
y(12)=Iresize(row+11,col+5);%%%%列一直在更新，只是行，更新的慢了一个步长
y(13)=Iresize(row+12,col+6);%%第row-1行，两个像素
y(14)=Iresize(row+13,col+6);%%%%列一直在更新，只是行，更新的慢了一个步长
y(15)=Iresize(row+14,col+7);%%第row-1行，两个像素
y(16)=Iresize(row+15,col+7);%%%%列一直在更新，只是行，更新的慢了一个步长
%%%%%%%%%开始另一半，左下部分，包含15个像素,此时需要倒序
yy(15)=Iresize(row-1,col-1);%%第row行，两个像素
yy(14)=Iresize(row-2,col-1);
yy(13)=Iresize(row-3,col-2);%%第row-1行，两个像素
yy(12)=Iresize(row-4,col-2);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(11)=Iresize(row-5,col-3);%%第row-1行，两个像素
yy(10)=Iresize(row-6,col-3);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(9)=Iresize(row-7,col-4);%%第row-1行，两个像素
yy(8)=Iresize(row-8,col-4);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(7)=Iresize(row-9,col-5);%%第row-1行，两个像素
yy(6)=Iresize(row-10,col-5);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(5)=Iresize(row-11,col-6);%%第row-1行，两个像素
yy(4)=Iresize(row-12,col-6);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(3)=Iresize(row-13,col-7);%%第row-1行，两个像素
yy(2)=Iresize(row-14,col-7);%%%%列一直在更新，只是行，更新的慢了一个步长
yy(1)=Iresize(row-15,col-8);%%%%多出一个，因为这里是两个一更替，所以成对出现

yp63=[yy,y];%%%将这几个y坐标赋值给一个数组yyy
% figure,plot(x45,yp63);legend('-63.5°');
%% 输出数据保存
degrees=[0,90,45,135,26.5,-26.5,63.5,-63.5];
P=[y0;y90;y45;yp45;y26;yp26;y63;yp63];

%% 进行数据平滑（得出的数据并非忠于原始数据）
% locss=[];
% for ii=1:8
%     P1=P(ii,:);
%     [pks,locs,widths,proms]=findpeaks(P1);%%峰属性检测
%     if length(pks)>=6%%峰个数大于6，则进行数据平滑处理，得出的数据取代原先的数据
%         Pnew=smooth(P1,5);
%         P(ii,:)=Pnew(:);
%     end
%     locss=[locss,locs];%%返回一串locs的索引
% end
% % 
% % %% 需要从这里返回索引坐标，就是哪个峰值是我们所看好的，根据峰检测中，locs中出现次数最多的，则将其定位最终峰
% % locss1=unique(locss);
% % c=zeros(size(locss1));
% % for e=1:length(locss1)
% %     c(e)=length(find(locss(:)==locss1(e)));
% % end
% % [maxloc,idx]=max(c(:));%%出现最多次数
% % centeridx=locss1(idx);

        

