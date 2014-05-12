function LosClear = isLosClear(x1,y1,x2,y2,base,obstacle,flag)
%%check for LoS clarity. One of the two points could be a polygon.

%flag tells if base is also to be included as an obstacle or not
%1 for yes and 0 for no.

global numObstacle;
LosClear = 0;
% xp = [];
% yp = [];

if flag == 1
    maxCounter = numObstacle+1;
elseif flag == 0
    maxCounter = numObstacle;
end

if ((numel(x1)==1) && (numel(x2)==1))
    x = [x1 x2];
    y = [y1 y2];
elseif xor((numel(x1)>1),(numel(x2)>1))
    if (numel(x2) > 1)
        [~, xp yp] = p_poly_dist(x1,y1,x2,y2);
        x = [x1 xp];
        y = [y1 yp];
    elseif (numel(x1) > 1)
        [~, xp yp] = p_poly_dist(x1,y1,x2,y2);
        x = [x2 xp];
        y = [y2 yp];
    end    
end

for i = 1:maxCounter
    
    if i>numObstacle
        [a b] = polyxpoly(x,y,base.xpoly,base.ypoly);
    else
        [a b] = polyxpoly(x,y,obstacle(i).xpoly,obstacle(i).ypoly);
    end
    

        
% This is the case where LoS brushes the corners of more than one obstacles
% and comprises cases where 2 obstacles share a vertex. Such and other
% cases are considered as blocking the LoS.
    if ((LosClear == 0.5) && (numel(a) == 2) &&(numel(b) == 2)&& (a(1) == a(2)) && (b(1) == b(2)))
        LosClear = 0;
        break;
    elseif ((numel(a) == 2) &&(numel(b) == 2) && (a(1) == a(2)) && (b(1) == b(2)))
        LosClear = 0.5;
    elseif ((numel(a) == 0) && (numel(b) == 0))
        if (LosClear == 0)
            LosClear = 1;
        end
    else
        LosClear = 0;
        break;
    end    
end

if LosClear == 0.5
    LosClear = 1;
end