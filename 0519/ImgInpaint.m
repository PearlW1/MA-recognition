clc
clear all
% read img
imgnum=10;%%ͼ��Ĵ���
nm=strcat('D:\wzz\ROC_db\ROCtraining\image',num2str(imgnum),'_training.jpg');
I=imread(nm);
Igreen = I(:,:,2);
[m,n]=size(Igreen);
mask=Igreen<30;%% ��ȡ��Ĥ�����ø�ʴ���͵ķ���ȥ����Щ�ӵ㣬Ҫһ���ɾ�����Ĥ��
se=strel('disk',2);
mask1=imdilate(mask,se);
mask2=imerode(mask1,se);
mask3=~mask2;
mask4=imdilate(mask3,se);
mask5=imerode(mask4,se);%%���յĴ�������Ĥͼ��FOV�ǰ�ɫ�������Ǻ�ɫ
imshow(mask5,[]);
%% CSP������ȡ֮ǰ�Ĵ���
Ienh= adapthisteq(Igreen,'clipLimit',0.03,'Distribution','rayleigh');%%������Ҫ��uint8, uint16, int16, single, or double������double�ĺ����У�ԭʼ����ʱunit
Iinv=255-Ienh;%%%%��ɫͨ��ȡ��
f = fspecial('gaussian',[11 11],1.0);%%h = fspecial('gaussian', hsize, sigma)
Ismooth = imfilter(Iinv,f,'same');%%%%%��˹ƽ�������߿���conv2,nlfilter,�ܹ��õ����ƻ�����Ч��
% imtool(Ismooth,[]);
Ibg=medfilt2(Ismooth,[25 25]);%%%����ͼ��Ļ�ȡ
% imshow(Ibg,[]); imtool(Ibg,[]);
%% ����Χ�������ص�ƽ��ֵ��Ϊ��չ������ֵ���ȣ�ѡȡ��25��25����С�����о�ֵ���㣬
%% �Ա�֤���ܸ��ŵ���ѡ����б𣬲�ѡ������С�������ص�ԭ�򣺴���̫С�������������Ȳ��죬�γɷ�ֵ������ʶ��
a2=round(mean2(Ismooth)); %�ڶ��ַ������ú���mean2���ܾ�ֵ
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
             IL(i,j)=Ismooth(i,j);%% FOV �����Ǵ��ڵ�
         end
     end
 end
 imshow(IL,[]);
 %% ��һ�н���ͼ���޲�
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