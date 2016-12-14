%=====================================================%
% FileName     [ getEyemap.m ]                        %
% Author       [ Cheng-Yen Yang (b03901086)]          %
% Instructor   [ Professor Jian-Jiun Ding ]           %
% Copyright    [ Copyleft(c), NTUEE , Taiwan ]        %
%=====================================================%


function eyemap = getEyemap(im_test, mask)
    im_test = imread('f.jpg');
    global Ts ;
    image(im_test) ;
    [n,m,~] = size(im_test);
    face = zeros(n,m,3);
    [row, col] = find(mask == 255);
    idx = sub2ind(size(mask),row, col);
    face(idx) = im_test(idx); 
    face(idx + n*m) = im_test(idx + n*m); 
    face(idx + 2*n*m) = im_test(idx + 2*n*m);
    feature_test = double(reshape(face, [n*m,3]));
    feature_test1 = Ts * (feature_test)';
    feature_test1 = feature_test1';
    im_recover = double(reshape(feature_test1, [n,m,3]));
    % image in YCbCr coordinate
    Y = im_recover(:,:,1);
    Cb = im_recover(:,:,2);
    Cr = im_recover(:,:,3);
    Cr_MAX = max(max(im_recover(:,:,3)));
    Eyemapc = (Cb.^2 + (Cr_MAX - Cr).^2 + (Cb./Cr))/3;
    figure;
    imagesc(Eyemapc) ;
    % got Eyemapc
    SE = [0,0,0,0,0,1,0,0,0,0,0;
          0,0,1,1,1,1,1,1,1,0,0;
          0,1,1,1,1,1,1,1,1,1,0;
          0,1,1,1,1,1,1,1,1,1,0;
          1,1,1,1,1,1,1,1,1,1,1;
          0,1,1,1,1,1,1,1,1,1,0;
          0,1,1,1,1,1,1,1,1,1,0;
          0,0,1,1,1,1,1,1,1,0,0;
          0,0,0,0,0,1,0,0,0,0,0];
    Eyemapl = myNegation(imerode(Y,SE));
    figure;
    imagesc(Eyemapl);
    % got Eyemapl
    Eyemapt_can = extractTexture(im_test); % get 8 Eyemapt ?
    [~,~,page] = find(Eyemapt_can == max(max(max(Eyemapt_can))));
    Eyemapt = Eyemapt_can(:,:,page(1));
    figure;
    imagesc(Eyemapt);
    eyemap = (myGeneralAnd(Eyemapl,Eyemapc)) .* Eyemapt ;
end