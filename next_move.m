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
            connAgents = connAgents((agents(agent).agentConn(connAgents) <= agents(agent).is_connected+1));            
            
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
            
            %         %Agents giving connectivity at the new location
            %         newAgentConn = find(connection);
            %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %         %%%%%% Set utility vector
            %         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %         agents(agent).utility_vector(connAgents) = 0.25;
            %         agents(agent).utility_vector(newAgentConn) = ones(1,length(newAgentConn));
            %         connectivity = sum(connection(connection~=0));
        end
        
        if connectivity == 0
            agents(agent).will_move = 0;
        end
        
        %     % because when its free and its in_relay the movement is not constrained
        %     % the agent in that condition would be returning home
        %     if ~((agents(agent).in_relay == 1) && (agents(agent).free == 1))
        %
        %         if (agents(agent).follower == 0)
        % %             covered = isConnectionPossible(base.xpoly,base.ypoly,x_current,y_current,base,obstacle,2*sqrt(2));
        %             covered = ismember(agents(agent).index,base_connected);
        %             if (covered == 0)%new location not in base vicinity
        %
        %                 if(agents(agent).free == 0)%agent can request for a follower only if it is going out for work
        %                     agents(agent).request_follower = [1 x_current y_current];
        %                     agents(agent).will_move = 0;
        %                 end
        %             end
        %
        %         elseif(agents(agent).follower ~= 0)% has a follower
        %
        % % hence would be coming back from the field, so would come in the vicinity
        % % first then immediate neighbourhood of the base. When in vicinity relieve
        % % the follower, if in next move comes to immediate neighbourhood, first
        % % condition will take care(without follower)
        %             covered = isConnectionPossible(base.xpoly,base.ypoly,x_current,y_current,base,obstacle,2*sqrt(2));
        %
        %             if covered == 1%new location covered by the base, so let go of the follower
        %
        %                agents(agents(agent).follower).leader = 0;
        %                agents(agents(agent).follower).free = 1;
        %                agents(agent).follower = 0;
        %
        %             elseif (covered == 0)% new location not covered by the base
        %                 covered = isConnectionPossible(x_current,y_current,agents(agents(agent).follower).xc, agents(agents(agent).follower).yc,base,obstacle,2*sqrt(2));
        %
        %                 if (covered == 0)%new location outside base not covered by follower
        %
        %                     agents(agent).will_move = 0;
        %                     agents(agent).need_cover = [1 x_current y_current];
        %
        %                 end
        %             end
        %         end
        %     end
    end
end

if (agents(agent).will_move == 1)
    agents(agent).xc = x_next;
    agents(agent).yc = y_next;
    agents(agent).index = find_index(x_next,y_next);
    agents(agent).moved = 1;
    %     agents(agent).new_loc = dir;
    
    % %will_move is zero, try checking the value of moved flag
    % elseif ((agents(agent).free == 0) || (agents(agent).in_relay == 1)) && (strcmp(dir,'centre')==0)
    % % Capture the condition when it will not move even though it wanted to.
    % % If its stuck, in the 2nd iteration itself the dir will start coming out to
    % % be centre, hence did not move time recorded only for those which wanted to move
    %     agents(agent).moved = agents(agent).moved + 1;
    %     agents(agent).new_loc = dir;
    
else
    agents(agent).moved = 0;
end