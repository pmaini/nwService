function s_graph = update_graph(s_graph,node,flag)
%%Update the environment/obstacle graph

%Node is the obstacle -- A structure with basic fields type,dir,indices,index.
%flag == 1: add obstacle; flag == 0: remove obstacle

%hard is type fpr base or other non-mobile obstacles sensed in the world
%soft is type for mobile obstacles as well as other agents which may
%temporarily act as obstacles

%encoding:
%edge weight 0: hard obstacle(remove edge) totally from the graph
%edge weight 0: soft obstacle, directional zero cost
%edge weight 1: normal edge

global numColumns d_max gridCells;

index = node.index;

if (index == 0)
    return;
end

switch flag
    case 1  %add obstacle, remove edges
        switch(node.type)
            case 'hard'
                
                %give weight Inf to hard and remove all edges.
                %weight 0 to soft obstacles and remove only directional
                %edges(both sides).
                shape = isfield(node,'indices');
                if shape == 1
                    
                    %signifies multiple blocks for obstacle
                    indices = node.indices;
                else
                    
                    %signifies single block for obstacle
                    indices = node.index;
                end
                for del = 1:1:length(indices)
                    n = indices(del);
                    s_graph(n,:) = 0;
                    s_graph(:,n) = 0;
                end
%                 view(biograph(s_graph));
                
            case 'soft'
                switch node.dir
                    %1:from up,2:from right,3:from left,4:from bottom
                    case 1
                        adj_index = index+numColumns;
                    case 2
                        adj_index = index+1;
                    case 3
                        adj_index = index-1;
                    case 4
                        adj_index = index-numColumns;
                end
                s_graph(adj_index,index) = 0;
        end
        
    case 0
        switch node.type
            case 'soft'                
                switch node.dir
                    %1:from up,2:from right,3:from left,4:from bottom
                    case 1
                        adj_index = index+numColumns;
                    case 2
                        adj_index = index+1;
                    case 3
                        adj_index = index-1;
                    case 4
                        adj_index = index-numColumns;
                end
                
                if gridCells(index).bNeighL == gridCells(adj_index).bNeighL
                   s_graph(adj_index,index) = gridCells(index).bNeighL;
                   
                elseif gridCells(index).bNeighL == gridCells(adj_index).bNeighL+1
                   s_graph(adj_index,index) = gridCells(index).bNeighL;
                   
                elseif gridCells(index).bNeighL == gridCells(adj_index).bNeighL-1
                   s_graph(adj_index,index) = gridCells(index).bNeighL;
                   
                end
               
            case 'collAvoid'
                switch node.dir
                    %1:from up,2:from right,3:from left,4:from bottom
                    case 1
                        adj_index = index+numColumns;
                    case 2
                        adj_index = index+1;
                    case 3
                        adj_index = index-1;
                    case 4
                        adj_index = index-numColumns;
                end
                
                %The cost should be more than that fro alternate paths on
                %both sides
                s_graph(adj_index,index) = (max(gridCells(adj_index).bNeighL,gridCells(index).bNeighL)*4);%d_max+1;%
        end
end
