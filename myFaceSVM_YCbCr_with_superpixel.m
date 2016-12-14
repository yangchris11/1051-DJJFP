% my face recognition using SVM from LIBSVM
addpath('ERS');
% add superpixel-related functions
% input training data
feature_RGB_face = xlsread('face.xls');  % data of face
feature_RGB_notface = xlsread('notface.xls'); % data of not-face
feature_RGB = [feature_RGB_face; feature_RGB_notface];

% first column: R
% second column: G
% third column: B
[N1,~] = size(feature_RGB_face);
[N2,~] = size(feature_RGB_notface);
label_1 = [ones(N1,1); zeros(N2,1)];
% 1: face, 0: not-face

% convert RGB to YCbCr
T = [0.299, 0.587, 0.114; -0.169, -0.331, 0.5; 0.5, -0.419, -0.081];
feature_YCbCr = T *(feature_RGB)';
feature_YCbCr = feature_YCbCr';
% test data
im_test = imread('TestImagesForPrograms\22.jpg');   % 7, 22號多反光 34號字跡問題; DJJ2_s RGB辨識結果很差
[n,m,~] = size(im_test);
area = n*m;        % area of the photo
% using superpixel
num = 1500;
im_test1 = mysuperpixel(im_test,num);
% transform RGB to YCbCr
feature_test = double(reshape(im_test, [n*m,3]));
label_2 = double(zeros(n*m,1));
feature_test1 = T*(feature_test)';
feature_test1 = feature_test1';
% scaling
mf = mean(feature_YCbCr);
nrm=diag(1./std(feature_YCbCr,1));
feature_1 = (feature_YCbCr -ones(N1 + N2,1)*mf)*nrm;
feature_2 = (double(feature_test1) -ones((n*m),1)*mf)*nrm;
%SVM
model = svmtrain(label_1, feature_YCbCr,'-c 1 -g 0.008');
%test
[predicted, accuracy, d_values] = svmpredict(label_2, feature_test1, model);
% predicted: the SVM output of the test data
im_recover = reshape( predicted, [n,m]);
face_area = size(find(im_recover == 1));
% morphology
t1 = 3;  % for opening method 3
t2 = 6;  % for closing method 5
se = [0,1,0; 1,1,1; 0,1,0];
im_recover = myMorphology(im_recover, se, t1,t2);

% do the face mask
mask = mySkinMask(im_recover);
mask = imdilate(mask,se);
mask = imerode(mask,se);
% get eyemap & mouthmap
eyemap = getEyemap(im_test, mask);
mouthmap = getMouthmap(im_test, mask);
loc = geteye_and_mouth(eyemap, mouthmap);
% result
colormap(gray); image(im_recover .*255);
figure; image(uint8(im_test));
figure; image(uint8(im_test1));
figure; colormap(gray); image(mask);