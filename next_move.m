function [base, agents] = next_move(agent,base,agents,obstacle)

%this function makes the next move towards the target if the move is feasible.

%Receive from get_step_dijkstra the coordinates of the next step given the
%current targets using dijkstra. Now validate these points to network
%connectivity constraints.

%% Initializations

global comm_network NeighMat losMat numAgent aC_range aT_range;

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
        
        %if connected then new location checked for connectivity o/w skip
        %the check. State should not deteriorate. atleast as good as
        %current. This is important otherwise agent won't move when
        %disconnected.
        if agents(agent).is_connected == 100
            connectivity = 1;
        else
            connectivity = 0;
        end
        
        if connectivity == 0 && ismember(n_index,[base.c_neighbours{6,:}])
            connectivity = 1;
        end
        
        if connectivity == 0
            %     non zero check not needed now initialized with value 100 hops
            connAgents = find(agents(agent).agentConn);
            connAgents = connAgents((agents(agent).agentConn(connAgents) ~= 100));
            connAgents = connAgents((agents(agent).agentConn(connAgents) <= agents(agent).is_connected));

            temp  = connAgents;

            for j = 1:length(connAgents)
                if length(agents(agent).links{1,connAgents(j)}) == 2
                    continue;
                end
                
                if (agents(agent).agentConn(connAgents(j)) >= agents(agent).is_connected)
                    temp(j) = 0;
                elseif (agents(agent).links{1,connAgents(j)}(2) == agents(agent).bconnectPath(2))
                    temp(j) = 0;
                end
            end
            temp(temp ==0) =[];

            connAgents = temp;
            %         connAgentsEqual =  connAgents((agents(agent).agentConn(connAgents) == agents(agent).is_connected+1));
            %         for ind = 1:length(connAgentsEqual)
            %            if ~ismember(agents(connAgentsEqual(ind)).bconnectPath)
            %                connAgents = [connAgents connAgentsEqual(ind)];
            %            end
            %         end
            
            cAgentsIndex = agents(agent).agentIndices(connAgents);
            %         connection = zeros(1,length(cAgentsIndex));
            
            %supplemeting agent location information from that recieved
            %from base. Decide based on final decision.
            bCagents = agents(agent).bagentIndices;
            bCagents(bCagents == 0) = [];
            cAgentsIndex = [cAgentsIndex bCagents];
            for i = 1:length(cAgentsIndex)
                
                %             agentName = connAgents(i);
                agentIndex = cAgentsIndex(i);
                
%                 %this is the paper idea of considering worst move
%                 if ~ismember(agentIndex,get_neighbours_in_range(n_index,aC_range-aT_range))
%                     continue;
%                 end
                
                neighIndex = find(NeighMat(n_index,:)==agentIndex);
                                
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
    agents(agent).pathTrack = [agents(agent).pathTrack agents(agent).index];
else
    agents(agent).moved = 0;
    agents(agent).pathTrack = [agents(agent).pathTrack agents(agent).index];
end