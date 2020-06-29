function [b1,c1,centeridx]=min_diff_height_gap(P)
%MIN_DIFF_HEIGHT_GAP Computes the properties of P which is the intensity of
%cross-sectional profile.
%input:
%       P:横截面轮廓的亮度，1*31的向量,而不是整个矩阵8*31
%output：
%       b1:满足min_diff_height_gap的increasing ramp的坐标索引
%       c1:满足min_diff_height_gap的decreasing ramp的坐标索引
%
% P = P(2,:);%%P代表亮度值数组
% P = P(1,:);
%%% 在最大值确定上，需要进行更改，存在：轻微MA遭到血管干扰或者遗弃，没能将其按照MA的检测方式进行，
%%% 方法：选择最大，次最大，（次次最大）并且找出其索引，比较哪个最值的前后有inc和dec，则将其视为最终的maxdx。
%%% 若存在两个最值，并且都有inc和dec，则比较其b和c的长度，较长的获胜吧，小的算是干扰，其他的就归结于  误判吧
% [Valmax,maxdx]=max(P(:));%%Valmax：返回P中最大值，maxdx：返回最大值索引
% %%% 找次最优方法：找到最大的以后，把最大的值*-1，这样肯定就不是最大了
% P1=P;
% P1(maxdx)=Valmax-100;
% [Valsub,subdx]=max(P1);
%%下面这四句代码，针对于MA非常明显，并且没有MA聚集的情况，好用；但是有的MA聚集在一起，这样的话，较多的峰值，不知道哪个才是真正的峰，这或许是一个待解决的问题，这个貌似解决不了了

%% 2017 1 8 如果无峰值检测，则返回，计算下一个候选街。
[pks,locs,widths,proms] = findpeaks(P,'MinPeakProminence',2)%%pks:峰们的亮度值，locs:峰尖们的横坐标索引，widths:峰们的腰宽度，pros:凸出的程度，峰高度。
[wvalmax,locsidx]=max(widths(:))
[pvalmax,pidx]=max(proms(:))
centeridx=locs(pidx)%%%返回每一个方向下的峰值中心。

% % [pks,locs,widths,proms] = findpeaks(PP,'MinPeakProminence',2)%%pks:峰们的亮度值，locs:峰尖们的横坐标索引，widths:峰们的腰宽度，pros:凸出的程度，峰高度。
% % if isempty(locs)%%isempty(A) returns logical 1 (true) if A is an empty array
% %       return;
% % else
% %       [wvalmax,locsidx]=max(widths(:))
% %       [pvalmax,pidx]=max(proms(:))
% %       centeridx=locs(pidx)%%%返回每一个方向下的峰值中心。
% % end

min_diff=2;
min_height=3;
max_gap=3;
b=zeros();%%存放increase ramp
c=zeros();%%存放decrease ramp
jj=0;
jjj=0;
Inc=zeros();
%%先判段一下峰值会不会是两个值，很有可能会是两个像素
if P(centeridx)-P(centeridx-1)==0
    centeridx1=centeridx-1;
else
    centeridx1=centeridx;
end
for i=centeridx1:-1:2%%%找 increase ramp
    jj=jj+1;
    if P(i)-P(i-1)>0 
        Inc(jj)=P(i-1);%%不能保存最大值P(maxdx),这个是要作为Wtop计算的
        b(jj)=i-1;%%b保存索引
    else
        break;%%直接跳出循环，别的ramp就不考虑
    end
end
b1=b(end:-1:1);

Dec=zeros();
h=0;
if P(centeridx)-P(centeridx+1)==0
    centeridx2=centeridx+1;
else
    centeridx2=centeridx;
end
for j=centeridx2:1:30%%%找出decrease ramp
    h=h+1;
    if P(j)-P(j+1)>0
        Dec(h)=P(j+1);%%此时的Dec是从小到大的顺序，接下来无需倒序
        c(h)=j;%%此时的c是从小到大的顺序，接下来无需倒序
    else
        break;
    end
end
c1=c;





% % % % [pks,locs,widths,proms] = findpeaks(P);%%pks:峰们的亮度值，locs:峰尖们的横坐标索引，widths:峰们的腰宽度，pros:凸出的程度，峰高度。
% % % % [wvalmax,locsidx]=max(widths(:));
% % % % [pvalmax,pidx]=max(proms(:));
% % % % centeridx=locs(locsidx);%%%返回每一个方向下的峰值中心。
% % % % 
% % % % min_diff=2;
% % % % min_height=3;
% % % % max_gap=3;
% % % % b=zeros();%%存放increase ramp
% % % % c=zeros();%%存放decrease ramp
% % % % jj=0;
% % % % jjj=0;
% % % % Inc=zeros();
% % % % for i=centeridx:-1:2%%%找 increase ramp
% % % %     jj=jj+1;
% % % %     if P(i)-P(i-1)>0 
% % % %         Inc(jj)=P(i-1);%%不能保存最大值P(maxdx),这个是要作为Wtop计算的
% % % %         b(jj)=i-1;%%b保存索引
% % % %     else
% % % %         break;%%直接跳出循环，别的ramp就不考虑
% % % %     end
% % % % end
% % % % b1=b(end:-1:1);
% % % % % % %%%%%%%%%%%%%%%线判断是否满足min_diff,之后再进行gap的判断，如果gap满足，则将去掉的部分补上
% % % % % % b1=zeros();jjjj=1;Inc1=zeros();
% % % % % % Inc1(1)=Inc(1);
% % % % % % b1(1)=b(1);
% % % % % % b_end=b(end);%%%避免有的最大值，出现在最左边，尚未进行两步计算，就会出现索引为0的情况 ，这时，程序报错。
% % % % % % if b(end)==1
% % % % % %     b_end=b(end-1);
% % % % % % end
% % % % % % 
% % % % % % if length(b)>2  %%%%避免非MA的property提取过程中，  
% % % % % %     for ii=b(1):-1:b_end%%%找 increase ramp
% % % % % %         jjjj=jjjj+1;
% % % % % %            if P(ii)-P(ii-1)>=min_diff 
% % % % % %            Inc1(jjjj)=P(ii-1);%%不能保存最大值P(maxdx),这个是要作为Wtop计算的
% % % % % %             b1(jjjj)=ii-1;%%b保存索引
% % % % % %            end
% % % % % %     end
% % % % % % % b=b(end:-1:1);%%调整顺序，从ramp的 increase 左下进行计算
% % % % % % % b1=b1(end:-1:1);
% % % % % %     Inc2=zeros();b2=zeros();
% % % % % %     if length(b)-length(b1)>=2 %%%如果筛选后的b1<b，则将保留在Inc1的最后一个数，另一部分保留在Inc2中
% % % % % %         b=b(end:-1:1);%%调整顺序，从ramp的 increase 左下进行计算
% % % % % %         b1=b1(end:-1:1);
% % % % % %         for iii=b(1):1:b1(1)-1 %%从b中出去b1里面元素，进行遍历
% % % % % %             jjj=jjj+1;
% % % % % %             if abs(P(iii)-P(iii+1))>=min_diff
% % % % % %                 Inc2(jjj)=P(iii);
% % % % % %                 b2(jjj)=iii;
% % % % % %             end
% % % % % %         end%%%得出increase ramp的另一段，随后判断，夹层前后
% % % % % %         if b1(1)-b2(end)<=max_gap
% % % % % %            b1=b(end:-1:1);%%这里尚需要进一步改进
% % % % % %            b2=b(end:-1:1);
% % % % % %         end
% % % % % %     else
% % % % % %           b1=b(end:-1:1);%%这里尚需要进一步改进
% % % % % %            b2=b(end:-1:1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%b1 b2是最终的输出结果，因为之前的b是倒序的，所以此处需要改变顺序。。
% % % % % %     end %%12/21以上应该是正确的，逻辑上没有错误，我认为
% % % % % % else
% % % % % %     b1=b(end:-1:1); %%%%%加上这个else语句就是为了解决非MA中，b的个数会小于2，这样没法进行diff计算
% % % % % % end 
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % Dec=zeros();
% % % % h=0;
% % % % for j=centeridx:1:30%%%找出decrease ramp
% % % %     h=h+1;
% % % %     if P(j)-P(j+1)>0
% % % %         Dec(h)=P(j+1);%%此时的Dec是从小到大的顺序，接下来无需倒序
% % % %         c(h)=j;%%此时的c是从小到大的顺序，接下来无需倒序
% % % %     else
% % % %         break;
% % % %     end
% % % % end
% % % % c1=c;
% % %%%%%%%%%%%%%%%线判断是否满足min_diff,之后再进行gap的判断，如果gap满足，则将去掉的部分补上
% % c1=zeros();hh=1;Dec1=zeros();
% % Dec1(1)=Dec(1);
% % c1(1)=c(1);
% % 
% % c_end=c(end);%%%避免有的最大值，出现在最左边，尚未进行两步计算，就会出现索引为0的情况 ，这时，程序报错。
% % if c(end)==31
% %     c_end=c(end-1);
% % end
% % if length(c)>2  %%%%避免非MA的property提取过程中，  
% %     for e=c(1):1:c_end%%%找 increase ramp
% %         hh=hh+1;
% %         if P(e)-P(e+1)>=min_diff 
% %             Dec1(hh)=P(e+1);%%不能保存最大值P(maxdx),这个是要作为Wtop计算的,从Inc1（2）开始循环保存下一个
% %             c1(hh)=e+1;%%b保存索引,从b（2）开始循环保存索引
% %         end
% %     end
% %     Dec2=zeros();c2=zeros();hhh=1;
% %     Dec2(1)=P(c1(end)+1);%%%将下一段的第一个赋值给dec2（1），
% %     c2(1)=c1(end)+1;
% %     % if length(c1)<length(c) %%%如果筛选后的b1<b，则将保留在Dec1的最后一个数，另一部分保留在Dec2中
% %         if length(c)-length(c1)>2%%大于2，我至少可以计算一次diff 和gap
% %             for ee=c1(end)+1:1:c(end)-1
% %                 hhh=hhh+1;
% %                 if P(ee)-P(ee+1)>=min_diff
% %                     Dec2(hhh)=P(ee+1);
% %                     c2(hhh)=ee+1;
% %                 end
% %             end
% %             if c2(1)-c1(end)<=max_gap
% %                 c1=c;
% %                 c2=c;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%c1c2是最终的输出结果
% %             end   
% %         else%%%就是说：length（c）-length（c1）<=2的时候，直接将其算为峰值的一部分。
% %             c1=c;%%%这是最终的赋值，将所有的中间值，都变成c 
% %             c2=c;
% %         end
% % else
% %             c1=c;
% % end
%%%以上是 2016 12 26 晚上十一点半，修改的终极版本 
    
    
    
% [Valmax,maxdx]=max(P(:));%%Valmax：返回P中最大值，maxdx：返回最大值索引
% min_diff=2;
% min_height=3;
% max_gap=3;
% b=zeros();%%存放increase ramp
% c=zeros();%%存放decrease ramp
% jj=0;
% jjj=0;
% for i=maxdx:-1:2%%%找 increase ramp
%     jj=jj+1;
%     if P(i)-P(i-1)>0 
%         Inc(jj)=P(i-1);%%不能保存最大值P(maxdx),这个是要作为Wtop计算的
%         b(jj)=i-1;%%b保存索引
%     else
%         break;%%直接跳出循环，别的ramp就不考虑
%     end
% end
% %%%%%%%%%%%%%%%线判断是否满足min_diff,之后再进行gap的判断，如果gap满足，则将去掉的部分补上
% b1=zeros();jjjj=1;
% Inc1(1)=Inc(1);
% b1(1)=b(1);
% for ii=b(1):-1:b(end)%%%找 increase ramp
%     jjjj=jjjj+1;
%     if P(ii)-P(ii-1)>=min_diff 
%         Inc1(jjjj)=P(ii-1);%%不能保存最大值P(maxdx),这个是要作为Wtop计算的
%         b1(jjjj)=ii-1;%%b保存索引
%     end
% end
% % b=b(end:-1:1);%%调整顺序，从ramp的 increase 左下进行计算
% % b1=b1(end:-1:1);
% Inc2=zeros();b2=zeros();
% if length(b)-length(b1)>=2 %%%如果筛选后的b1<b，则将保留在Inc1的最后一个数，另一部分保留在Inc2中
%     b=b(end:-1:1);%%调整顺序，从ramp的 increase 左下进行计算
%     b1=b1(end:-1:1);
%     for iii=b(1):1:b1(1)-1 %%从b中出去b1里面元素，进行遍历
%         jjj=jjj+1;
%         if abs(P(iii)-P(iii+1))>=min_diff
%             Inc2(jjj)=P(iii);
%             b2(jjj)=iii;
%         end
%     end%%%得出increase ramp的另一段，随后判断，夹层前后
%     if b1(1)-b2(end)<=max_gap
%        b1=b(end:-1:1);%%这里尚需要进一步改进
%        b2=b(end:-1:1);
%     end
% else
%        b1=b(end:-1:1);%%这里尚需要进一步改进
%        b2=b(end:-1:1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%b1 b2是最终的输出结果，因为之前的b是倒序的，所以此处需要改变顺序。。
% end %%12/21以上应该是正确的，逻辑上没有错误，我认为
%    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dec=zeros();
% h=0;
% for j=maxdx:1:31%%%找出decrease ramp
%     h=h+1;
%     if P(j)-P(j+1)>0
%         Dec(h)=P(j+1);%%此时的Dec是从小到大的顺序，接下来无需倒序
%         c(h)=j;%%此时的c是从小到大的顺序，接下来无需倒序
%     else
%         break;
%     end
% end
% %%%%%%%%%%%%%%%线判断是否满足min_diff,之后再进行gap的判断，如果gap满足，则将去掉的部分补上
% c1=zeros();hh=1;Dec1=zeros();
% Dec1(1)=Dec(1);
% c1(1)=c(1);
% for e=c(1):1:c(end)%%%找 increase ramp
%     hh=hh+1;
%     if P(e)-P(e+1)>=min_diff 
%         Dec1(hh)=P(e+1);%%不能保存最大值P(maxdx),这个是要作为Wtop计算的,从Inc1（2）开始循环保存下一个
%         c1(hh)=e+1;%%b保存索引,从b（2）开始循环保存索引
%     end
% end
% 
% Dec2=zeros();c2=zeros();hhh=1;
% Dec2(1)=P(c1(end)+1);%%%将下一段的第一个赋值给dec2（1），
% c2(1)=c1(end)+1;
% % if length(c1)<length(c) %%%如果筛选后的b1<b，则将保留在Dec1的最后一个数，另一部分保留在Dec2中
%     if length(c)-length(c1)>2%%大于2，我至少可以计算一次diff 和gap
%         for ee=c1(end)+1:1:c(end)-1
%             hhh=hhh+1;
%             if P(ee)-P(ee+1)>=min_diff
%                 Dec2(hhh)=P(ee+1);
%                 c2(hhh)=ee+1;
%             end
%         end
%        if c2(1)-c1(end)<=max_gap
%        c1=c;
%        c2=c;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%c1c2是最终的输出结果
%        end   
%     else%%%就是说：length（c）-length（c1）<=2的时候，直接将其算为峰值的一部分。
%         c1=c;%%%这是最终的赋值，将所有的中间值，都变成c 
%         c2=c;
%     end






















% min_diff=2;
% min_height=3;
% max_gap=3;
% R=zeros();%%ramp亮度值
% Inc=zeros();%%increase 亮度值
% Dec=zeros();%%decrease亮度值
% j=0;
% a=zeros();
% for i=2:31 %%遍历像素值，比较大小，找ramp
%     %% 先找哪里是ramp                       
%     if abs(P(i)-P(i-1))>=min_diff  %相邻亮度差大于min_diff的保存到R数组中
%         j=j+1;
%         R(j)=P(i);%%是ramp的保存 11个数
%         a(j)=i;%%%将R中相应坐标的索引保存到a数组中
% %         b=i;%%%保存循环中前一个i的值，
%     end 
% end
% b=zeros();
% c=zeros();
% jj=0;
% jjj=0;
% for ii=2:length(a) %%遍历R数组像素值，比较大小，上升和下降
%     %% 找出 increase 和decrease
%     if R(ii)-R(ii-1)>=0
%         jj=jj+1;
%         Inc(jj)=R(ii);
%         b(jj)=a(ii);%%保存R中留存到Inc数组的索引，序号
%     else 
%         jjj=jjj+1;
%         Dec(jjj)=R(ii);
%         c(jjj)=a(ii);%%保存R中留存到Dec数组的索引，序号能回到原来的profile中
%     end
% end
% 
% %% 限制连续ramp，使得同一方向上的ramp里面不能超过最大间距max_gap,,,
% %%1:increase ramp,从大值向小值靠近 b=a(end:-1:1)
% B=zeros();u=0;
% B(1)=b(length(b));
% for t=length(b):-1:2
%         u=u+1;
%         B(u)=b(t);
%     if b(t)-b(t-1)<=max_gap
% %         u=u+1;
% %         B(u)=b(t);%%%如果没有break，还会自动筛选对比，此时结果：14 13 8 7，正常来说，8 7 就不应该存在了。。。
%     else          %%%加入break之后，一旦不满足<=max_gap,就会跳出整个循环。
%         break;%%%break与continue相似，也是经常与for while合用，但它不是继续执行下一个循环，而是退出循环体，继续执行循环体之外的程序。即终止循环！
%     end
% end
% B=B(end:-1:1);%%%此时B=13 14，按照正常顺序存在,随后特征程序里面的b换成B
% %%2:decrease ramp,从小值向大值靠近 
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
% b=B;
% c=C;
% % 2016/12/19%未进行去除不满足last and first 小于等于min_height这一要求
% 
% %% 首先判断一下gap，判断是否满足不小于min_height，如果不满足，则直接将坐标索引b，c置为0，在接下来的程序中，可以判断一下，如果b=0，c=0，则不进行接下来的计算了
% % bnum=length(B);
% % cnum=length(C);
% % if Inc(bnum)-Inc(1)<=min_height
% %     b=0;
% % else
% %     b=B;
% % end
% % if Dec(1)-Dec(cnum)<=min_height
% %     c=0;
% % else
% %     b=B;
% % end







% P = P(1,:);%%P代表亮度值数组
% min_diff=2;%%相邻亮度差大于min_diff
% min_height=3;%%上升或者下降的前后差，应该大于min_height 
% max_gap=3;%%一个ramp里面，连续的破，差不能超过max_gap
% R=zeros();%%ramp亮度值
% Inc=zeros();%%increase 亮度值
% Dec=zeros();%%decrease亮度值
% j=0;
% a=zeros();
% for i=2:31 %%遍历像素值，比较大小，找ramp
%     %% 先找哪里是ramp                       
%     if abs(P(i)-P(i-1))>=min_diff  %相邻亮度差大于min_diff的保存到R数组中
%         j=j+1;
%         R(j)=P(i);%%是ramp的保存 11个数
%         a(j)=i;%%%将R中相应坐标的索引保存到a数组中
% %         b=i;%%%保存循环中前一个i的值，
%     end 
% end
% b=zeros();
% c=zeros();
% jj=0;
% jjj=0;
% for ii=2:length(a) %%遍历R数组像素值，比较大小，上升和下降
%     %% 找出 increase 和decrease
%     if R(ii)-R(ii-1)>0
%         jj=jj+1;
%         Inc(jj)=R(ii);
%         b(jj)=a(ii);%%保存R中留存到Inc数组的索引，序号
%     else 
%         jjj=jjj+1;
%         Dec(jjj)=R(ii);
%         c(jjj)=a(ii);%%保存R中留存到Dec数组的索引，序号能回到原来的profile中
%     end
% end
% %% 判断是否满足不小于min_height，如果不满足，则直接将坐标索引b，c置为0，在接下来的程序中，可以判断一下，如果b=0，c=0，则不进行接下来的计算了
% if Inc(b(length(b)))-Inc(b(1))<=min_height
%     b=0;
% end
% if Dec((length(c)))-Dec(c(1))<=min_height
%     c=0;
% end



% %% 限制连续ramp，使得同一方向上的ramp里面不能超过最大间距max_gap,,,
% %%1:increase ramp,从大值向小值靠近 b=a(end:-1:1)
% B=zeros();u=0;
% B(1)=b(length(b));
% for t=length(b):-1:2
%     if b(t)-b(t-1)<=max_gap
%         u=u+1;
%         B(u)=b(t);%%%如果没有break，还会自动筛选对比，此时结果：14 13 8 7，正常来说，8 7 就不应该存在了。。。
%     else          %%%加入break之后，一旦不满足<=max_gap,就会跳出整个循环。
%         break;%%%break与continue相似，也是经常与for while合用，但它不是继续执行下一个循环，而是退出循环体，继续执行循环体之外的程序。即终止循环！
%     end
% end
% B=B(end:-1:1);%%%此时B=13 14，按照正常顺序存在,随后特征程序里面的b换成B
% %%2:decrease ramp,从小值向大值靠近 
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