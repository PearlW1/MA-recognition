function [Fea]=feature_profile(b,c,P,centeridx)
%FEATURE_PROFILE Computes the peak properties, called feature.
%input:
%       b:increase ramp�ĺ�������������һ�����顣
%       c:decrease ramp�ĺ�������������һ�����顣
%       P:����������ߵ�ֵ������ֵ����һ�����顣
%output:
%       �����Ӧ��������ֵ
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ٽ���һ�����жϸ�ramp�ǲ��������ģ�û���趨����С��max_gap��������Ҫ��������
%%%%%%��ʼ��������������������������������������������һ��profile������ֵ
% centeridx=16;%%���ֵ��λ�ã���������
%% ���������ֵ���״��û�����»���û�����£���ô�����Ŀ϶��Ͳ���MA�����Դ�ʱ���Ժ��ԣ�������Ӧ������Ϊ0��Ӧ���Ǻ���İɣ���Ϊû�����㣩
Bnum = length(b);%%�ҳ�b����ĳ���
Cnum = length(c);%%�ҳ�c����ĳ��� %%%12 26���� ��ʱc=0����Ϊ����min_diff_gap�����cû�������㣬��ֵ��c=0��Ĭ��Ϊ
if Bnum==1
    Fea=zeros(1,9);
else
    if Cnum==1
        Fea=zeros(1,9);
    else
        Wpeak = c(Cnum)-b(1);%% ����һ����ײ���
        Wtop = c(1)-b(Bnum); %%%���������嶥�˿�
        Hinc=P(b(Bnum))-P(b(1));%%��������������߶�
        Hdec=P(c(1))-P(c(Cnum));%%�����ģ��½���߶�
        Sinc=Hinc/((b(Bnum)-b(1))+eps);%%�����壬����б��
        Sdec=Hdec/((c(Cnum)-c(1))+eps);%%���������½�б��
        if P(b(1))>P(c(Cnum))%%�����ߣ���߶�
            Hpeak=P(centeridx)-(c(Cnum)-centeridx)/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(c(Cnum));
        elseif P(b(1))<P(c(Cnum))
            Hpeak=P(centeridx)-(centeridx-b(1))/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(b(1));%%���մ˹�ʽ��������ȷ
        else
            Hpeak=Hinc;
        end
         Fea=[];Fea(1)=Wpeak;Fea(2)=Wtop;Fea(3)=Hinc;Fea(4)=Hdec;Fea(5)=Sinc;Fea(6)=Sdec;Fea(7)=Hpeak;
        %%%%%%%%%%%%%%%%%%%%%%%%%1227 �¼���������������Ϊ����peak������
         [pks,locs,widths,proms] = findpeaks(P)
        Fea(8)=max(widths(:));%%�����ˣ��������
        Fea(9)=max(proms(:));%%�����ţ����͹���Ը߶�
        fprintf('%f\n', Fea);
    end
end




% % % % % center=16;%%���ֵ��λ�ã���������
% % % % % %% ���������ֵ���״��û�����»���û�����£���ô�����Ŀ϶��Ͳ���MA�����Դ�ʱ���Ժ��ԣ�������Ӧ������Ϊ0��Ӧ���Ǻ���İɣ���Ϊû�����㣩
% % % % % Bnum = length(b);%%�ҳ�b����ĳ���
% % % % % Cnum = length(c);%%�ҳ�c����ĳ���
% % % % % if Bnum==0
% % % % %     Fea=zeros(1,7);
% % % % % else
% % % % %     if Cnum==0
% % % % %         Fea=zeros(1,7);
% % % % %     else
% % % % % %% ����һ�� peak width=dec_e-inc_s
% % % % % Wpeak = c(Cnum)-b(1);
% % % % % %% ��������top width=dec_s-inc_e
% % % % % Wtop = c(1)-b(Bnum); %%%��ֵ15����û�д���min_diff,������ȥ
% % % % % %% ��������increase ramp height Hinc=P[inc_e]-P[inc_s]
% % % % % if isempty(b)
% % % % %     Hinc=0;
% % % % % else
% % % % %     Hinc=P(b(Bnum))-P(b(1));
% % % % % end
% % % % % %% �����ġ�decrease ramp height Hdec=P[dec_s]-P[dec_e]
% % % % % if isempty(c)
% % % % %     Hdec=0;
% % % % % else
% % % % %     Hdec=P(c(1))-P(c(Cnum));
% % % % % end
% % % % % %% �����塢increase ramp slope Sinc=Hinc/��inc_e-inc_s��
% % % % % Sinc=Hinc/(b(Bnum)-b(1));
% % % % % %% ��������decrease ramp slope Sdec=Hdec/(dec_e-dec_s)
% % % % % Sdec=Hdec/(c(Cnum)-c(1));
% % % % % %% �����ߡ�peak height  Hpeak=P[center]-(P[dec_e]-P[inc_s])/Wpeak*(center-inc_s)+P[inc_s]
% % % % % %Hpeak=P(center)-abs(P(c(Cnum))-P(b(1)))/Wpeak*(center-b(1))+P(b(1));
% % % % % %%%%���1��P[inc_s]>P[dec_e]
% % % % % if P(b(1))>P(c(Cnum))
% % % % %     Hpeak=P(center)-(c(Cnum)-center)/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(c(Cnum));
% % % % % elseif P(b(1))<P(c(Cnum))
% % % % % %%%%���2��P[inc_s]>P[dec_e]
% % % % %     Hpeak=P(center)-(center-b(1))/Wpeak*abs(P(c(Cnum))-P(b(1)))-P(b(1));%%���մ˹�ʽ��������ȷ
% % % % % else
% % % % % %%%%���3��P[inc_s]=P[dec_e]
% % % % %     Hpeak=Hinc;
% % % % % end
% % % % % 
% % % % % %% ������Щproperty��Fea��
% % % % % %Fea�е�˳��rhights set(inc dec),rslopes set(inc dec),Twidths set(top width),Pwidths set(peal width),Pheights set(peak height) 
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

