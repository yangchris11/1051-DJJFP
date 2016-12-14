%=====================================================%
% FileName     [ FinalProject.m ]                     %
% Author       [ Cheng-Yen Yang (b03901086)]          %
% Instructor   [ Professor Jian-Jiun Ding ]           %
% Copyright    [ Copyleft(c), NTUEE , Taiwan ]        %
%=====================================================%

% RGB-to-YCbCr-Transfer-Matrix
global Ts ;
Ts = [0.299, 0.587, 0.114 ;
      -0.169, -0.331, 0.5 ;
      0.5, -0.419, -0.081  ];

% SVM
addpath('ERS') ;
addpath('util') ;

% 
feature_RGB_isFace = xlsread('face.xlsx') ; 
feature_RGB_notFace = xlsread('notface.xlsx') ;
feature_RGB_combine = [ feature_RGB_isFace ; feature_RGB_notFace ] ;
[N1,~] = size(feature_RGB_isFace) ;    % N1 : isFace dataset number
[N2,~] = size(feature_RGB_notFace) ;   % N2 : notFace dataset number
label_RGB_combine = [ones(N1,1);zeros(N2,1)] ;
feature_YCbCr_combine = Ts * (feature_RGB_combine)' ;
feature_YCbCr_combine = feature_YCbCr_combine' ;

% testing

image_test = imread('f.jpg') ;
[n,m,~] = size( image_test ) ;
area = n*m ;

feature_test = double(reshape(image_test, [n*m,3]));
label_2 = double(zeros(n*m,1));
feature_test1 = Ts*(feature_test)';
feature_test1 = feature_test1';

mf = mean(feature_YCbCr_combine);
nrm=diag(1./std(feature_YCbCr_combine,1));
feature_1 = (feature_YCbCr_combine -ones(N1 + N2,1)*mf)*nrm;
feature_2 = (double(feature_test1) -ones((n*m),1)*mf)*nrm;

model = svmtrain(label_RGB_combine, feature_YCbCr_combine,'-c 1 -g 0.008');

[predicted, accuracy, d_values] = svmpredict(label_2, feature_test1, model);

im_recover = reshape( predicted, [n,m]);
face_area = size(find(im_recover == 1));

t1 = 3 ;
t2 = 5 ; 
se = [ 0 , 1 , 0 ;
       1 , 1 , 1 ; 
       0 , 1 , 0  ] ;
im_recover = myMorphology(im_recover, se, t1,t2);

mask = mySkinMask(im_recover);
mask = imdilate(mask,se);
mask = imerode(mask,se);

% get eyemap & mouthmap

eyemap = getEyemap(image_test, mask);
mouthmap = getMouthmap(image_test, mask);
loc = geteye_and_mouth(eyemap, mouthmap);

colormap(gray) ; 
image(im_recover .*255) ;
figure ;
colormap(gray);
image(mask) ;
figure ;
colormap(gray);
image(eyemap) ;




