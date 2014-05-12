function node = get_neighbours(node)
%%Define neighbour locations around the node(single cell or multi cell).
%%set boundary flags. Also populate neighbour cell arrays for different
%%ranges. It does not perform any kind of sensing or perception operation.

global gridpoints_x gridpoints_y;

node = set_boundary_flags(node);

if (strcmp(node.name,'base') == 1)
    range = node.c_range;
    index = node.indices;
else %(strcmp(node.name,'agent') == 1)
    range = [node.c_range node.s_range node.t_range];
    index = node.index;
end

for j = 1:length(range)
    neighbours = get_neighbours_in_range(index,range(j));
    neighbour = cell(6,length(neighbours));
    for i = 1:length(neighbours)
        if neighbours(i) ~= 0
            neighbour{1,i} = gridpoints_x(neighbours(i));
            neighbour{2,i} = gridpoints_y(neighbours(i));
            neighbour{3,i} = 'OK';
            neighbour{4,i} = 'EMPTY';
            %neighbour{5,i} = plot(neighbour{1,i},neighbour{2,i},'ms','MarkerSize',12);
            neighbour{6,i} = neighbours(i);
        elseif neighbours(i) == 0
            neighbour{1,i} = 'NULL';
            neighbour{2,i} = 'NULL';
            neighbour{3,i} = 'NULL';
            neighbour{4,i} = 'NULL';
            neighbour{5,i} = 'NULL';
            neighbour{6,i} = neighbours(i);
        end
    end
    switch(j)
        case 1
            node.max_c_neighbour = length(neighbours);
            node.current_c_neighbour_number = length(find(neighbours));
            node.c_neighbours = neighbour;
        case 2
            node.max_s_neighbour = length(neighbours);
            node.current_s_neighbour_number = length(find(neighbours));
            node.s_neighbours = neighbour;
        case 3
            node.max_t_neighbour = length(neighbours);
            node.current_t_neighbour_number = length(find(neighbours));
            node.t_neighbours = neighbour;
    end
end