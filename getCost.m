function agents = getCost(agents, agent, tasks)
%Computes the cost 'agent' will incur to go to each of the currently active
%task locations

global numTask

a_index = agents(agent).index;

for i = 1:numTask
    if (agents(agent).task_status(i) == 1)
        t_index = tasks(i).index;
        [distance,path,~] = graphshortestpath(agents(agent).view,a_index,t_index,'Directed',true);
        agents(agent).cost_vector(i) = length(path);%distance;%
    end
end