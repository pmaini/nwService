function index = find_index(xc,yc)

global xmax xmin ymax ymin numColumns

if ((xc >= xmin) && (xc <= xmax-0.5))&&((yc >= ymin)&&(yc <= ymax-0.5))
    %upto max-0.5 so for agents which are given coordinates in int +- 0.5
    %can be taken care of and at the same time the boundaries are not
    %crossed.
    index = (((floor(yc)-ymin)*numColumns) +(floor(xc)-xmin))+1;
else
    index = 0;
end