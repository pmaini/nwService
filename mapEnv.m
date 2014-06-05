%% Strategies for base network constrained task servicing at multiple sites
%yellow agents are free
%green ones are in relay
%blue ones are leader or service agents
%service agents have caption as 'i-Tj',
%where 'i' is the agent number and 'j' is the task number
%% Initializations

clear all;
close all;

global grid_type numRows numColumns xmin ymin env_graph numCells xmax ymax;
global numAgent numTask numObstacle sim_cont comm_network aC_range bC_range aT_range;
global task_counter max_tasks current_tasks time Total_obstacle_space d_max base_connected;
global size_x size_y size_g gridpoints_x gridpoints_y covered_fraction aS_range;
global gridlocation gridCells s_time index_for_UD losMat NeighMat maxTargets;

load('8Environ');
% % %0: square: coordinates at bottom left of the cell
% % %1: hexagon: coordinates at the center of the cell
% grid_type = 0;% 1;%
% numRows = 20;
% numColumns = 20;
% xmin = 0;
% ymin = 0;
numObstacle = 6;

% genEnv();
% genEnvs();

numAgent = 4;
numTask = 3;
%Assumption: aC_range == bC_range
aC_range = 2*sqrt(2);
bC_range = 2*sqrt(2);
aS_range = 1*sqrt(2);
aT_range = 1;%sqrt(2);
maxTargets = 2;
save('tempEnv');


for i= 1:20
    load('tempEnv');
    filename = ([ num2str(i) 'Sno' num2str(numRows) 'x' ...
    num2str(numColumns) 'O' num2str(numObstacle)]);
    [base, obstacle] = create_worldSim(filename);%(filename);%
    clear all;    
end