function [v,r] = interpolate (imR, xR, yR)


    xf = floor(xR);
    xc = ceil(xR);
    yf = floor(yR);
    yc = ceil(yR);
    if xf == xc & yc == yf
        v = imR (xc, yc);
    elseif xf == xc
        v = imR (xf, yf) + (yR - yf)*(imR (xf, yc) - imR (xf, yf));
    elseif yf == yc
        v = imR (xf, yf) + (xR - xf)*(imR (xc, yf) - imR (xf, yf));
    else
       A = [ xf yf xf*yf 1
             xf yc xf*yc 1
             xc yf xc*yf 1
             xc yc xc*yc 1 ];
       r = [ imR(xf, yf)
             imR(xf, yc)
             imR(xc, yf)
             imR(xc, yc) ];
       a = A\double(r);
       w = [xR yR xR*yR 1];
       v = w*a;
    end
   

