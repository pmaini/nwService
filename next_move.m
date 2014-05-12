function [base, agents] = next_move(agent,base,agents,obstacle)

%this function makes the next move towards the target if the move is feasible.

%Receive from get_step_dijkstra the coordinates of the next step given the
%current targets using dijkstra. Now validate these points to network
%connectivity constraints.

%% Initializations

global comm_network cNeighMat losMat numAgent;

agents(agent).utility_vector = zeros(1,numAgent);
% %direction of movement
% dir = 'centre';

%% Calculate move

agents(agent).will_move = 1;


[x_next, y_next, got_move] = get_step_dikjstra(agents, agent);


if got_move == 0
    agents(agent).will_move = 0;
end

%% Calculate move feasibility

if (agents(agent).will_move == 1)
    
    n_index = find_index(x_next,y_next);
    
    %Check for the new position to be in translation range of the agent
    %considering all translation constraints (the constraints are already
    %included in the environment view(graph) of the agent)
    
    [~,path,~] = graphshortestpath(agents(agent).view,agents(agent).index,n_index);
    
    % by checking for length restrain movement to only adjacent cells.
    % checking length not cost because edge weights could differ
    
    if length(path) ~= 2
        agents(agent).will_move = 0;
    end
    
    if agents(agent).will_move ~= 0
        connectivity = 0;
        
        if ismember(n_index,[base.c_neighbours{6,:}])
            connectivity = 1;
        end
        
        if connectivity == 0
            %     non zero check not needed now initialized with value 100 hops
            connAgents = find(agents(agent).agentConn);
            connAgents = connAgents((agents(agent).agentConn(connAgents) ~= 100));
            connAgents = connAgents((agents(agent).agentConn(connAgents) < agents(agent).is_connected+1));            
            
            cAgentsIndex = agents(agent).agentIndices(connAgents);
            %         connection = zeros(1,length(cAgentsIndex));
            
            for i = 1:length(cAgentsIndex)
                
                %             agentName = connAgents(i);
                agentIndex = cAgentsIndex(i);
                neighIndex = find(cNeighMat(n_index,:)==agentIndex);
                
                if neighIndex ~= 0
                    connectivity = losMat(n_index,neighIndex);
                end
                if connectivity ~= 0
                    break;
                end
            end
        end
        
        if connectivity == 0
            agents(agent).will_move = 0;
        end
    end
end

if (agents(agent).will_move == 1)
    agents(agent).xc = x_next;
    agents(agent).yc = y_next;
    agents(agent).index = find_index(x_next,y_next);
    agents(agent).moved = 1;    
else
    agents(agent).moved = 0;
end