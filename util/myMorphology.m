%=====================================================%
% FileName     [ myMorphology.m ]                     %
% Author       [ Cheng-Yen Yang (b03901086)]          %
% Instructor   [ Professor Jian-Jiun Ding ]           %
% Copyright    [ Copyleft(c), NTUEE , Taiwan ]        %
%=====================================================%

% image : input image
% se : structing element
% openingT : opening method element
% closingT : closing method element
 
function result = myMorphology( image , se , openingT , closingT )

for i = 1:openingT
    image = imerode(image,se);
end;

for i = 1:openingT
    image = imdilate(image,se);
end;

for i = 1:closingT
    image = imdilate(image,se);
end;

for i = 1:closingT
    image = imerode(image,se);
end;

result = image;

end