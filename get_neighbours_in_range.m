function neighbours = get_neighbours_in_range(cell_index,range)
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
xc = gridpoints_x(cell_index(:));
yc = gridpoints_y(cell_index(:));
dx = max(xc) - min(xc);
dy = max(yc) - min(yc);
neighbours = [];

z = ceil(range);

xl = min(xc - z);
yl = min(yc - z);
xh = max(xc + z);
yh = max(yc + z);

x = xl:1:xh;
y = yl:1:yh;

xpoly = [min(xc),min(xc),min(xc)+dx,min(xc)+dx,min(xc)];
ypoly = [min(yc),min(yc)+dy,min(yc)+dy,min(yc),min(yc)];

indices = [];
for i = 1:length(y)
    for j = 1:length(x)
        index = find_index(x(j),y(i));
        if ~ismember(index,cell_index)
            %By checking using coordintates the invalid neighbour
            %cells whose indices are 0 are also added.
            distance = min(dist([x(i),y(j)],[xc;yc]));
            if (distance <= range)
                neighbours = [neighbours index];
            end
            indices = [indices index];
        end
    end
end
% 
% neighbours(neighbours==0) = [];
% neighbours = unique(neighbours);
% neighbours = sort(neighbours);