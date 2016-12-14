function loc = geteye_and_mouth(eyemap, mouthmap)
[n,m] = size(eyemap);
loc = zeros(n,m);
threshold_eye = 220;
threshold_mouth = 510000;
for k = 1:n
    for q = 1:m
        if (eyemap(k,q) > threshold_eye)
            loc(k,q) = eyemap(k,q);
        end;
        if (mouthmap(k,q) > threshold_mouth && loc(k,q) == 0)
            loc(k,q) = mouthmap(k,q);
        end;
    end;
end;
end
