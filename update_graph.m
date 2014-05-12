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

global numColumns;

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
                    case 2
                        s_graph(index,index+numColumns) = 0;% s_graph(index,index+numColumns)*10;
                        s_graph(index+numColumns,index) = 0;% s_graph(index,index+numColumns)*10;
                    case 6
                        s_graph(index,index-1) = 0;% s_graph(index,index-1)*10;
                        s_graph(index-1,index) = 0;% s_graph(index,index-1)*10;
                    case 8
                        s_graph(index,index-numColumns) = 0;% s_graph(index,index-numColumns)*10;
                        s_graph(index-numColumns,index) = 0;% s_graph(index,index-numColumns)*10;
                    case 4
                        s_graph(index,index+1) = 0;% s_graph(index,index+1)*10;
                        s_graph(index+1,index) = 0;% s_graph(index,index+1)*10;
                end
        end
        
    case 0
        switch node.type
            case 'soft'
                switch node.dir
                    case 2
                        s_graph(index,index+numColumns) = 1;
                        s_graph(index+numColumns,index) = 1;
                    case 6
                        s_graph(index,index-1) = 1;
                        s_graph(index-1,index) = 1;
                    case 8
                        s_graph(index,index-numColumns) = 1;
                        s_graph(index-numColumns,index) = 1;
                    case 4
                        s_graph(index,index+1) = 1;
                        s_graph(index+1,index) = 1;
                end
            case 'collAvoid'
                switch node.dir
                    case 2
                        s_graph(index,index+numColumns) = 4;%2;%
                        s_graph(index+numColumns,index) = 4;%2;%
                    case 6
                        s_graph(index,index-1) = 4;%2;%
                        s_graph(index-1,index) = 4;%2;%
                    case 8
                        s_graph(index,index-numColumns) = 4;%2;%
                        s_graph(index-numColumns,index) = 4;%2;%
                    case 4
                        s_graph(index,index+1) = 4;%2;%
                        s_graph(index+1,index) = 4;%2;%
                end
        end
end
