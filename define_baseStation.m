function base = define_baseStation(filename)
%%Define base station node. Plot. Update neighbour locations for validity
%%according to world boundary conditions. Then adds the base to the
%%environment graph.

global numColumns numRows gridpoints_x gridpoints_y Total_obstacle_space env_graph bC_range;

base = struct();

if (nargin==1)
    load(filename);
%     for i=1:size(base.indices,2)
%         rectangle('Position',[gridpoints_x(base.indices(i))-0.5,gridpoints_y(base.indices(i))-0.5,1,1],'FaceColor','blue');
%     end
    base.plot = rectangle('Position',[base.xc-0.5,base.yc-0.5,base.size(1),base.size(2)],'FaceColor','none');
    text(base.xc - 0.5 , base.yc - 0.5 +(base.size(2)/2), 'BASE');
    plotPotGradient(base);
    return;
end
base.name = 'base';

% size [width height]: give both dimensions even,
% else change task node coordinate generation
base.size = [2 2];

base.space = ((base.size(1)) * (base.size(2)));
Total_obstacle_space =  Total_obstacle_space + base.space;
base.index = (ceil(numRows/2)*numColumns + floor(numColumns/2) +1)-((base.size(1))/2)-((base.size(2)/2)*numColumns);

%bottom left cell
base.indices(1) = base.index;

base.indices(2:base.size(1)) = (base.index+1):(base.index+base.size(1)-1);
tempindices = [];

%for every column
for i = 1:base.size(1)
    
    %for rows starting from 2nd
    for j=1:base.size(2)-1
        tempindices = [tempindices,base.indices(i)+j*numColumns];
    end
end
base.indices = [base.indices,tempindices];
base.indices = sort(base.indices);

base.xc = gridpoints_x(base.index);
base.yc = gridpoints_y(base.index);
base.xpoly = [base.xc base.xc+base.size(1) base.xc+base.size(1) base.xc base.xc];
base.ypoly = [base.yc base.yc base.yc+base.size(2) base.yc+base.size(2) base.yc];
base.xpoly = base.xpoly - 0.5;
base.ypoly = base.ypoly - 0.5;

% for i=1:size(base.indices,2)
%     rectangle('Position',[gridpoints_x(base.indices(i))-0.5,gridpoints_y(base.indices(i))-0.5,1,1],'FaceColor','blue');
% end
% base.plot = rectangle('Position',[base.xc - 0.5,base.yc - 0.5,base.size(1),base.size(2)],'FaceColor','none');
% text(base.xc - 0.5 , base.yc - 0.5 +(base.size(2)/2), 'BASE');

%both fields used for obstacle avoidance
base.dir = 0;
base.type = 'hard';

base.connected = [];

base.c_range = bC_range;

% find maximum number of neighbours possible
base.max_c_neighbour = length(get_neighbours_in_range(base.indices,base.c_range));
base.current_c_neighbour_number = length(get_neighbours_in_range(base.indices,base.c_range));

%1st row for xc, 2nd for yc, 3rd for valid neighbour,
%4th for who occupies it!, 5th for the plot handle, 6 for index
base.c_neighbours = cell(6,base.max_c_neighbour);

%set flags if at boundary
base.at_rxwall = 0;               %read at right  x-axis wall
base.at_lxwall = 0;               %read at left   x-axis wall
base.at_tywall = 0;               %read at top    y-axis wall
base.at_bywall = 0;               %read at bottom y-axis wall

base = get_neighbours(base);
env_graph = update_graph(env_graph, base, 1);
build_gradientGraph(base);
