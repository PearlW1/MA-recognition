function normal = normalization(x,kind)
%输入：
%x:样本数据，每行为1个样本，每列为一类特征（属性）
% kind ：1 or 2 表示第一类或第二类规范化。默认归一化到[-1,1]

%输出：
%normal：归一化后的数据，按照公式：Xnorm=(Xorig-Xmin)./(Xmax-Xmin)
if nargin < 2
    kind = 2;%kind = 1 or 2 表示第一类或第二类规范化
end
[m,n]  = size(x);%%m个样本，n个特征
normal = zeros(m,n);
%% normalize the data x to [0,1]
if kind == 1
    for i = 1:n%%对列进行归一化
        ma = max( x(:,i) );
        mi = min( x(:,i) );
        normal(:,i) = ( x(:,i)-mi )./( ma-mi );
    end
end
%% normalize the data x to [-1,1]公式：Xnorm=(Xorig-Xmean)./var
if kind == 2
    for i = 1:n
        mea = mean( x(:,i) );
        va = var( x(:,i) );%%方差
        normal(:,i) = ( x(:,i)-mea )/va;
    end
end



