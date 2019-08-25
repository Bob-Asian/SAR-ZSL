%% NMS:non maximum suppression
function [bbox_new,scores_new] = nms_cfar(bbox,scores,type,threshold)
% threshold: IOU��ֵ
% type��IOU��ֵ�Ķ�������
% ����Ϊ�գ���ֱ�ӷ���
% type = 'Max';
% threshold = 0.5;
if isempty(bbox)
    bbox_new = [];
    scores_new = [];
    labels_new = [];
    return;
end

% ����ȡ�����ϽǺ����½������Լ��������÷�(���Ŷ�)
x1 = bbox(:,1);
y1 = bbox(:,2);
x2 = x1+bbox(:,3);
y2 = y1+bbox(:,4);
s = scores(:,1);

% ����ÿһ��������
area = (x2-x1+1) .* (y2-y1+1);

%���÷���������
[~, I] = sort(s); %valsΪbbox�÷֣�IΪ��bboxλ��

%��ʼ��
pick = s*0;
counter = 1;

% ѭ��ֱ�����п������
while ~isempty(I)
    last = length(I); %��ǰʣ��������
    i = I(last);%ѡ�����һ�������÷���ߵĿ�
    pick(counter) = i;
    counter = counter + 1;
    
    %�����ཻ���
    xx1 = max(x1(i), x1(I(1:last-1)));
    yy1 = max(y1(i), y1(I(1:last-1)));
    xx2 = min(x2(i), x2(I(1:last-1)));
    yy2 = min(y2(i), y2(I(1:last-1)));
    w = max(0.0, xx2-xx1+1);
    h = max(0.0, yy2-yy1+1);
    inter = w.*h;
    
    %��ͬ�����µ�IOU
    if strcmp(type,'Min')
        %�ص��������С������ı�ֵ
        o = inter ./ min(area(i),area(I(1:last-1)));
    else
        %����/����
        o = inter ./ (area(i) + area(I(1:last-1)) - inter);
    end
    
    %���������ص����С����ֵ�Ŀ������´δ���
    I = I(find(o<=threshold));
end
pick = pick(1:(counter-1));
[len,~] = size(pick);
for j = 1:len
    bbox_new(j,:) = bbox(pick(j,1),:);
    scores_new(j,1) = scores(pick(j,1),1);
end
% IMG = insertShape(img,'rectangle',bbox_new);
% imshow(IMG)
end