%=====================================================%
% FileName     [ myNegation.m ]                       %
% Author       [ Cheng-Yen Yang (b03901086)]          %
% Instructor   [ Professor Jian-Jiun Ding ]           %
% Copyright    [ Copyleft(c), NTUEE , Taiwan ]        %
%=====================================================%

% instead of Sugeno Negation, use another kind of method
function result = myNegation(x)
    [m,n] = size(x);
    result = zeros(m,n);
    temp1 = zeros(5,1);
    for k =1:m
        for q = 1:n
            temp1(1) = x(k,q);
             if (k ~= 1)
                   temp1(2) = x(k-1,q);
             end;
             if (k ~= m)
                   temp1(3) = x(k+1,q);
             end;
             if (q ~= 1)
                   temp1(4) = x(k,q-1);
             end;
             if (q ~= n)
                   temp1(5) = x(k,q+1);
             end;
             temp = max(temp1);
             result(k,q) = temp;
        end;
    end;
end