function [F]=Intensity_fea(image,row,col)
% ���룺image��rgbͼ��
%     ������row��col::::ͼ�������к��У�������
%����� �˸�����
%****************Ԥ����************
Igreen=image(:,:,2);% Igreen = double(I(:,:,2));%%%��ɫͨ��
Ienh= adapthisteq(Igreen,'clipLimit',0.01,'Distribution','rayleigh');%%������Ҫ��uint8, uint16, int16, single, or double������double�ĺ����У�ԭʼ����ʱunit
Iinv=255-Ienh;%%%%��ɫͨ��ȡ��
f = fspecial('gaussian',[11 11],1.0);%%h = fspecial('gaussian', hsize, sigma)
Ismooth = imfilter(Iinv,f,'same');%%%%%��˹ƽ�������߿���conv2,nlfilter,�ܹ��õ����ƻ�����Ч��
%% 1 ȡ��ƽ���������,Խ��Խ��
F1 = Ismooth(row,col);
%% 2 rgb��ɻҶȺ�����ȣ�ԽСԽ�ã����������զ����
Igray = rgb2gray(image);
Igray = imfilter(Igray,f,'same');
F2 = Igray(row,col);
%% 3 ��ɫͨ��������ֵ��ԽСԽ�ã����������զ����
Igreen = imfilter(image(:,:,2),f,'same');
F3=Igreen(row,col);
%% 4 S ͨ���£������Ϊ���� ��Խ��Խ�ã��ܲ�ʮ����ʮ��������
HSV = rgb2hsv(image);%%��Sͨ����Ϊ��ͨ���е�һ��ͨ��
S=HSV(:,:,2);%figure,imshow(S,[]);title('S');%%MA�Ƚ����ԣ�ֱ�Ӿ�����ɫͼ��
Su=im2uint8(S);
Su = imfilter(Su,f,'same');
F4 = Su(row,col);
%% 5 Vͨ���£�����ֵ��������
V=HSV(:,:,3);%figure,imshow(V,[]);title('V');%%MA�Ƚ����ԣ����ǰ�ɫͼ��,��Vͨ����Ϊһ��ͨ��
Vu=im2uint8(V);
Vu = imfilter(Vu,f,'same');
F5 = Vu(row,col);
%% 6 Yͨ���£�����ֵ��MA���ܴ��Խ��Խ��
Y=255-image(:,:,3);
Y = imfilter(Y,f,'same');
F6 = Y(row,col);
%% 7 ycbcrͨ���� yͨ���£�����ֵ��ԽСԽ�ã�����Ҳ���ǲ����ԣ�������Ҷ�ͼ��
ycbcr = rgb2ycbcr(image);
y=ycbcr(:,:,1);
y = imfilter(y,f,'same');
F7 = y(row,col);
%% MSCF ��˹���ϵ�����������Ϊ���ԣ�MA����ֵ�ܴ��ܳ�����ͨ���ص㣬һ���=100����
% [COE]=MSCF(image);
% F8 = COE(row,col);%% �ܷ����Ҫ�������������Ȩ�ء�
% F=[F1,F2,F3,F4,F5,F6,F7,F8];
% F=double(F);
F=[F1,F2,F3,F4,F5,F6,F7];
F=double(F);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Ԥ�������+++++++++++++++++++++++++++++++++
% x_in=385;y_in=330;%%���������ڷ�% % % x_in=120;y_in=210;
% row=330;
% col=385;
% row=210;
% col=120;
% row=226; col=428;% xueguan fenzhi 
% row=269; col=126;% Ѫ�ܽ���
