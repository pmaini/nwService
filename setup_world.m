function [base, agent_node, task_node] = setup_world(base, obstacle, agent_node, task_node)
%%Initialize agents and tasks. Make plots.Initialize the first feasible
% task. Initialize service.

global grid_type numRows numColumns xmin ymin env_graph;% numCells xmax ymax
global numAgent numTask numObstacle sim_cont comm_network lsMat cNeighMat;
global  task_counter max_tasks current_tasks time;% Total_obstacle_space
%global size_x size_y size_g gridpoints_x gridpoints_y covered_fraction
%global gridlocation gridCells s_time index_for_UD;

%% One time sensing

base = build_neighbourhood(base,obstacle);

%% Task Node initialization

feasible = 0;
i = 1;
while i <= 2
    feasible = check_feasible(agent_node,task_node(i),base, obstacle);
    if feasible == 1
        task_node(i).active = 1;
        task_counter = task_counter + 1;
        current_tasks = current_tasks + 1;
        max_tasks = max(max_tasks,current_tasks);
        i = i+1;
    end
    
end
%% Update World

[agent_node base] = update_world(agent_node,base,obstacle, task_node);

%% Make the plots:

[agent_node task_node] = refresh_plot(agent_node, task_node);