function base = initBaseNeigh(base)

global env_graph bC_range

base.c_range = bC_range;

% find maximum number of neighbours possible
base.max_c_neighbour = length(get_neighbours_in_range(base.indices,base.c_range));
base.current_c_neighbour_number = length(get_neighbours_in_range(base.indices,base.c_range));

%1st row for xc, 2nd for yc, 3rd for valid neighbour,
%4th for who occupies it!, 5th for the plot handle, 6 for index
base.c_neighbours = cell(6,base.max_c_neighbour);

base = get_neighbours(base);
env_graph = update_graph(env_graph, base, 1);
build_gradientGraph(base);