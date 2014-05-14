function agents = update_role_vector(agents)
%update the role vector with SA and RA assignments:
%1 - Service Agent
%2 - Relay Agent

global numAgent numTask;

for i = 1:numAgent 
    nodes = setdiff(agents(i).agentsInRange,numAgent+1);
    
    agents(i).old_role_vector = agents(i).role_vector;
    agents(i).oldAgentsInRange = agents(i).agentsInRange;
    agents(i).oldTask_status = agents(i).task_status;
    agents(i).task_assigned = 0;
    agents(i).in_relay = 0;
    
    agents(i).role_vector = zeros(1,numTask);
    num_targets = agents(i).max_targets;
    
    %constraint 1: active task
    active_tasks = find(agents(i).task_status == 1);
    
    %constraint 2(1): leader and relay candidates for active tasks
    leaderCand = active_tasks(agents(i).leader_vector(active_tasks) == i);
    active_relayCand = active_tasks(agents(i).relay_vector(active_tasks) ~= i);
    relayCand = active_relayCand(agents(i).relay_vector(active_relayCand) ~= 0);
    %only those tasks are relay candidates for which there are less than 3
    %eligible agent candidates in local neighbourhood
    relayCand = relayCand(agents(i).num_relay_cand(relayCand) < 3);
        
    leader = [];
    
%     if (numAgent == 1) || (~isempty(nodes))
        %constraint 3: find minimum costing SA assignment
        leaderCandCost = agents(i).leader_cost_vector(leaderCand);
        leaderCost = min(leaderCandCost);
        leaderIndex = find(leaderCandCost == leaderCost,1);
        leader = leaderCand(leaderIndex);
%     end
    
    if ~isempty(leader)
        
        %Currently the planned strategy is: an agent should be the leader for a
        %single task, however it can be a relay agent for multiple tasks, even
        %if it is the service agent of another task. 
        agents(i).role_vector(leader) = 1;

        num_targets =  num_targets - 1;
    end
    
    
    %The number of tasks for which an agent is a relay task has to
    %have a boundation either in absolute numbers or on the nearness of
    %tasks. Implementation of this is yet to be figured out.        
    relayCandCost = agents(i).cost_to_relay_vector(relayCand)+agents(i).relay_cost_vector(relayCand);
    
    index = 1;
    
    while (num_targets > 0)
    
        %relay only when there are agents in neighbouhood worthy of being a
        %leader.
       if (index > length(relayCand))
           break;
       end
       
       relayCost = min(relayCandCost);
       relayIndex = find(relayCandCost == relayCost, 1);
       relay = relayCand(relayIndex);
      
       if ~isempty(relay)
           index = index + 1;
           num_targets = num_targets - 1;
       end
       
       agents(i).role_vector(relay) = 2;
       relayCandCost(relayIndex) = 101;
       
    end
    if sum(agents(i).role_vector == 1)
       agents(i).task_assigned = sum(agents(i).role_vector == 1);
    end
    if sum(agents(i).role_vector == 2)
       agents(i).in_relay = sum(agents(i).role_vector == 2);
    end
end