function build_gradientGraph(base)

global numCells gridCells env_graph;

bNeighbourhood_level(base);

plotPotGradient(base);

for i = 1:numCells
   t_indices = gridCells(i).t_neighbours;
   t_indices(t_indices == 0) = [];   
   for j = 1:length(t_indices)
       k = t_indices(j);
       if env_graph(i,k) == 1 || env_graph(k,i) == 1
           if gridCells(k).bNeighL == gridCells(i).bNeighL
               env_graph(i,k) = gridCells(k).bNeighL;      
           elseif gridCells(k).bNeighL == gridCells(i).bNeighL+1
               env_graph(i,k) = gridCells(k).bNeighL;
           elseif gridCells(k).bNeighL == gridCells(i).bNeighL-1
               env_graph(i,k) = gridCells(k).bNeighL;
           end
       end   
   end
end