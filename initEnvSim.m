function initEnvSim(filename)
%%Initialize the environment

global  numRows grid_type numColumns xmin ymin sim_cont numCells xmax ymax;
global task_counter max_tasks current_tasks time Total_obstacle_space;
global gridlocation index_for_UD gridpoints_x gridpoints_y;
global numAgent numTask numObstacle comm_network aC_range bC_range;
global size_x size_y size_g covered_fraction aS_range d_max env_graph;
global aT_range base_connected gridCells s_time losMat cNeighMat maxTargets;

if nargin == 1
    
%     load(filename);
%     global base_connected numAgent gridCells aT_range aS_range aC_range;
    
    % to record agents currently connected to the base station
    base_connected = ones(1,numAgent);
    
    for k = 0:(numCells-1)
        gridCells(k+1).t_neighbours = get_neighbours_in_range(k+1,aT_range);
        gridCells(k+1).s_neighbours = get_neighbours_in_range(k+1,aS_range);
        gridCells(k+1).c_neighbours = get_neighbours_in_range(k+1,aC_range);
    end

    return;
end

numCells = numRows * numColumns;

if grid_type == 0
    xmax = xmin + numColumns;
    ymax = ymin + numRows;
end

%cells are numbered 1:numCells, and indexed into the following row vectors
%to access the corresponding value. x-coordinates y-coordinates and
%location area
gridpoints_x = ones(1,numCells);
gridpoints_y = ones(1,numCells);
gridlocation = ones(1,numCells);

% Index for Uniform Distribution
index_for_UD = 0;

% numTask numObstacle covered_fraction
Total_obstacle_space =  0;

% Track of total number of tasks completed
task_counter = 0;
% maximum number of simulataneous active tasks
max_tasks = 0;
% Number of tasks currently active
current_tasks = 0;

%continue simulation or not
time = 1;
sim_cont = 1;

% axis ([xmin xmax ymin ymax]);
% axis square;
% box on;
% grid on;
% set(gca,'XTick',xmin:1:xmax);%[]);%
% set(gca,'YTick',ymin:1:ymax);%[]);%
% hold on;

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
end
