function normal = normalization(x,kind)
%���룺
%x:�������ݣ�ÿ��Ϊ1��������ÿ��Ϊһ�����������ԣ�
% kind ��1 or 2 ��ʾ��һ���ڶ���淶����Ĭ�Ϲ�һ����[-1,1]

%�����
%normal����һ��������ݣ����չ�ʽ��Xnorm=(Xorig-Xmin)./(Xmax-Xmin)
if nargin < 2
    kind = 2;%kind = 1 or 2 ��ʾ��һ���ڶ���淶��
end
[m,n]  = size(x);%%m��������n������
normal = zeros(m,n);
%% normalize the data x to [0,1]
if kind == 1
    for i = 1:n%%���н��й�һ��
        ma = max( x(:,i) );
        mi = min( x(:,i) );
        normal(:,i) = ( x(:,i)-mi )./( ma-mi );
    end
end
%% normalize the data x to [-1,1]��ʽ��Xnorm=(Xorig-Xmean)./var
if kind == 2
    for i = 1:n
        mea = mean( x(:,i) );
        va = var( x(:,i) );%%����
        normal(:,i) = ( x(:,i)-mea )/va;
    end
end



