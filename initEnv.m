function initEnv(filename)
%%Initialize the environment --
%{
declare all global variables
gridpoint vectors
plot the axes
initialize all global variables
get region
get location neighbours
main use is of gridpoint vectors, gridlocation and base_connected
%}

global xmin ymin xmax ymax;

if nargin == 1
    
    load(filename);
    axis ([xmin xmax ymin ymax]);
    axis square;
    box on;
    grid on;
    set(gca,'XTick',xmin:1:xmax);%[]);%
    set(gca,'YTick',ymin:1:ymax);%[]);%
    hold on;
    return;
end

global grid_type;
% 0: square: coordinates at bottom left
% 1: hexagon: coordinates at the center

global numCells numRows numColumns;
numCells = numRows * numColumns;


if grid_type == 0
    xmax = xmin + numColumns;
    ymax = ymin + numRows;
end

% global size_x size_y size_g; % used in graph representation and operations
% size_x = xmax - xmin;
% size_y = ymax - ymin;
% size_g = size_x * size_y;

%cells are numbered 1:numCells, and indexed into the following row vectors
%to access the corresponding value. x-coordinates y-coordinates and
%location area
global gridpoints_x gridpoints_y gridlocation gridCells;
gridpoints_x = ones(1,numCells);
gridpoints_y = ones(1,numCells);
gridlocation = ones(1,numCells);
gridCells.validneighbours = [];

% Index for Uniform Distribution
global index_for_UD;
index_for_UD = 0;

% numTask numObstacle covered_fraction
global numAgent Total_obstacle_space;
Total_obstacle_space =  0;
Total_obstacle_space =  Total_obstacle_space + numAgent;

% Track of total number of tasks completed
global task_counter;
% maximum number of simulataneous active tasks
global max_tasks;
% Number of tasks currently active
global current_tasks;
task_counter = 0;
max_tasks = 0;
current_tasks = 0;

% to record agents currently connected to the base station
global base_connected;
base_connected = ones(1,numAgent);

%continue simulation or not
global time sim_cont;
time = 1;
sim_cont = 1;

% global env_graph;
axis ([xmin xmax ymin ymax]);
axis square;
box on;
% grid on;
% set(gca,'XTick',xmin:1:xmax);%[]);%
% set(gca,'YTick',ymin:1:ymax);%[]);%
hold on;

%from 0 to numCells-1 for easy calculation of j using mod
for k = 0:(numCells-1)
    i = floor(k/numColumns);
    j = mod(k,numColumns);
    if grid_type == 0
        yc = ymin + i + 0.5;
        xc = xmin + j + 0.5;
    else
        %set for hexagonal
        yc = ymin + i;
        xc = xmin + j;
    end
    %     text(xc+0.2,yc+0.5,num2str(k+1),'FontSize',7);
    gridpoints_x(k+1) = xc;
    gridpoints_y(k+1) = yc;
    gridlocation(k+1) = get_location(k+1);
    gridCells(k+1).validneighbours = find_valid_neighbour_indices(k+1);
end

