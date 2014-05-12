function s_graph = make_graph()
%%Builds a graphical representation of the world wherein every location is
%connected to valid transition locations

global grid_type numCells gridCells;
i = [];
j = [];

%whenever an edge has to be placed, put it in the lower triangle because
%upper triangle is ignored while running dikjstra on an undirected graph.

for n=1:numCells    
    if grid_type == 0
        tempIndices = [2,4,6,8];
        neighbours = gridCells(n).validneighbours(tempIndices);
    else
        neighbours = gridCells(n).validneighbours;        
    end
    neighbours = unique(neighbours);
    neighbours(neighbours == 0) = [];
    for len = 1:length(neighbours)
           i = [i,n];
           j = [j,neighbours(len)];      
    end
end

s_graph = sparse(i,j,1,numCells,numCells,(8*numCells));
% view(biograph(s_graph));