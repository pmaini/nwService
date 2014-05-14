function [agents, task_node] = exchangeInfo(agents,base,task_node)

global numAgent numTask

information = struct([]);
baseinfo = struct([]);

%%Share Info amongst agents
for i = 1:numAgent
    
    %numAgent+1 is code for base station, so removing it
    nodes = setdiff(agents(i).agentsInRange,numAgent+1);
   
    information(i).node = nodes;
    information(i).obs = unique([agents(nodes).obstacles]);
    information(i).next_locs_agent = struct([]);
    information(i).next_locs = [];
    information(i).cost_vector = 99*ones(length(nodes),numTask);
    information(i).task_status = zeros(1,numTask);
    information(i).role_vector = zeros(length(nodes),numTask);
    information(i).base_connection = 100*ones(1,numAgent);
    information(i).agentIndex = zeros(1,numAgent);    
    information(i).myUtility = zeros(1,numAgent);
    information(i).links = cell(1,numAgent);

    
    for j = 1:length(nodes)
        information(i).next_locs_agent(j).locs  = [agents(nodes(j)).t_neighbours{6,:}];
        information(i).cost_vector(j,:) = agents(nodes(j)).cost_vector;
        information(i).task_status = max(information(i).task_status,agents(nodes(j)).task_status);
        information(i).role_vector(j,:) = agents(nodes(j)).role_vector;
        information(i).base_connection(nodes(j)) = agents(nodes(j)).is_connected;       
        information(i).agentIndex(nodes(j)) = agents(nodes(j)).index;
        information(i).links{1,nodes(j)} = agents(nodes(j)).bconnectPath;        
%         information(i).myUtility(nodes(j)) = agents(nodes(j)).utility(i);
    end
    
    if ismember(numAgent+1,agents(i).agentsInRange)
        serviced = find(agents(i).task_status == 2);
        if ~isempty(serviced)
            for sIndex = 1:length(serviced)
                task_node(serviced(sIndex)).serviced = 1;     
            end           
        end
        baseinfo(i).task_status = max((2*[task_node(:).serviced]),[task_node(:).active]);
        baseinfo(i).agentIndex = zeros(1,numAgent);
        for ind = 1:length(base.connected)
            baseinfo(i).agentIndex(base.connected(ind)) = agents(base.connected(ind)).index;
        end
    end
    
    if ~isempty(nodes)
        information(i).next_locs = [information(i).next_locs_agent(:).locs];
    end
end

for i = 1:numAgent
    
    agents(i).obstacles = union(agents(i).obstacles,information(i).obs);
    agents(i).agentsNextLocs = information(i).next_locs;
    agents(i).leader_cost_vector = agents(i).cost_vector;
    agents(i).leader_vector = i*ones(1,numTask);
    agents(i).relay_cost_vector = 100*ones(1,numTask);
    agents(i).cost_to_relay_vector = 100*ones(1,numTask);
    agents(i).relay_vector = zeros(1,numTask);
    agents(i).task_status = max(agents(i).task_status,information(i).task_status);
    agents(i).agentConn = information(i).base_connection;
    agents(i).agentIndices = information(i).agentIndex;
    agents(i).links = information(i).links;
    
    for j = 1:numTask
        
        if agents(i).task_status(j) ~= 1
            continue;
        end
        
        task_vector = information(i).cost_vector(:,j);
        CandIndex = find(task_vector<agents(i).leader_cost_vector(j));
        CandCost = [];
        relayCandIndex = find(task_vector<=agents(i).leader_cost_vector(j));
        if ~isempty(CandIndex)
            CandCost = task_vector(CandIndex);
            leaderIndex = find(CandCost == min(CandCost),1);
            leader_s = CandIndex(leaderIndex);        
            leader = information(i).node(leader_s);
            leader_cost = task_vector(leader_s);
            
%             if cost equal lower indexed agent becomes the leader
        elseif isempty(CandIndex)
            CandIndex = find(task_vector==agents(i).leader_cost_vector(j));
            leader_s = information(i).node(CandIndex);
            leader = min([leader_s i]);
            leader_cost = agents(i).leader_cost_vector(j);
        end
        
%         %become relay to an agent only if it is atleast involved in the
%         %service of the task under consideration
%         for k = 1:length(CandIndex)
%             rAgent = information(i).node(CandIndex(k));
%             rAgent_role =  information(i).role_vector(rAgent,j);
%             if rAgent_role == 0
%                 CandIndex(k) = [];                
%             end            
%         end        

        %use max to find the nearest candidate
        relayIndex = find(CandCost == max(CandCost),1);
        relay_s = relayCandIndex(relayIndex);
        relay = information(i).node(relay_s);
        relay_cost = task_vector(relay_s);
        [cost_to_relay,~,~] = graphshortestpath(agents(i).view, agents(i).index,agents(relay).index);
        num_cand = length(relayCandIndex);        
        
        if ~isempty(leader)
            agents(i).leader_cost_vector(j) = leader_cost;
            agents(i).leader_vector(j) = leader;
        end
        
        if ~isempty(relay)
            agents(i).relay_cost_vector(j) = relay_cost;
            agents(i).relay_vector(j) = relay;
            agents(i).cost_to_relay_vector(j) = cost_to_relay;
            agents(i).num_relay_cand(j) = num_cand;
        end
        
    end
    
    if ismember(numAgent+1,agents(i).agentsInRange)
        agents(i).task_status = max(agents(i).task_status,baseinfo(i).task_status);
        agents(i).agentIndices = max(agents(i).agentIndices,baseinfo(i).agentIndex);
    end
end