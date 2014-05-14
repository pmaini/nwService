function agents = sense_agent_neighbourhood(base, obstacle, agents)
%%Sense agent neighbourhood for base, obstacles, other agents or in case of
%%an SA, tasks. This captures only agent sensing within the sensing
%%and transition range. Does not capture communication neighbourhood.
%%1. NULL check for both validity and occupancy(REDUNDANT)
%%2. Check for base. 3. Check for obstacles. 4. Check for other agents.
%%5. Check for Tasks.
global numAgent gridpoints_x gridpoints_y;

obs = struct([]);

for k = 1:numAgent
    
    agents(k).current_s_neighbour = agents(k).max_s_neighbour;
    % Lookout neighbouring locations of agents(within the sensing range)
    % First check for base, then for obstacles then for other agents
    
    for j = 1:agents(k).max_s_neighbour
        
        % Boundary conditions set validity and occupancy to NULL.
        if ( strcmp(agents(k).s_neighbours{3,j},'NULL') && strcmp(agents(k).s_neighbours{4,j} ,'NULL') )
            continue;
        end
        
        % check if the coordinates of this neighbour cell are inside the
        % base(overlapping): 0 code for base in a neighbour position
        if  ismember(agents(k).s_neighbours{6,j},base.indices)
            agents(k).s_neighbours{3,j} = 'NULL';
            agents(k).s_neighbours{4,j} = 0;
            agents(k).at_base = 1;
            agents(k).current_s_neighbour = agents(k).current_s_neighbour - 1;
            continue;
        end
        
        if ismember(agents(k).s_neighbours{6,j},[obstacle(:).index])
            % the idea of unreachable location is NULL is used for obstacle avoidance
            agents(k).s_neighbours{3,j} = 'NULL';
            agents(k).s_neighbours{4,j} = 'NULL';
            agents(k).obstacles = union(agents(k).obstacles,agents(k).s_neighbours{6,j});
            agents(k).current_s_neighbour = agents(k).current_s_neighbour - 1;
            continue;
        end
        
        if (strcmp(agents(k).s_neighbours{3,j},'NULL') == 0)
            agents(k).s_neighbours{4,j} = 'EMPTY';
            for i = 1:numAgent
                if (k == i)
                    continue;
                end
                % Find who if any body occupies the neighbour location
                if ((agents(k).s_neighbours{6,j} ==  agents(i).index))
                    agents(k).s_neighbours{4,j} = i;
                    break;
                end
            end
            
            if (strcmp(agents(k).s_neighbours{4,j},'EMPTY') == 1)
                
                % The check for tasks is placed within the check for an
                % empty cell because this check will decide whether or not
                % the agent can go into that cell or not. And it should go
                % into that cell only if it is empty, as other agents could
                % be there as they do not have "task" knowledge.
                
                % check if the task is in the neighbourhood, only for the
                % SA as others have no idea that there is a task
                if agents(k).task_assigned == 1
                    %A SA should be able to detect any task within its task
                    %queue. FEATURE TO BE ADDED
                    %                     tasks = find(agents(k).task);
                    if (agents(k).s_neighbours{6,j} == agents(k).target(1,3))
                        agents(k).s_neighbours{4,j} = ['task',num2str(agents(k).current_task)];
                    end
                end
            end
        end
    end
end

for k = 1:numAgent
    
    %%Adding all known obstacles(sensed and shared)
    for j = 1:length(agents(k).obstacles)
        obs(j).type = 'hard';
        obs(j).xc = gridpoints_x(agents(k).obstacles(j));
        obs(j).yc = gridpoints_y(agents(k).obstacles(j));
        obs(j).size = [1 1];
        obs(j).index = find_index(obs(j).xc,obs(j).yc);
        agents(k).view = update_graph(agents(k).view,obs(j),1);
    end
    
    % Populating the t_neighbour cell array is not necessary hence not done.
    for j = 1:agents(k).max_t_neighbour
        
         if ismember(agents(k).t_neighbours{6,j},[base.indices agents(k).obstacles])
            agents(k).t_neighbours{3,j} = 'NULL';
            agents(k).t_neighbours{4,j} = 'NULL';
%             agents(k).t_neighbours{6,j} = 0;
            continue;
         end
        
        % Lookout neighbouring locations of agents(within the transition range)
        % First check for other agents then free
        % spaces(ie. not in base---since that is what is left). Base is
        % already added to the graph.

        if ismember(agents(k).t_neighbours{6,j},[agents(setdiff(agents(k).agentsInRange,numAgent+1)).index])
            obs(j).type = 'soft';
            obs(j).dir = j; %1:from up,2:from right,3:from left,4:from bottom
            obs(j).xc = agents(k).t_neighbours{1,j};
            obs(j).yc = agents(k).t_neighbours{2,j};
            obs(j).size = [1 1];
            obs(j).index = agents(k).t_neighbours{6,j};
            agents(k).view = update_graph(agents(k).view,obs(j),1);
        elseif ismember(agents(k).t_neighbours{6,j},agents(k).agentsNextLocs)
            obs(j).type = 'collAvoid';
            obs(j).dir = j; %1:from up,2:from right,3:from left,4:from bottom
            obs(j).xc = agents(k).t_neighbours{1,j};
            obs(j).yc = agents(k).t_neighbours{2,j};
            obs(j).size = [1 1];
            obs(j).index = agents(k).t_neighbours{6,j};
            agents(k).view = update_graph(agents(k).view,obs(j),0);
        elseif ~ismember(agents(k).t_neighbours{6,j},[base.indices obstacle(:).index])
            obs(j).type = 'soft';
            obs(j).dir = j; %1:from up,2:from right,3:from left,4:from bottom
            obs(j).xc = agents(k).t_neighbours{1,j};
            obs(j).yc = agents(k).t_neighbours{2,j};
            obs(j).size = [1 1];
            obs(j).index = agents(k).t_neighbours{6,j};
            agents(k).view = update_graph(agents(k).view,obs(j),0);
        end
    end
end