function mask = mySkinMask(im_recover)
[n,m] = size(im_recover);
area = n*m;
face_area = size(find(im_recover == 1));
seg1=bwlabel(im_recover);
num_reg = max(max(seg1));
mask = zeros(n,m);
for k = 1:num_reg
[x, y] = find(seg1 == k);
xy = [x-mean(x),y-mean(y)]; % origin of the coordinate is the origin of the ellipse
[V, D] = eig(xy'*xy);
% calculate the newX and newY
newXY = (V.')*xy';     
newXY = newXY';     % newX = newXY(:,1); newY = newXY(:,2);
m11 = mean(abs(newXY(:,1))); m12 = mean(abs(newXY(:,2)));
%m21 = mean((newXY(:,1).*newXY(:,1)));
%m22 = mean((newXY(:,2).*newXY(:,2)));
a1 = (3*pi*m11)/4; %a2 = sqrt(4*m21);
b1 = (3*pi*m12)/4; %b2 = sqrt(4*m22);

same = 0;
temp_pos=[];
    if(a1 > b1)
        ratio = a1/b1;
    else
        ratio = b1/a1;
    end;
if (ratio <= 3 && pi*a1*b1 > area/500)
    for q=-floor(a1):ceil(a1)
        for w=-floor(b1):ceil(b1)
            temp = (q/a1)^2 + (w/b1)^2;
            if (temp < 1)
                newQW = [q;w];
                temp_pos = [temp_pos; [newQW(1),newQW(2)]];
                same = same +1;
            end;
        end;
    end;
    [cntt,~] = size(temp_pos);
    if (same > 0.6*face_area)
        pic_position = (V.')\temp_pos';
        meanXY = ones(cntt,2);
        meanXY(:,1)=mean(x);
        meanXY(:,2)=mean(y);
        pic_position = ceil(pic_position' + meanXY);
        idx = sub2ind(size(mask),pic_position(:,1),pic_position(:,2));
        mask(idx) = 255;
    end;
end;
end;
end