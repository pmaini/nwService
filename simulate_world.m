function [base, agent_node, task_node] = simulate_world(base, obstacle, agent_node, task_node)
%%Main execution loop. Do the update cycle here.

global grid_type numRows numColumns xmin ymin env_graph;% numCells xmax ymax
global numAgent numTask numObstacle sim_cont comm_network;% base_connected
global  task_counter max_tasks current_tasks time;% Total_obstacle_space
%global size_x size_y size_g gridpoints_x gridpoints_y covered_fraction
%global gridlocation gridCells s_time index_for_UD;


for i = 1:numAgent
    agent_node(i).pathTrack = agent_node(i).index;
end 
    
% Task Service
maxm_Time = numTask*100;
while (sim_cont == 1)&&(time <= maxm_Time)
    
    time = time+1;
    
    for i = 1:numAgent
        agent_node = getCost(agent_node,i,task_node);
    end   
    
    [agent_node base task_node] = update_world(agent_node,base,obstacle,task_node);
        
%   Use sensed information for the target computation for each agent
    agent_node = update_agents(base, agent_node, obstacle, task_node);
    
    if (mod(time,4) == 0 )
    %   Evaluate and make move towards next location of the agent
        for i = 1:numAgent
            [base, agent_node] = next_move(i, base, agent_node,obstacle);
        end

    end
    
%     [agent_node task_node] = refresh_plot(agent_node, task_node);
    
%     pause(0.1);
%     
%     if time == 19
%         pause(1);
%     end
    
    [task_node agent_node] = update_task_status(task_node,agent_node,base);
    
%     update_sim_cont(task_node,agent_node);
end