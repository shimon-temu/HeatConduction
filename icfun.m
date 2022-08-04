function u0 = icfun(x)
    if x == 0 || x == 1
        u0 = 1000;
    else
        u0 = 0;
    end
end