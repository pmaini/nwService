function connectivity = isConnectionPossible(x1,y1,x2,y2,base,obstacle,range)
%%check if (x1,y1) and (x2,y2) are in Line-of-sight communication range.

%one of the two could be a polygon, any one.

% x1,y1: connection from
% x2,y2: connection to

connectivity = 0;
dist_metric = 100; %random initial value
dx = x2-x1;
dy = y2-y1;
LosClear = 0;

if ((numel(x1) == 1) && (numel(x2) == 1))
    LosClear = isLosClear(x1,y1,x2,y2,base,obstacle,1);
    if LosClear == 1
        dist_metric = sqrt((dx^2)+(dy^2));
    end
elseif xor((numel(x1) > 1),(numel(x2) > 1))
    if numel(x2)>numel(x1)
        LosClear = isLosClear(x1,y1,x2,y2,base,obstacle,0);
    else
        LosClear = isLosClear(x2,y2,x1,y1,base,obstacle,0);
    end
    if LosClear == 1
        dist_metric = min(sqrt((dx.^2)+(dy.^2)));%dx and dy are vectors here
    end
end

if dist_metric < range
    connectivity = 1;
end 