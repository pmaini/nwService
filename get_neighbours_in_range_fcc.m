function neighbours = get_neighbours_in_range_fcc(cell_index,range)
%%PLEASE READ%%Get indices of naighbouring locations given index(es) &
%%range. Locations outside world boundary are given the consistent index 0.
%%This function does not "CHECK" LOS connectivity. It only gives indices of
%%cells within the specified range. It is generic, and not defined only for
%%LOS neighbours. It may also be used for sensing or transition neighbours.
%%Returns only valid neighbour locations as per world boundaries.
%%AlSO NOTE, these ranges are calculated from cell centre not the boundary.
%%(but actually that does not make a difference because eache next cell in
%%a direction is atleast 1 unit away and the maximum that this difference
%%of reference can give is (sqrt(2)/2) which is arnd 0.712...so it is okay!
global gridpoints_x gridpoints_y;
xc_0 = gridpoints_x(cell_index(:));
xc_1 = xc_0 - 0.5;
xc_2 = xc_0 + 0.5;
xc = [xc_1 xc_2 xc_1 xc_2];
yc_0 = gridpoints_y(cell_index(:));
yc_1 = yc_0 - 0.5;
yc_2 = yc_0 + 0.5;
yc = [yc_1 yc_2 yc_2 yc_1];
dx = max(xc) - min(xc);
dy = max(yc) - min(yc);
neighbours = [];

z = ceil(range);

xl = min(xc_0 - z);
yl = min(yc_0 - z);
xh = max(xc_0 + z);
yh = max(yc_0 + z);

x = xl:1:xh;
y = yl:1:yh;

xpoly = [min(xc),min(xc),min(xc)+dx,min(xc)+dx,min(xc)];
ypoly = [min(yc),min(yc)+dy,min(yc)+dy,min(yc),min(yc)];

indices = [];
for j = 1:length(y)
    for i = 1:length(x)
        index = find_index(x(i),y(j));
        if ~ismember(index,cell_index)
            %By checking using coordintates the invalid neighbour
            %cells whose indices are 0 are also added.
            distance = p_poly_dist(x(i),y(j),xpoly,ypoly);
%             distance = min(dist([x(i),y(j)],[xc;yc]));
            if (distance <= range)
                neighbours = [neighbours index];
            end
            indices = [indices index];
        end
    end
end

% This part commented out so this function always returns the max_neighbour
% number of neighbours. 0 if its invalid

% neighbours(neighbours==0) = [];
% neighbours = unique(neighbours);
% neighbours = sort(neighbours);