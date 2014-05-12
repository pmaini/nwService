function [agents base task_node] = update_world(agents,base,obstacle,task_node)
%%Wrapper function to do all perception and information update tasks.
%%Agents get their neighbour locations and validate to world boundaries.
%%Find agents around base station, which are in neighbouring cells and
%%which are within communication range.
%%Agents do environment perception for various sensing ranes and add 
%%perception to the environment and communication network graphs.

global numAgent  ;

for i = 1:numAgent
    agents(i) = get_neighbours(agents(i));
end

base = sense_base_neighbourhood(base, obstacle, agents);
agents = sense_agent_neighbourhood(base, obstacle, agents);
[agents base] = update_network(agents, base, obstacle);
[agents task_node] = update_task_information(agents, base, task_node);
[agents task_node] = exchangeInfo(agents, base, task_node);