function [b1,c1,centeridx]=min_diff_height_gap(P)
%MIN_DIFF_HEIGHT_GAP Computes the properties of P which is the intensity of
%cross-sectional profile.
%input:
%       P:��������������ȣ�1*31������,��������������8*31
%output��
%       b1:����min_diff_height_gap��increasing ramp����������
%       c1:����min_diff_height_gap��decreasing ramp����������
%
% P = P(2,:);%%P��������ֵ����
% P = P(1,:);
%%% �����ֵȷ���ϣ���Ҫ���и��ģ����ڣ���΢MA�⵽Ѫ�ܸ��Ż���������û�ܽ��䰴��MA�ļ�ⷽʽ���У�
%%% ������ѡ����󣬴���󣬣��δ���󣩲����ҳ����������Ƚ��ĸ���ֵ��ǰ����inc��dec��������Ϊ���յ�maxdx��
%%% ������������ֵ�����Ҷ���inc��dec����Ƚ���b��c�ĳ��ȣ��ϳ��Ļ�ʤ�ɣ�С�����Ǹ��ţ������ľ͹����  ���а�
% [Valmax,maxdx]=max(P(:));%%Valmax������P�����ֵ��maxdx���������ֵ����
% %%% �Ҵ����ŷ������ҵ������Ժ󣬰�����ֵ*-1�������϶��Ͳ��������
% P1=P;
% P1(maxdx)=Valmax-100;
% [Valsub,subdx]=max(P1);
%%�������ľ���룬�����MA�ǳ����ԣ�����û��MA�ۼ�����������ã������е�MA�ۼ���һ�������Ļ����϶�ķ�ֵ����֪���ĸ����������ķ壬�������һ������������⣬���ò�ƽ��������

%% 2017 1 8 ����޷�ֵ��⣬�򷵻أ�������һ����ѡ�֡�
[pks,locs,widths,proms] = findpeaks(P,'MinPeakProminence',2)%%pks:���ǵ�����ֵ��locs:����ǵĺ�����������widths:���ǵ�����ȣ�pros:͹���ĳ̶ȣ���߶ȡ�
[wvalmax,locsidx]=max(widths(:))
[pvalmax,pidx]=max(proms(:))
centeridx=locs(pidx)%%%����ÿһ�������µķ�ֵ���ġ�

% % [pks,locs,widths,proms] = findpeaks(PP,'MinPeakProminence',2)%%pks:���ǵ�����ֵ��locs:����ǵĺ�����������widths:���ǵ�����ȣ�pros:͹���ĳ̶ȣ���߶ȡ�
% % if isempty(locs)%%isempty(A) returns logical 1 (true) if A is an empty array
% %       return;
% % else
% %       [wvalmax,locsidx]=max(widths(:))
% %       [pvalmax,pidx]=max(proms(:))
% %       centeridx=locs(pidx)%%%����ÿһ�������µķ�ֵ���ġ�
% % end

min_diff=2;
min_height=3;
max_gap=3;
b=zeros();%%���increase ramp
c=zeros();%%���decrease ramp
jj=0;
jjj=0;
Inc=zeros();
%%���ж�һ�·�ֵ�᲻��������ֵ�����п��ܻ�����������
if P(centeridx)-P(centeridx-1)==0
    centeridx1=centeridx-1;
else
    centeridx1=centeridx;
end
for i=centeridx1:-1:2%%%�� increase ramp
    jj=jj+1;
    if P(i)-P(i-1)>0 
        Inc(jj)=P(i-1);%%���ܱ������ֵP(maxdx),�����Ҫ��ΪWtop�����
        b(jj)=i-1;%%b��������
    else
        break;%%ֱ������ѭ�������ramp�Ͳ�����
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
for j=centeridx2:1:30%%%�ҳ�decrease ramp
    h=h+1;
    if P(j)-P(j+1)>0
        Dec(h)=P(j+1);%%��ʱ��Dec�Ǵ�С�����˳�򣬽��������赹��
        c(h)=j;%%��ʱ��c�Ǵ�С�����˳�򣬽��������赹��
    else
        break;
    end
end
c1=c;





% % % % [pks,locs,widths,proms] = findpeaks(P);%%pks:���ǵ�����ֵ��locs:����ǵĺ�����������widths:���ǵ�����ȣ�pros:͹���ĳ̶ȣ���߶ȡ�
% % % % [wvalmax,locsidx]=max(widths(:));
% % % % [pvalmax,pidx]=max(proms(:));
% % % % centeridx=locs(locsidx);%%%����ÿһ�������µķ�ֵ���ġ�
% % % % 
% % % % min_diff=2;
% % % % min_height=3;
% % % % max_gap=3;
% % % % b=zeros();%%���increase ramp
% % % % c=zeros();%%���decrease ramp
% % % % jj=0;
% % % % jjj=0;
% % % % Inc=zeros();
% % % % for i=centeridx:-1:2%%%�� increase ramp
% % % %     jj=jj+1;
% % % %     if P(i)-P(i-1)>0 
% % % %         Inc(jj)=P(i-1);%%���ܱ������ֵP(maxdx),�����Ҫ��ΪWtop�����
% % % %         b(jj)=i-1;%%b��������
% % % %     else
% % % %         break;%%ֱ������ѭ�������ramp�Ͳ�����
% % % %     end
% % % % end
% % % % b1=b(end:-1:1);
% % % % % % %%%%%%%%%%%%%%%���ж��Ƿ�����min_diff,֮���ٽ���gap���жϣ����gap���㣬��ȥ���Ĳ��ֲ���
% % % % % % b1=zeros();jjjj=1;Inc1=zeros();
% % % % % % Inc1(1)=Inc(1);
% % % % % % b1(1)=b(1);
% % % % % % b_end=b(end);%%%�����е����ֵ������������ߣ���δ�����������㣬�ͻ��������Ϊ0����� ����ʱ�����򱨴�
% % % % % % if b(end)==1
% % % % % %     b_end=b(end-1);
% % % % % % end
% % % % % % 
% % % % % % if length(b)>2  %%%%�����MA��property��ȡ�����У�  
% % % % % %     for ii=b(1):-1:b_end%%%�� increase ramp
% % % % % %         jjjj=jjjj+1;
% % % % % %            if P(ii)-P(ii-1)>=min_diff 
% % % % % %            Inc1(jjjj)=P(ii-1);%%���ܱ������ֵP(maxdx),�����Ҫ��ΪWtop�����
% % % % % %             b1(jjjj)=ii-1;%%b��������
% % % % % %            end
% % % % % %     end
% % % % % % % b=b(end:-1:1);%%����˳�򣬴�ramp�� increase ���½��м���
% % % % % % % b1=b1(end:-1:1);
% % % % % %     Inc2=zeros();b2=zeros();
% % % % % %     if length(b)-length(b1)>=2 %%%���ɸѡ���b1<b���򽫱�����Inc1�����һ��������һ���ֱ�����Inc2��
% % % % % %         b=b(end:-1:1);%%����˳�򣬴�ramp�� increase ���½��м���
% % % % % %         b1=b1(end:-1:1);
% % % % % %         for iii=b(1):1:b1(1)-1 %%��b�г�ȥb1����Ԫ�أ����б���
% % % % % %             jjj=jjj+1;
% % % % % %             if abs(P(iii)-P(iii+1))>=min_diff
% % % % % %                 Inc2(jjj)=P(iii);
% % % % % %                 b2(jjj)=iii;
% % % % % %             end
% % % % % %         end%%%�ó�increase ramp����һ�Σ�����жϣ��в�ǰ��
% % % % % %         if b1(1)-b2(end)<=max_gap
% % % % % %            b1=b(end:-1:1);%%��������Ҫ��һ���Ľ�
% % % % % %            b2=b(end:-1:1);
% % % % % %         end
% % % % % %     else
% % % % % %           b1=b(end:-1:1);%%��������Ҫ��һ���Ľ�
% % % % % %            b2=b(end:-1:1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%b1 b2�����յ�����������Ϊ֮ǰ��b�ǵ���ģ����Դ˴���Ҫ�ı�˳�򡣡�
% % % % % %     end %%12/21����Ӧ������ȷ�ģ��߼���û�д�������Ϊ
% % % % % % else
% % % % % %     b1=b(end:-1:1); %%%%%�������else������Ϊ�˽����MA�У�b�ĸ�����С��2������û������diff����
% % % % % % end 
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % Dec=zeros();
% % % % h=0;
% % % % for j=centeridx:1:30%%%�ҳ�decrease ramp
% % % %     h=h+1;
% % % %     if P(j)-P(j+1)>0
% % % %         Dec(h)=P(j+1);%%��ʱ��Dec�Ǵ�С�����˳�򣬽��������赹��
% % % %         c(h)=j;%%��ʱ��c�Ǵ�С�����˳�򣬽��������赹��
% % % %     else
% % % %         break;
% % % %     end
% % % % end
% % % % c1=c;
% % %%%%%%%%%%%%%%%���ж��Ƿ�����min_diff,֮���ٽ���gap���жϣ����gap���㣬��ȥ���Ĳ��ֲ���
% % c1=zeros();hh=1;Dec1=zeros();
% % Dec1(1)=Dec(1);
% % c1(1)=c(1);
% % 
% % c_end=c(end);%%%�����е����ֵ������������ߣ���δ�����������㣬�ͻ��������Ϊ0����� ����ʱ�����򱨴�
% % if c(end)==31
% %     c_end=c(end-1);
% % end
% % if length(c)>2  %%%%�����MA��property��ȡ�����У�  
% %     for e=c(1):1:c_end%%%�� increase ramp
% %         hh=hh+1;
% %         if P(e)-P(e+1)>=min_diff 
% %             Dec1(hh)=P(e+1);%%���ܱ������ֵP(maxdx),�����Ҫ��ΪWtop�����,��Inc1��2����ʼѭ��������һ��
% %             c1(hh)=e+1;%%b��������,��b��2����ʼѭ����������
% %         end
% %     end
% %     Dec2=zeros();c2=zeros();hhh=1;
% %     Dec2(1)=P(c1(end)+1);%%%����һ�εĵ�һ����ֵ��dec2��1����
% %     c2(1)=c1(end)+1;
% %     % if length(c1)<length(c) %%%���ɸѡ���b1<b���򽫱�����Dec1�����һ��������һ���ֱ�����Dec2��
% %         if length(c)-length(c1)>2%%����2�������ٿ��Լ���һ��diff ��gap
% %             for ee=c1(end)+1:1:c(end)-1
% %                 hhh=hhh+1;
% %                 if P(ee)-P(ee+1)>=min_diff
% %                     Dec2(hhh)=P(ee+1);
% %                     c2(hhh)=ee+1;
% %                 end
% %             end
% %             if c2(1)-c1(end)<=max_gap
% %                 c1=c;
% %                 c2=c;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%c1c2�����յ�������
% %             end   
% %         else%%%����˵��length��c��-length��c1��<=2��ʱ��ֱ�ӽ�����Ϊ��ֵ��һ���֡�
% %             c1=c;%%%�������յĸ�ֵ�������е��м�ֵ�������c 
% %             c2=c;
% %         end
% % else
% %             c1=c;
% % end
%%%������ 2016 12 26 ����ʮһ��룬�޸ĵ��ռ��汾 
    
    
    
% [Valmax,maxdx]=max(P(:));%%Valmax������P�����ֵ��maxdx���������ֵ����
% min_diff=2;
% min_height=3;
% max_gap=3;
% b=zeros();%%���increase ramp
% c=zeros();%%���decrease ramp
% jj=0;
% jjj=0;
% for i=maxdx:-1:2%%%�� increase ramp
%     jj=jj+1;
%     if P(i)-P(i-1)>0 
%         Inc(jj)=P(i-1);%%���ܱ������ֵP(maxdx),�����Ҫ��ΪWtop�����
%         b(jj)=i-1;%%b��������
%     else
%         break;%%ֱ������ѭ�������ramp�Ͳ�����
%     end
% end
% %%%%%%%%%%%%%%%���ж��Ƿ�����min_diff,֮���ٽ���gap���жϣ����gap���㣬��ȥ���Ĳ��ֲ���
% b1=zeros();jjjj=1;
% Inc1(1)=Inc(1);
% b1(1)=b(1);
% for ii=b(1):-1:b(end)%%%�� increase ramp
%     jjjj=jjjj+1;
%     if P(ii)-P(ii-1)>=min_diff 
%         Inc1(jjjj)=P(ii-1);%%���ܱ������ֵP(maxdx),�����Ҫ��ΪWtop�����
%         b1(jjjj)=ii-1;%%b��������
%     end
% end
% % b=b(end:-1:1);%%����˳�򣬴�ramp�� increase ���½��м���
% % b1=b1(end:-1:1);
% Inc2=zeros();b2=zeros();
% if length(b)-length(b1)>=2 %%%���ɸѡ���b1<b���򽫱�����Inc1�����һ��������һ���ֱ�����Inc2��
%     b=b(end:-1:1);%%����˳�򣬴�ramp�� increase ���½��м���
%     b1=b1(end:-1:1);
%     for iii=b(1):1:b1(1)-1 %%��b�г�ȥb1����Ԫ�أ����б���
%         jjj=jjj+1;
%         if abs(P(iii)-P(iii+1))>=min_diff
%             Inc2(jjj)=P(iii);
%             b2(jjj)=iii;
%         end
%     end%%%�ó�increase ramp����һ�Σ�����жϣ��в�ǰ��
%     if b1(1)-b2(end)<=max_gap
%        b1=b(end:-1:1);%%��������Ҫ��һ���Ľ�
%        b2=b(end:-1:1);
%     end
% else
%        b1=b(end:-1:1);%%��������Ҫ��һ���Ľ�
%        b2=b(end:-1:1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%b1 b2�����յ�����������Ϊ֮ǰ��b�ǵ���ģ����Դ˴���Ҫ�ı�˳�򡣡�
% end %%12/21����Ӧ������ȷ�ģ��߼���û�д�������Ϊ
%    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dec=zeros();
% h=0;
% for j=maxdx:1:31%%%�ҳ�decrease ramp
%     h=h+1;
%     if P(j)-P(j+1)>0
%         Dec(h)=P(j+1);%%��ʱ��Dec�Ǵ�С�����˳�򣬽��������赹��
%         c(h)=j;%%��ʱ��c�Ǵ�С�����˳�򣬽��������赹��
%     else
%         break;
%     end
% end
% %%%%%%%%%%%%%%%���ж��Ƿ�����min_diff,֮���ٽ���gap���жϣ����gap���㣬��ȥ���Ĳ��ֲ���
% c1=zeros();hh=1;Dec1=zeros();
% Dec1(1)=Dec(1);
% c1(1)=c(1);
% for e=c(1):1:c(end)%%%�� increase ramp
%     hh=hh+1;
%     if P(e)-P(e+1)>=min_diff 
%         Dec1(hh)=P(e+1);%%���ܱ������ֵP(maxdx),�����Ҫ��ΪWtop�����,��Inc1��2����ʼѭ��������һ��
%         c1(hh)=e+1;%%b��������,��b��2����ʼѭ����������
%     end
% end
% 
% Dec2=zeros();c2=zeros();hhh=1;
% Dec2(1)=P(c1(end)+1);%%%����һ�εĵ�һ����ֵ��dec2��1����
% c2(1)=c1(end)+1;
% % if length(c1)<length(c) %%%���ɸѡ���b1<b���򽫱�����Dec1�����һ��������һ���ֱ�����Dec2��
%     if length(c)-length(c1)>2%%����2�������ٿ��Լ���һ��diff ��gap
%         for ee=c1(end)+1:1:c(end)-1
%             hhh=hhh+1;
%             if P(ee)-P(ee+1)>=min_diff
%                 Dec2(hhh)=P(ee+1);
%                 c2(hhh)=ee+1;
%             end
%         end
%        if c2(1)-c1(end)<=max_gap
%        c1=c;
%        c2=c;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%c1c2�����յ�������
%        end   
%     else%%%����˵��length��c��-length��c1��<=2��ʱ��ֱ�ӽ�����Ϊ��ֵ��һ���֡�
%         c1=c;%%%�������յĸ�ֵ�������е��м�ֵ�������c 
%         c2=c;
%     end






















% min_diff=2;
% min_height=3;
% max_gap=3;
% R=zeros();%%ramp����ֵ
% Inc=zeros();%%increase ����ֵ
% Dec=zeros();%%decrease����ֵ
% j=0;
% a=zeros();
% for i=2:31 %%��������ֵ���Ƚϴ�С����ramp
%     %% ����������ramp                       
%     if abs(P(i)-P(i-1))>=min_diff  %�������Ȳ����min_diff�ı��浽R������
%         j=j+1;
%         R(j)=P(i);%%��ramp�ı��� 11����
%         a(j)=i;%%%��R����Ӧ������������浽a������
% %         b=i;%%%����ѭ����ǰһ��i��ֵ��
%     end 
% end
% b=zeros();
% c=zeros();
% jj=0;
% jjj=0;
% for ii=2:length(a) %%����R��������ֵ���Ƚϴ�С���������½�
%     %% �ҳ� increase ��decrease
%     if R(ii)-R(ii-1)>=0
%         jj=jj+1;
%         Inc(jj)=R(ii);
%         b(jj)=a(ii);%%����R�����浽Inc��������������
%     else 
%         jjj=jjj+1;
%         Dec(jjj)=R(ii);
%         c(jjj)=a(ii);%%����R�����浽Dec���������������ܻص�ԭ����profile��
%     end
% end
% 
% %% ��������ramp��ʹ��ͬһ�����ϵ�ramp���治�ܳ��������max_gap,,,
% %%1:increase ramp,�Ӵ�ֵ��Сֵ���� b=a(end:-1:1)
% B=zeros();u=0;
% B(1)=b(length(b));
% for t=length(b):-1:2
%         u=u+1;
%         B(u)=b(t);
%     if b(t)-b(t-1)<=max_gap
% %         u=u+1;
% %         B(u)=b(t);%%%���û��break�������Զ�ɸѡ�Աȣ���ʱ�����14 13 8 7��������˵��8 7 �Ͳ�Ӧ�ô����ˡ�����
%     else          %%%����break֮��һ��������<=max_gap,�ͻ���������ѭ����
%         break;%%%break��continue���ƣ�Ҳ�Ǿ�����for while���ã��������Ǽ���ִ����һ��ѭ���������˳�ѭ���壬����ִ��ѭ����֮��ĳ��򡣼���ֹѭ����
%     end
% end
% B=B(end:-1:1);%%%��ʱB=13 14����������˳�����,����������������b����B
% %%2:decrease ramp,��Сֵ���ֵ���� 
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
% % 2016/12/19%δ����ȥ��������last and first С�ڵ���min_height��һҪ��
% 
% %% �����ж�һ��gap���ж��Ƿ����㲻С��min_height����������㣬��ֱ�ӽ���������b��c��Ϊ0���ڽ������ĳ����У������ж�һ�£����b=0��c=0���򲻽��н������ļ�����
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







% P = P(1,:);%%P��������ֵ����
% min_diff=2;%%�������Ȳ����min_diff
% min_height=3;%%���������½���ǰ��Ӧ�ô���min_height 
% max_gap=3;%%һ��ramp���棬�������ƣ���ܳ���max_gap
% R=zeros();%%ramp����ֵ
% Inc=zeros();%%increase ����ֵ
% Dec=zeros();%%decrease����ֵ
% j=0;
% a=zeros();
% for i=2:31 %%��������ֵ���Ƚϴ�С����ramp
%     %% ����������ramp                       
%     if abs(P(i)-P(i-1))>=min_diff  %�������Ȳ����min_diff�ı��浽R������
%         j=j+1;
%         R(j)=P(i);%%��ramp�ı��� 11����
%         a(j)=i;%%%��R����Ӧ������������浽a������
% %         b=i;%%%����ѭ����ǰһ��i��ֵ��
%     end 
% end
% b=zeros();
% c=zeros();
% jj=0;
% jjj=0;
% for ii=2:length(a) %%����R��������ֵ���Ƚϴ�С���������½�
%     %% �ҳ� increase ��decrease
%     if R(ii)-R(ii-1)>0
%         jj=jj+1;
%         Inc(jj)=R(ii);
%         b(jj)=a(ii);%%����R�����浽Inc��������������
%     else 
%         jjj=jjj+1;
%         Dec(jjj)=R(ii);
%         c(jjj)=a(ii);%%����R�����浽Dec���������������ܻص�ԭ����profile��
%     end
% end
% %% �ж��Ƿ����㲻С��min_height����������㣬��ֱ�ӽ���������b��c��Ϊ0���ڽ������ĳ����У������ж�һ�£����b=0��c=0���򲻽��н������ļ�����
% if Inc(b(length(b)))-Inc(b(1))<=min_height
%     b=0;
% end
% if Dec((length(c)))-Dec(c(1))<=min_height
%     c=0;
% end



% %% ��������ramp��ʹ��ͬһ�����ϵ�ramp���治�ܳ��������max_gap,,,
% %%1:increase ramp,�Ӵ�ֵ��Сֵ���� b=a(end:-1:1)
% B=zeros();u=0;
% B(1)=b(length(b));
% for t=length(b):-1:2
%     if b(t)-b(t-1)<=max_gap
%         u=u+1;
%         B(u)=b(t);%%%���û��break�������Զ�ɸѡ�Աȣ���ʱ�����14 13 8 7��������˵��8 7 �Ͳ�Ӧ�ô����ˡ�����
%     else          %%%����break֮��һ��������<=max_gap,�ͻ���������ѭ����
%         break;%%%break��continue���ƣ�Ҳ�Ǿ�����for while���ã��������Ǽ���ִ����һ��ѭ���������˳�ѭ���壬����ִ��ѭ����֮��ĳ��򡣼���ֹѭ����
%     end
% end
% B=B(end:-1:1);%%%��ʱB=13 14����������˳�����,����������������b����B
% %%2:decrease ramp,��Сֵ���ֵ���� 
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