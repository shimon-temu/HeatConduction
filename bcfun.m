function [pl, ql, pr, qr] = bcfun(xl, ul, xr, ur, t)
    % u(0, t) = 1000
    pl = ul - 1000;
    ql = 0;
    % u(L, t) = 1000
    pr = ur - 1000;
    qr = 0;
end