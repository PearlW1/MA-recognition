function [degrees,P]=cross_profile(Iresize,row,col,r)
%CROSS_PROFILE Computes the cross sectional profile. 
%centering of maximum value with the position (row,col),range from [-r,r].
%[X,Y]=cross_profile(row,col,r)
%    input:
%           Iresize:input image, draw the profile in the image using its
%           corresponding pixels value
%           row:  row of local maximum value 
%           col:  column of local maximum value 
%           r  �� default value is 31, (row,col)is the center of the profile
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
%% first, draw the profile in 0��
x0=1:31;
y0=Iresize(row,(col-r):(col+r));%%%��MA��0��
% figure,plot(x0,y0);legend('0��');
%% second, draw the profile in 90��
x1=1:31;
y90=Iresize((row-r):(row+r),col)';%%%��MA��90��
% figure,plot(x1,y90);legend('90��');
%% third, draw the profile in 45��
x45=1:31;
y=zeros(1,15);
yy=zeros(1,16);
for i=1:1:r%%%���ҳ���45�����������
    y(i)=Iresize(row-i,col+i);%%%%���ұߵ�һ�����꿪ʼ���ó���y
end
for i=1:1:r%%%%%������ʾ��С����������µ����Ŀ���
    yy(r+1-i)=Iresize(row+i,col-i);%%%%%���� ��ߵĵ�һ�����ؿ�ʼ���ߵ������������ 
end
yy(16)=Iresize(row,col);%%%%��yy��16����ֵΪ���ĵ�����                       ���к���ò�ƾͶԡ���������������������������
y45=[yy,y];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x45,y45);legend('45��');
%% forth, draw the profile in -45��,also in 135��
x135=1:31;
y=zeros(1,16);
yy=zeros(1,15);
for i=1:1:r%%%�ҳ�135
    y(r+1-i)=Iresize(row-i,col-i);%%%%���ұߵ�һ�����꿪ʼ���ó���y
end
for i=1:1:r%%%%%������ʾ��С����������µ����Ŀ���
    yy(i)=Iresize(row+i,col+i);%%%%%���� ��ߵĵ�һ�����ؿ�ʼ���ߵ������������ 
end
y(16)=Iresize(row,col);%%%%��yy��16����ֵΪ���ĵ�����                       ���к���ò�ƾͶԡ���������������������������
yp45=[y,yy];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x135,yp45);legend('-45��');
%% fifth, draw the profile in 26.6��
x45=1:31;
y=zeros(1,16);
yy=zeros(1,15);
%���ҳ���tana=1/2,26.6�����������
%%���ұߵ�һ�����꿪ʼ���ó���y
y(1)=Iresize(row,col);%%��row�У���������
y(2)=Iresize(row,col+1);
y(3)=Iresize(row-1,col+2);%%��row-1�У���������
y(4)=Iresize(row-1,col+3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(5)=Iresize(row-2,col+4);%%��row-1�У���������
y(6)=Iresize(row-2,col+5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(7)=Iresize(row-3,col+6);%%��row-1�У���������
y(8)=Iresize(row-3,col+7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(9)=Iresize(row-4,col+8);%%��row-1�У���������
y(10)=Iresize(row-4,col+9);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(11)=Iresize(row-5,col+10);%%��row-1�У���������
y(12)=Iresize(row-5,col+11);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(13)=Iresize(row-6,col+12);%%��row-1�У���������
y(14)=Iresize(row-6,col+13);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(15)=Iresize(row-7,col+14);%%��row-1�У���������
y(16)=Iresize(row-7,col+15);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
%%%%%%%%%��ʼ��һ�룬���²��֣�����15������,��ʱ��Ҫ����
yy(15)=Iresize(row+1,col-1);%%��row�У���������
yy(14)=Iresize(row+1,col-2);
yy(13)=Iresize(row+2,col-3);%%��row-1�У���������
yy(12)=Iresize(row+2,col-4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(11)=Iresize(row+3,col-5);%%��row-1�У���������
yy(10)=Iresize(row+3,col-6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(9)=Iresize(row+4,col-7);%%��row-1�У���������
yy(8)=Iresize(row+4,col-8);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(7)=Iresize(row+5,col-9);%%��row-1�У���������
yy(6)=Iresize(row+5,col-10);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(5)=Iresize(row+6,col-11);%%��row-1�У���������
yy(4)=Iresize(row+6,col-12);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(3)=Iresize(row+7,col-13);%%��row-1�У���������
yy(2)=Iresize(row+7,col-14);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(1)=Iresize(row+8,col-15);%%%%���һ������Ϊ����������һ���棬���ԳɶԳ���

y26=[yy,y];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x45,y26);legend('26.5��');
%% sixth, draw the profile in -26.5��

x45=1:31;
y=zeros(1,16);
yy=zeros(1,15);
%���ҳ���tana=1/2,-26.6�����������
%%���ұߵ�һ�����꿪ʼ���ó���y
y(16)=Iresize(row,col);%%��row�У���������
y(15)=Iresize(row,col-1);
y(14)=Iresize(row-1,col-2);%%��row-1�У���������
y(13)=Iresize(row-1,col-3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(12)=Iresize(row-2,col-4);%%��row-1�У���������
y(11)=Iresize(row-2,col-5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(10)=Iresize(row-3,col-6);%%��row-1�У���������
y(9)=Iresize(row-3,col-7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(8)=Iresize(row-4,col-8);%%��row-1�У���������
y(7)=Iresize(row-4,col-9);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(6)=Iresize(row-5,col-10);%%��row-1�У���������
y(5)=Iresize(row-5,col-11);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(4)=Iresize(row-6,col-12);%%��row-1�У���������
y(3)=Iresize(row-6,col-13);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(2)=Iresize(row-7,col-14);%%��row-1�У���������
y(1)=Iresize(row-7,col-15);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
%%%%%%%%%��ʼ��һ�룬���²��֣�����15������,��ʱ��Ҫ����
yy(1)=Iresize(row+1,col+1);%%��row�У���������
yy(2)=Iresize(row+1,col+2);
yy(3)=Iresize(row+2,col+3);%%��row-1�У���������
yy(4)=Iresize(row+2,col+4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(5)=Iresize(row+3,col+5);%%��row-1�У���������
yy(6)=Iresize(row+3,col+6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(7)=Iresize(row+4,col+7);%%��row-1�У���������
yy(8)=Iresize(row+4,col+8);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(9)=Iresize(row+5,col+9);%%��row-1�У���������
yy(10)=Iresize(row+5,col+10);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(11)=Iresize(row+6,col+11);%%��row-1�У���������
yy(12)=Iresize(row+6,col+12);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(13)=Iresize(row+7,col+13);%%��row-1�У���������
yy(14)=Iresize(row+7,col+14);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(15)=Iresize(row+8,col+15);%%%%���һ������Ϊ����������һ���棬���ԳɶԳ���

yp26=[y,yy];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x45,yp26);legend('-26.5��');
%% seventh, draw the profile in 63.5��
x45=1:31;
y=zeros(1,16);
yy=zeros(1,15);
y(1)=Iresize(row,col);%%��row�У���������
y(2)=Iresize(row-1,col);
y(3)=Iresize(row-2,col+1);%%��row-1�У���������
y(4)=Iresize(row-3,col+1);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(5)=Iresize(row-4,col+2);%%��row-1�У���������
y(6)=Iresize(row-5,col+2);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(7)=Iresize(row-6,col+3);%%��row-1�У���������
y(8)=Iresize(row-7,col+3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(9)=Iresize(row-8,col+4);%%��row-1�У���������
y(10)=Iresize(row-9,col+4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(11)=Iresize(row-10,col+5);%%��row-1�У���������
y(12)=Iresize(row-11,col+5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(13)=Iresize(row-12,col+6);%%��row-1�У���������
y(14)=Iresize(row-13,col+6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(15)=Iresize(row-14,col+7);%%��row-1�У���������
y(16)=Iresize(row-15,col+7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
%%%%%%%%%��ʼ��һ�룬���²��֣�����15������,��ʱ��Ҫ����
yy(15)=Iresize(row+1,col-1);%%��row�У���������
yy(14)=Iresize(row+2,col-1);
yy(13)=Iresize(row+3,col-2);%%��row-1�У���������
yy(12)=Iresize(row+4,col-2);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(11)=Iresize(row+5,col-3);%%��row-1�У���������
yy(10)=Iresize(row+6,col-3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(9)=Iresize(row+7,col-4);%%��row-1�У���������
yy(8)=Iresize(row+8,col-4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(7)=Iresize(row+9,col-5);%%��row-1�У���������
yy(6)=Iresize(row+10,col-5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(5)=Iresize(row+11,col-6);%%��row-1�У���������
yy(4)=Iresize(row+12,col-6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(3)=Iresize(row+13,col-7);%%��row-1�У���������
yy(2)=Iresize(row+14,col-7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(1)=Iresize(row+15,col-8);%%%%���һ������Ϊ����������һ���棬���ԳɶԳ���

y63=[yy,y];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x45,y63);legend('63.5��');
%% eighth, draw the profile in -63.5��
x45=1:31;
y=zeros(1,16);
yy=zeros(1,15);
y(1)=Iresize(row,col);%%��row�У���������
y(2)=Iresize(row+1,col);
y(3)=Iresize(row+2,col+1);%%��row-1�У���������
y(4)=Iresize(row+3,col+1);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(5)=Iresize(row+4,col+2);%%��row-1�У���������
y(6)=Iresize(row+5,col+2);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(7)=Iresize(row+6,col+3);%%��row-1�У���������
y(8)=Iresize(row+7,col+3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(9)=Iresize(row+8,col+4);%%��row-1�У���������
y(10)=Iresize(row+9,col+4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(11)=Iresize(row+10,col+5);%%��row-1�У���������
y(12)=Iresize(row+11,col+5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(13)=Iresize(row+12,col+6);%%��row-1�У���������
y(14)=Iresize(row+13,col+6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
y(15)=Iresize(row+14,col+7);%%��row-1�У���������
y(16)=Iresize(row+15,col+7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
%%%%%%%%%��ʼ��һ�룬���²��֣�����15������,��ʱ��Ҫ����
yy(15)=Iresize(row-1,col-1);%%��row�У���������
yy(14)=Iresize(row-2,col-1);
yy(13)=Iresize(row-3,col-2);%%��row-1�У���������
yy(12)=Iresize(row-4,col-2);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(11)=Iresize(row-5,col-3);%%��row-1�У���������
yy(10)=Iresize(row-6,col-3);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(9)=Iresize(row-7,col-4);%%��row-1�У���������
yy(8)=Iresize(row-8,col-4);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(7)=Iresize(row-9,col-5);%%��row-1�У���������
yy(6)=Iresize(row-10,col-5);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(5)=Iresize(row-11,col-6);%%��row-1�У���������
yy(4)=Iresize(row-12,col-6);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(3)=Iresize(row-13,col-7);%%��row-1�У���������
yy(2)=Iresize(row-14,col-7);%%%%��һֱ�ڸ��£�ֻ���У����µ�����һ������
yy(1)=Iresize(row-15,col-8);%%%%���һ������Ϊ����������һ���棬���ԳɶԳ���

yp63=[yy,y];%%%���⼸��y���긳ֵ��һ������yyy
% figure,plot(x45,yp63);legend('-63.5��');
%% ������ݱ���
degrees=[0,90,45,135,26.5,-26.5,63.5,-63.5];
P=[y0;y90;y45;yp45;y26;yp26;y63;yp63];

%% ��������ƽ�����ó������ݲ�������ԭʼ���ݣ�
% locss=[];
% for ii=1:8
%     P1=P(ii,:);
%     [pks,locs,widths,proms]=findpeaks(P1);%%�����Լ��
%     if length(pks)>=6%%���������6�����������ƽ�������ó�������ȡ��ԭ�ȵ�����
%         Pnew=smooth(P1,5);
%         P(ii,:)=Pnew(:);
%     end
%     locss=[locss,locs];%%����һ��locs������
% end
% % 
% % %% ��Ҫ�����ﷵ���������꣬�����ĸ���ֵ�����������õģ����ݷ����У�locs�г��ִ������ģ����䶨λ���շ�
% % locss1=unique(locss);
% % c=zeros(size(locss1));
% % for e=1:length(locss1)
% %     c(e)=length(find(locss(:)==locss1(e)));
% % end
% % [maxloc,idx]=max(c(:));%%����������
% % centeridx=locss1(idx);

        

