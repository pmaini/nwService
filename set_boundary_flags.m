function node = set_boundary_flags(node)
%set value of flags to check for boundary conditions uses only cell
%indices. Does not use coordinates or the neighbour information.
global numColumns numCells;%xmax xmin ymax ymin

%This calculation is with the assumption that walls are only at integer
%coordinates.

larray = 1:numColumns:numCells;
rarray = numColumns:numColumns:numCells;
barray = 1:1:numColumns;
tarray = (numCells-numColumns+1):1:numCells;

if isfield(node,'indices')
    indices = node.indices;
else
    indices = node.index;
end

if sum(ismember(rarray,indices))%  ((node.xc + node.size(1)) >= xmax)
    node.at_rxwall = 1;
else
    node.at_rxwall = 0;
end

if sum(ismember(larray,indices))%  (abs((node.xc) - (xmin)) < 1)
    node.at_lxwall = 1;
else
    node.at_lxwall = 0;
end

if sum(ismember(tarray,indices))%  ((node.yc + node.size(2)) >= ymax)
    node.at_tywall = 1;
else
    node.at_tywall = 0;
end

if sum(ismember(barray,indices))%  (abs((node.yc) - (ymin)) < 1)
    node.at_bywall = 1;
else
    node.at_bywall = 0;
end