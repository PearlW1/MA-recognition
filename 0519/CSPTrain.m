
clc;
clear all
tic
%% 1. 预处理阶段++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
number=13;
input=strcat('D:\wzz\AWZZ\ROCtraining_RGB\image',num2str(number),'_training.jpg');
I = imread(input);
Igreen=I(:,:,2);% Igreen = double(I(:,:,2));%%%绿色通道
imwrite(Igreen,'Igreen.png');
Ienh= adapthisteq(Igreen,'clipLimit',0.03,'Distribution','rayleigh');%%输入需要是uint8, uint16, int16, single, or double，不过double的好像不行，原始数据时unit
imwrite(Ienh,'Ienh.png');
Iinv=255-Ienh;%%%%绿色通道取反
imwrite(Iinv,'Iinv.png');
f = fspecial('gaussian',[11 11],1.0);%%h = fspecial('gaussian', hsize, sigma)
Ismooth = imfilter(Iinv,f,'same');%%%%%高斯平滑，或者可用conv2,nlfilter,能够得到类似滑窗的效果
% Iresize = imresize(Ismooth,[540 540],'bilinear');
figure,imshow(Ismooth,[]);
imwrite(Ismooth,'Ismooth.png');
% imtool(Ismooth,[]);
%% 2. Local Maximum Region Extraction---lmr.c
%可以考虑在大于X小于Y的区间内，不进行轮廓线的计算，这样减少计算量，避免没用的浪费
%此处给出大MA的坐标（385，330）
% X0=385;Y0=330;figure,imshow(Igreen,[]);hold on;plot(X0,Y0,'*');
[m,n]=size(Igreen);
x_in=260;y_in=38;
% x_in=385;y_in=330;%%坐标正常摆放
% x_in=120;y_in=210;
% x_in=428;y_in=226;%血管分支
% x_in=126;y_in=269;%交叉血管
% patch=Ismooth(y_in-15:y_in+15,x_in-15:x_in+15);
% imshow(patch,[]);
% saveas(gcf,'血管交叉1.png');
% saveas(gcf,'血管交叉1.bmp');
% save('bigMApatch.png','patch');

% x_in=120;y_in=210;
%% 3. Cross-Sectional Scanning Peak Detection 
%常量定义
disp('start cross-sectional scanning peak ')
ARRAY_WIDTH= 3;
MAX_LMR=6000;
MIN_DIFF= 2;%最小高度差
MIN_HEIGHT= 3;%最小ramp的起始值跟终止值差
MAX_GAP= 3;%最大两个连续ramp之间间隔
THRESH_TOP= 1;
SLOPE_MAX= 500;%控制斜率
ELEMENT= 31;% cross file的元素个数
NUM_PRO =30;% 6 degree cross profile//180°，6°间隔，有30个
I =11;% for test
%数组定义
p=zeros(NUM_PRO,ELEMENT);%一个点，各个方向轮廓线亮度值，每一行代表一个方向
count_pro = 0; count_ele = 0;
%像素索引
max=zeros(1,NUM_PRO);max_d=zeros(1,NUM_PRO);
inc_s=zeros(1,NUM_PRO);inc_e=zeros(1,NUM_PRO); dec_s=zeros(1,NUM_PRO); dec_e=zeros(1,NUM_PRO); center=zeros(1,NUM_PRO);%//pixel indexes 
gap=zeros(NUM_PRO,ELEMENT); inc=zeros(NUM_PRO,ELEMENT);
count_gap=zeros(1,NUM_PRO); count_inc=zeros(1,NUM_PRO); stop=zeros(1,NUM_PRO);
gap_dec=zeros(NUM_PRO,ELEMENT); dec=zeros(NUM_PRO,ELEMENT); 
count_gapd=zeros(1,NUM_PRO); count_dec=zeros(1,NUM_PRO);
xoffset=zeros(NUM_PRO,ELEMENT);
yoffset=zeros(NUM_PRO,ELEMENT);
%变量定义
array_in = 0;label_value = 1;
%y_in = 0; x_in = 0;
xx = 0; yy = 0;%count element
theta = 0;k = 0;% i = 0; j = 0;
idx = 0;time = 0;
array=zeros(MAX_LMR,ARRAY_WIDTH);
%start read input csv file
%input y,x axises, and corresponding label value

%判断输入的一点是否再图像之内，再距离边界15个像素之外的忽略，不进行轮廓线采集
% if (y_in >= im.yhi - 15 || y_in <= im.ylo + 15 || x_in >= im.xhi - 15 ||x_in <= im.xlo + 15)
%     continue;%
% end
%% profile scanning
for k=1:1:NUM_PRO%获取scanning索引坐标
    theta = 6 * k;%angle
    if (theta<45 || theta >135)
		i = 1;
        for xx = -15:1: 15 %count element in angle
			yy = round(xx*tan(theta / 180.0*3.1415926));%取整
			xoffset(k,i) = xx;
			yoffset(k,i) = yy;
            i=i+1;
        end
    else
		i =1 ;
        for yy=-15:1:15
			xx = round(yy / tan(theta / 180.0*3.1415926));
			xoffset(k,i) = xx;
			yoffset(k,i) = yy;
            i=i+1;
        end
    end
end
%% Get their pixel values
for k = 1:1:NUM_PRO
    for i = 1:1:ELEMENT
		xxx = xoffset(k,i);
		yyy = yoffset(k,i);
		p(k,i) = Ismooth(y_in + yyy,x_in + xxx);
    end
end
% % %% plot轮廓线,标注第几个profile，并且去掉坐标轴
% % for kk = 1:1:NUM_PRO
% %     g=1:31;
% %     h=figure;
% %     plot(g,p(kk,:));
% % %     plotname=strcat(num2str(kk),'th profile');
% % %     axis off;
% % %     legend(plotname);
% % %     saveas(h,plotname,'png');
% % end
% % % 
% % for kk = 1:1:NUM_PRO
% %     g=1:31;
% %     hold on;
% %     plot(g,p(kk,:));
% %     axis off;
% % end

for i = 1:1:NUM_PRO
    for j = 1:1:ELEMENT
		gap(i,j) = 0;%上升ramp带有gap的像素值
		inc(i,j) = 0;%上升ramp的像素值
		gap_dec(i,j) = 0;%下降带有gap的像素值
		dec(i,j) = 0;%下降ramp的像素值
    end
end

for i = 1:1:NUM_PRO
	max(i) = 0;
	max_d(i) = 0;
	inc_s(i) = floor(ELEMENT / 2);%开始坐标索引
	inc_e(i) = floor(ELEMENT / 2);%floor(ELEMENT / 2);%结束坐标索引
	dec_s(i) = floor(ELEMENT / 2 + 1);%floor(ELEMENT / 2 + 1);
	dec_e(i) = ELEMENT ;%ELEMENT - 1;
	center(i) =0;% floor(ELEMENT / 2);%中点，
	stop(i)= 0;
	count_gap(i) = 1;%原先是0，因为坐标不能为0，此处改为1较为合理
	count_inc(i) = 0;
	count_gapd(i) = 1;%原先是0，因为坐标不能为0，此处改为1较为合理
	count_dec(i) = 0;	
end
for count_pro = 1:1:NUM_PRO%此处得出的max 就是center peak
    for count_ele =1:1:ELEMENT%peak detection
        if (p(count_pro,count_ele)>max(count_pro))%max(count_pro):找一个profile中的最大值，此处很容易受到噪声影响
			max(count_pro) = p(count_pro,count_ele);%record peak value
			inc_e(count_pro) = count_ele;%record peak index, also the end index of rising ramp
        end
    end
end
%find starting point of decreasing ramp
for count_pro = 1:1:NUM_PRO
    for count_ele = inc_e(count_pro):1:ELEMENT
        if (max(count_pro) - p(count_pro,count_ele)>THRESH_TOP)
			max_d(count_pro) = p(count_pro,count_ele-1);%%max_d存放满足
			dec_s(count_pro) = count_ele-1;%dec_s存放满足条件的索引
            break;
        end
    end
end
%calculate elements in gap[]   (increasing)
for count_pro =1:1:NUM_PRO
    for j = inc_e(count_pro):-1:2
        if (p(count_pro,j) - p(count_pro,j - 1) >= MIN_DIFF)
			gap(count_pro,count_gap(count_pro)) = j;
			count_gap(count_pro)=count_gap(count_pro)+1;
        else
            if (p(count_pro,j + 1) - p(count_pro,j) >= MIN_DIFF)
				gap(count_pro,count_gap(count_pro)) = j;
				count_gap(count_pro)=count_gap(count_pro)+1;
            end
        end
    end
end
if (p(count_pro,2) - p(count_pro,1) >= MIN_DIFF)
	gap(count_pro,count_gap(count_pro)+1) = 0;
end
%calculate elements in gap_dec[]  (decreasing)
for count_pro = 1:1:NUM_PRO
    for j = dec_s(count_pro):1:ELEMENT - 2
        if (p(count_pro,j) - p(count_pro,j + 1) >= MIN_DIFF)
			gap_dec(count_pro,count_gapd(count_pro)) = j;%index
			count_gapd(count_pro)=count_gapd(count_pro)+1;
        else
            if (p(count_pro,j - 1) - p(count_pro,j) >= MIN_DIFF)
				gap_dec(count_pro,count_gapd(count_pro)) = j;%坐标索引
				count_gapd(count_pro)=count_gapd(count_pro)+1;%%坐标个数
            end
        end
    end
end
if (p(count_pro,ELEMENT - 1) - p(count_pro,ELEMENT) >= MIN_DIFF)
	gap_dec(count_pro,count_gapd(count_pro)+1) = ELEMENT - 1;
end
%store increasing ramp's indexes in inc[]
for count_pro = 1:1:NUM_PRO
    for j = 1:1:count_gap(count_pro)%%此处有错，将初始化元素0作为索引值进行计算，，想办法去掉，去掉初始化，length(count_gap(count_pro))
            if (gap(count_pro,j) - gap(count_pro,j + 1)>MAX_GAP)
                if (gap(count_pro,j - 1) - gap(count_pro,j) <= MAX_GAP)
                    inc(count_pro,j) = gap(count_pro,j);
                    count_inc(count_pro)=count_inc(count_pro)+1;
                break;
                end
            else
                inc(count_pro,j) = gap(count_pro,j);
                count_inc(count_pro)=count_inc(count_pro)+1;
                if (gap(count_pro,j+1)==0)%%避免最后索引为0时，仍然计算，排除初始化影响
                    break;
                end
            end
    end
end
for count_pro = 1:1:NUM_PRO
	inc_s(count_pro) = inc(count_pro,count_inc(count_pro));%开始于哪里
end
%store decreasing ramp's indexes in dec[]
for count_pro =1:1:NUM_PRO
    for j = 1:1:count_gapd(count_pro)
        if (abs(gap_dec(count_pro,j) - gap_dec(count_pro,j + 1))>MAX_GAP)
            if (abs(gap_dec(count_pro,j - 1) - gap_dec(count_pro,j)) <= MAX_GAP)
				dec(count_pro,j) = gap_dec(count_pro,j);
				count_dec(count_pro)=count_dec(count_pro)+1;
				break;
            end
        else
			dec(count_pro,j) = gap_dec(count_pro,j);
			count_dec(count_pro)=count_dec(count_pro)+1;
        end
    end
end

if (gap_dec(count_pro,count_gapd(count_pro) - 1) - gap_dec(count_pro,count_gapd(count_pro) - 2)>MAX_GAP)
    
end
for count_pro = 1:1:NUM_PRO
    if (dec(count_pro,count_dec(count_pro) - 1) ~= 0)
        dec_e(count_pro) = dec(count_pro,count_dec(count_pro)-1);
    end
end

%% calculate profile property
w_peak=zeros(1,NUM_PRO); w_top(1:NUM_PRO)=1; h_inc=zeros(1,NUM_PRO); h_dec=zeros(1,NUM_PRO); h_peak=zeros(1,NUM_PRO);%profile properties
s_inc=zeros(1,NUM_PRO); s_dec=zeros(1,NUM_PRO); %increasing and decreasing slope
%if only exists rising ramp, deceasing index starts and ends at last index 
for count_pro = 1:1:NUM_PRO
    if (inc_e(count_pro) == ELEMENT)
		dec_s(count_pro) = ELEMENT;
		dec_e(count_pro) = ELEMENT;
    end
end
%if only exists descending ramp, increasing index starts and ends at first index
for count_pro = 1:1:NUM_PRO
    if (dec_s(count_pro) == 1)
		inc_s(count_pro) = 1;
		inc_e(count_pro) = 1;
    end
end
%calculate formula
for count_pro = 1:1:NUM_PRO
    if (dec_s(count_pro)~= inc_e(count_pro))
		w_top(count_pro) = dec_s(count_pro) - inc_e(count_pro);
    else
		w_top(count_pro) = 1;
    end
	w_peak(count_pro) = dec_e(count_pro) - inc_s(count_pro);
	h_inc(count_pro) = p(count_pro,inc_e(count_pro)) - p(count_pro,inc_s(count_pro));
	h_dec(count_pro) = p(count_pro,dec_s(count_pro)) - p(count_pro,dec_e(count_pro));
	center(count_pro) = floor((inc_e(count_pro) + dec_s(count_pro)) / 2);%%作为坐标索引，不能为小数
end
%calculate increasing slope (rise&descend / only descending ramp)
for count_pro =1:1:NUM_PRO
    if (inc_s(count_pro) ~= inc_e(count_pro))
		s_inc(count_pro) = h_inc(count_pro) / (inc_e(count_pro) - inc_s(count_pro));
    else
		s_inc(count_pro) = SLOPE_MAX;
    end
end
%calculate decreasing slope (rise&descend / only rising ramp)
for count_pro = 1:1:NUM_PRO
    if (dec_s(count_pro)~= dec_e(count_pro))
		s_dec(count_pro) = h_dec(count_pro) / (dec_e(count_pro) - dec_s(count_pro));
    else
		s_dec(count_pro) = SLOPE_MAX;%decreasing slope is also considered as positive
    end
end
%calculate peak height
for count_pro = 1:1:NUM_PRO
    if (p(count_pro,inc_s(count_pro))>p(count_pro,dec_e(count_pro)))
		h_peak(count_pro) = p(count_pro,center(count_pro)) - p(count_pro,inc_s(count_pro)) + ((p(count_pro,inc_s(count_pro)) - p(count_pro,dec_e(count_pro)))*(center(count_pro) - inc_s(count_pro)) / w_peak(count_pro));
    else
        if (p(inc_s(count_pro))<p(dec_e(count_pro)))
		h_peak(count_pro) = p(count_pro,center(count_pro)) - p(count_pro,dec_e(count_pro)) + ((p(count_pro,dec_e(count_pro)) - p(count_pro,inc_s(count_pro)))*(dec_e(count_pro) - center(count_pro)) / w_peak(count_pro));
        else
		h_peak(count_pro) = p(count_pro,center(count_pro)) - p(count_pro,inc_s(count_pro));
        end
    end
end
for count_pro = 1:1:NUM_PRO
    if ((w_top(count_pro)==0) && (w_peak(count_pro)==0) && (h_inc(count_pro)==0) && (h_dec(count_pro)==0))
		s_inc(count_pro) = 0;
		s_dec(count_pro) = ELEMENT;
		h_peak(count_pro) = 0;
		center(count_pro) = ELEMENT / 2;
    end
end
disp('start calculating properties...')
%initial properties value
twidths=zeros(1,NUM_PRO); %top width
pwidths=zeros(1,NUM_PRO);%peak width
rheight_inc=zeros(1,NUM_PRO);%inc ramp height
rheight_dec=zeros(1,NUM_PRO);%dec ramp heigh
pheights=zeros(1,NUM_PRO);%peak height
rslopes_inc=zeros(1,NUM_PRO);%inc ramp slope
rslopes_dec=zeros(1,NUM_PRO);%dec ramp slope
% mpwidths=double ;%峰的腰宽
promimence=zeros(1,NUM_PRO);%峰的凸显性高度,类似峰高
ct = 1;
for count_pro = 1:1:NUM_PRO
    if (count_inc(count_pro) && count_dec(count_pro))
		twidths(ct) = w_top(count_pro);
		pwidths(ct) = w_peak(count_pro);
		rheight_inc(ct) = h_inc(count_pro);
		rheight_dec(ct) = h_dec(count_pro);
		rslopes_inc(ct) = s_inc(count_pro);
		rslopes_dec(ct) = s_dec(count_pro);
		pheights(ct) = h_peak(count_pro);
        [pks,locs,widths,proms] = findpeaks(p(count_pro,:))
        findpeaks(p(count_pro,:),'Annotate','extents')
        maxwidths=widths(1);
        for g=1:1:length(widths)%小数不能进行max计算
            if maxwidths<widths(g)      
                maxwidths=widths(g);%%特征八，峰的腰宽
            end
        end
        widths(ct)=maxwidths; 
        maxprom=proms(1);
        for g=1:1:length(proms)%小数不能进行max计算
            if maxprom<proms(g)      
                maxprom=proms(g);%%特征八，峰的腰宽
            end
        end
        promimence(ct)=maxprom;%%特征九，峰的凸显性高度
		ct=ct+1;
    end
end
%calculate profile property statistics
%% 1twidths  % sdtwidths=std(twidths(:)); mtwidths=mean(twidths(:))
sdtwidths=std(twidths(:)); 
mtwidths=mean(twidths(:));
%% 2pwidths sdpwidths=std(pwidths(:)) ;mpwidths=mean(pwidths(:));
sdpwidths=std(pwidths(:));
mpwidths=mean(pwidths(:));
%% 3rslopes_inc  sdrslopes=std(rslopes(:)) ;mrslopes=mean(rslopes(:))
sdrslope_inc=std(rslopes_inc(:));
mrslope_inc=mean(rslopes_inc(:));
%% 4rslopes_dec  sdrslopes=std(rslopes(:)) ;mrslopes=mean(rslopes(:))
sdrslope_dec=std(rslopes_dec(:));
mrslope_dec=mean(rslopes_dec(:));
%% 5rheight_inc   sdrheights=std(rheights(:)) ;mrheights=mean(rheights(:));
sdrheight_inc=std(rheight_inc(:));
mrheight_inc=mean(rheight_inc(:));
cvrheight_inc = sdrheight_inc / mrheight_inc;
%% 6rheight_dec   sdrheights=std(rheights(:)) ;mrheights=mean(rheights(:));
sdrheight_dec=std(rheight_dec(:));
mrheight_dec=mean(rheight_dec(:));
cvrheight_dec = sdrheight_dec / mrheight_dec;
%% 7pheights % sdpheights=std(pheights(:)) ;mpheights=mean(pheights(:));
sdpheights=std(pheights(:));
mpheights=mean(pheights(:));
cvpheights = sdpheights / mpheights;
%% 8mpwidths 
sdmpwidths=std(widths(:));
mmpwidths=mean(widths(:));
%% 9promimence
sdpromimence=std(promimence(:));
mpromimence=mean(promimence(:));
cvpromimence = sdpromimence / mpromimence;

MINpheights = pheights(1);
for i = 1:1:(ct-1)%% find min pheights
    if (pheights(i)<MINpheights)
		MINpheights = pheights(i);
    end
end
%% score
score = (MINpheights*(mrslope_inc+mrslope_dec)/2) / (1 + sdpwidths + sdtwidths + (sdrslope_inc+sdrslope_dec)/2 + (sdrheight_inc+sdrheight_dec) + sdpheights); %%   12.2750
count_out=1;%%总共12个属性数据
if (mpwidths>=0 && mtwidths>=0 && mpheights>=0 && cvpheights>=0 && cvpheights<Inf)
	Out(count_out).y_out = y_in;
	Out(count_out).x_out = x_in;
	Out(count_out).mpwidths = mpwidths;
	Out(count_out).sdpwidths = sdpwidths;
	Out(count_out).mtwidths = mtwidths;
	Out(count_out).sdtwidths = sdtwidths;
	Out(count_out).sdrslope_inc = sdrslope_inc;
    Out(count_out).sdrslope_dec = sdrslope_dec;
	Out(count_out).cvrheight_inc = cvrheight_inc;
    Out(count_out).cvrheight_dec = cvrheight_dec;
    Out(count_out).cvpheights = cvpheights;
    Out(count_out).sdmpwidths = sdmpwidths;
	Out(count_out).mmpwidths = mmpwidths;
    Out(count_out).cvpromimence = cvpromimence;
	Out(count_out).score = score;
	Out(count_out).label = label_value;
	count_out=count_out+1;
end
F=[mpwidths,sdpwidths,mtwidths,sdtwidths,sdrslope_inc,sdrslope_dec,cvrheight_inc,cvrheight_dec,cvpheights,sdmpwidths,mmpwidths,cvpromimence,score];

toc
disp('the end.. get score..luck')
load handel
sound(y,Fs)












