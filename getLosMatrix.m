function [rval1 rval2] = getLosMatrix(base, obstacle, filename)

global numCells gridpoints_x gridpoints_y aC_range gridCells aS_range aT_range;

if nargin == 3
    load(filename);
    rval1 = losMat;
    rval2 = NeighMat;
    return;
end

range = [aC_range aS_range aT_range];
maxnNum = length(get_neighbours_in_range(base.indices(1),max(range)));
neighbourMatrix = zeros(numCells,maxnNum,3);
losMatrix = zeros(numCells,maxnNum,3);



for i = 1:numCells
    neigh = gridCells(i).c_neighbours;% get_neighbours_in_range(i,range);
    neigh(ismember(neigh,base.indices)) = 0;
    neigh(ismember(neigh,[obstacle(:).index])) = 0;
    neighC = neigh;
    neighS = gridCells(i).s_neighbours(ismember(gridCells(i).s_neighbours,neigh));
    neighT = gridCells(i).t_neighbours(ismember(gridCells(i).t_neighbours,neigh));

    neighbourMatrix(i,:,1) = neighC;
    neighbourMatrix(i,1:length(neighS),2) = neighS;
    neighbourMatrix(i,1:length(neighT),3) = neighT;
%     neighbourMatrix(i,:) = neigh;%setdiff(get_neighbours_in_range(i,range),[obstacle(:).index]);
end

for i = 1:numCells
    for r = 1:3
        for j = 1:length(neighbourMatrix(i,:,r))
            nIndex = neighbourMatrix(i,j,r);
            if nIndex == 0
                losMatrix(i,j,r) = 0;
                continue;
            end
            losMatrix(i,j,r) = isLosClear(gridpoints_x(i),gridpoints_y(i),gridpoints_x(nIndex),gridpoints_y(nIndex),base,obstacle,1);
        end
    end
end

rval1 = losMatrix;
rval2 = neighbourMatrix;