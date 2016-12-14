% using Lukasiewicz t norms
function result = myGeneralAnd(a,b)
[n,m] = size(a);    % the size of a and that of b should be the same
result = zeros(n,m);
for k = 1:n
    for q = 1:m
        temp = a(k,q) + b(k,q) - 1;
        result(k,q) = max(temp,0);
    end;
end;
end