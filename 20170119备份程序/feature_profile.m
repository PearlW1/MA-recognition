function [Fea]=feature_profile(b,c,P,centeridx)
%FEATURE_PROFILE Computes the peak properties, called feature.
%input:
%       b:increase ramp的横坐标索引，是一个数组。
%       c:decrease ramp的横坐标索引，是一个数组。
%       P:横截面轮廓线的值，亮度值，是一个数组。
%output:
%       输出的应该是特征值
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%这里少进行一步：判断该ramp是不是连续的，没有设定必须小于max_gap，如有需要，随后进行
%%%%%%开始计算特征。。。。。。。。。。。。。。。。。。一个profile的特征值
% centeridx=16;%%最大值的位置，就是中心
%% 如果超级奇怪的形状（没有下坡或者没有上坡，那么这样的肯定就不是MA，所以此时可以忽略，将其相应特征置为0，应该是合理的吧，因为没法计算）
Bnum = length(b);%%找出b数组的长度
Cnum = length(c);%%找出c数组的长度 %%%12 26晚上 此时c=0，因为我在min_diff_gap中如果c没进行运算，则赋值给c=0，默认为
if Bnum==1
    Fea=zeros(1,9);
else
    if Cnum==1
        Fea=zeros(1,9);
    else
        Wpeak = c(Cnum)-b(1);%% 特征一，峰底部宽
        Wtop = c(1)-b(Bnum); %%%特征二，峰顶端宽
        Hinc=P(b(Bnum))-P(b(1));%%特征三，上升峰高度
        Hdec=P(c(1))-P(c(Cnum));%%特征四，下降峰高度
        Sinc=Hinc/((b(Bnum)-b(1))+eps);%%特征五，上升斜率
        Sdec=Hdec/((c(Cnum)-c(1))+eps);%%特征六，下降斜率
        if P(b(1))>P(c(Cnum))%%特征七，峰高度
            Hpeak=P(centeridx)-(c(Cnum)-centeridx)/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(c(Cnum));
        elseif P(b(1))<P(c(Cnum))
            Hpeak=P(centeridx)-(centeridx-b(1))/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(b(1));%%按照此公式计算结果正确
        else
            Hpeak=Hinc;
        end
         Fea=[];Fea(1)=Wpeak;Fea(2)=Wtop;Fea(3)=Hinc;Fea(4)=Hdec;Fea(5)=Sinc;Fea(6)=Sdec;Fea(7)=Hpeak;
        %%%%%%%%%%%%%%%%%%%%%%%%%1227 新加入两个特征，作为衡量peak的属性
         [pks,locs,widths,proms] = findpeaks(P)
        Fea(8)=max(widths(:));%%特征八，峰的腰宽
        Fea(9)=max(proms(:));%%特征九，峰的凸显性高度
        fprintf('%f\n', Fea);
    end
end




% % % % % center=16;%%最大值的位置，就是中心
% % % % % %% 如果超级奇怪的形状（没有下坡或者没有上坡，那么这样的肯定就不是MA，所以此时可以忽略，将其相应特征置为0，应该是合理的吧，因为没法计算）
% % % % % Bnum = length(b);%%找出b数组的长度
% % % % % Cnum = length(c);%%找出c数组的长度
% % % % % if Bnum==0
% % % % %     Fea=zeros(1,7);
% % % % % else
% % % % %     if Cnum==0
% % % % %         Fea=zeros(1,7);
% % % % %     else
% % % % % %% 特征一、 peak width=dec_e-inc_s
% % % % % Wpeak = c(Cnum)-b(1);
% % % % % %% 特征二、top width=dec_s-inc_e
% % % % % Wtop = c(1)-b(Bnum); %%%峰值15处，没有大于min_diff,所以舍去
% % % % % %% 特征三、increase ramp height Hinc=P[inc_e]-P[inc_s]
% % % % % if isempty(b)
% % % % %     Hinc=0;
% % % % % else
% % % % %     Hinc=P(b(Bnum))-P(b(1));
% % % % % end
% % % % % %% 特征四、decrease ramp height Hdec=P[dec_s]-P[dec_e]
% % % % % if isempty(c)
% % % % %     Hdec=0;
% % % % % else
% % % % %     Hdec=P(c(1))-P(c(Cnum));
% % % % % end
% % % % % %% 特征五、increase ramp slope Sinc=Hinc/（inc_e-inc_s）
% % % % % Sinc=Hinc/(b(Bnum)-b(1));
% % % % % %% 特征六、decrease ramp slope Sdec=Hdec/(dec_e-dec_s)
% % % % % Sdec=Hdec/(c(Cnum)-c(1));
% % % % % %% 特征七、peak height  Hpeak=P[center]-(P[dec_e]-P[inc_s])/Wpeak*(center-inc_s)+P[inc_s]
% % % % % %Hpeak=P(center)-abs(P(c(Cnum))-P(b(1)))/Wpeak*(center-b(1))+P(b(1));
% % % % % %%%%情况1：P[inc_s]>P[dec_e]
% % % % % if P(b(1))>P(c(Cnum))
% % % % %     Hpeak=P(center)-(c(Cnum)-center)/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(c(Cnum));
% % % % % elseif P(b(1))<P(c(Cnum))
% % % % % %%%%情况2：P[inc_s]>P[dec_e]
% % % % %     Hpeak=P(center)-(center-b(1))/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(b(1));%%按照此公式计算结果正确
% % % % % else
% % % % % %%%%情况3：P[inc_s]=P[dec_e]
% % % % %     Hpeak=Hinc;
% % % % % end
% % % % % 
% % % % % %% 保存这些property于Fea中
% % % % % %Fea中的顺序：rhights set(inc dec),rslopes set(inc dec),Twidths set(top width),Pwidths set(peal width),Pheights set(peak height) 
% % % % % % Fea=zeros();
% % % % % Fea=[];
% % % % % Fea(1)=Wpeak;
% % % % % Fea(2)=Wtop;
% % % % % Fea(3)=Hinc;
% % % % % Fea(4)=Hdec;
% % % % % Fea(5)=Sinc;
% % % % % Fea(6)=Sdec;
% % % % % Fea(7)=Hpeak;
% % % % % % save('Fea.mat','Fea');
% % % % % fprintf('%f\n', Fea);
% % % % %     end
% % % % % end
% p = rand(1,10);
% q = ones(10);
% save('pqfile.mat','p','q')%%Create and save two variables, p and q, to a file called pqfile.mat.

