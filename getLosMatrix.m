function [rval1 rval2] = getLosMatrix(base, obstacle, filename)

global numCells gridpoints_x gridpoints_y aC_range;

if nargin == 3
    load(filename);
    rval1 = losMat;
    rval2 = cNeighMat;
    return;
end

range = aC_range;
maxnNum = length(get_neighbours_in_range(base.c_neighbours{6,1},range));
neighbourMatrix = zeros(numCells,maxnNum);
losMatrix = zeros(numCells,maxnNum);

for i = 1:numCells
    neigh = get_neighbours_in_range(i,range);
    neigh(ismember(neigh,base.indices)) = 0;
    neigh(ismember(neigh,[obstacle(:).index])) = 0;
    neighbourMatrix(i,:) = neigh;
%     neighbourMatrix(i,:) = neigh;%setdiff(get_neighbours_in_range(i,range),[obstacle(:).index]);
end

for i = 1:numCells
    for j = 1:maxnNum
        nIndex = neighbourMatrix(i,j);
        if nIndex == 0
            losMatrix(i,j) = 0;
            continue;
        end
        losMatrix(i,j) = isLosClear(gridpoints_x(i),gridpoints_y(i),gridpoints_x(nIndex),gridpoints_y(nIndex),base,obstacle,1);
    end
end

rval1 = losMatrix;
rval2 = neighbourMatrix;