function playgroundSim(filename)

% close all;
% clear all;

global grid_type numRows numColumns xmin ymin env_graph numCells xmax ymax;
global numAgent numTask numObstacle sim_cont comm_network aC_range bC_range aT_range;
global task_counter max_tasks current_tasks time Total_obstacle_space d_max;
global size_x size_y size_g gridpoints_x gridpoints_y covered_fraction aS_range;
global gridlocation gridCells s_time index_for_UD losMat NeighMat maxTargets;

load(filename);

load('graph','graph1');
[agent_node(:).view] = deal(graph1);
graph = graph1;

[base, agent_node, task_node] = setup_world(base, obstacle, agent_node, task_node);

[base, agent_node, task_node] = simulate_world(base, obstacle, agent_node, task_node);

save([filename 'res']);

clear all;

% numAgent = 1;
% 
% for i = 1:2
%     for j =2:4
%         
%    call_fn(i);
%     end
% end