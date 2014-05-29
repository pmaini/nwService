function feasible = check_feasible(agent_node,task,base,obstacle)
%%Check for reachability of the task node and also availability of the
%%required number of nodes

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PROBLEM
%NOBODY HAS THE INFORMATION OF FREE AGENTS. HOW IS AVAILABILITY CHECKED
%THEN??
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


global numAgent covered_fraction env_graph;

feasible = 1;
agents_required = 0;

% %First calculate the total need for all tasks currently being serviced
% for i = 1:numAgent
%     if agent_node(i).current_task ~= 0
%        agents_required = agents_required + ((agent_node(i).distance_to_task * (1+covered_fraction))/(2*sqrt(2)));
%     end
% end
% 
% %Next find the number of agents currently free
% agents_free = 0;
% for i = 1:numAgent
%     if agent_node(i).free == 1
%        agents_free = agents_free + 1;
%     end
% end
% 
% %Find the number of agents available for the task
% agents_available = agents_free - agents_required;
% if agents_available >= (task.distance_from_base * (1+covered_fraction))/(2*sqrt(2))
%     feasible = 1;
% end

%check for reachability
noObstNeigh = setdiff([base.c_neighbours{6,:}],[obstacle.index]);
noObstNeigh(noObstNeigh ==0) = [];
[distance , ~, ~] = graphshortestpath(env_graph,noObstNeigh(1),task.index,'Directed',true);

if isinf(distance)
    feasible = 0;
end