% im_test: image
% num: the number of pixels in one cluster
function result = mysuperpixel(im_test, num)
addpath('ERS');
[n,m,~] = size(im_test);
grey_img = double(rgb2gray(im_test));
nC = floor(m*n/num);    % 1500 can be adjusted
segments = mex_ers(grey_img,nC);
edge=(segments~=segments(:,[1,1:m-1])) | (segments~=segments([1,1:n-1],:));
seg = ones(n, m);
seg( edge == 1) = 0;
seg = bwlabel(seg,4);   % regionprop may be better
count = max(max(seg));
im_test = double(im_test);
for k=1:count
temp_pos = find(seg == k);
me = [mean(im_test(temp_pos));
      mean(im_test(temp_pos+n*m));
      mean(im_test(temp_pos+n*m*2))];
im_test(temp_pos) = me(1);
im_test(temp_pos + n*m) = me(2);
im_test(temp_pos + n*m*2) = me(3);
end;
result = im_test;
end