function agents = update_agents(base, agents, obstacle, tasks)
%%It calculates the target_location values for each node(before next_move makes the
%agent move towards that target_location). This function gives the logic for the same

%this function handles requests for follower, need_cover situations and
%also uniformly distributes the agents at base, around the base.

global numAgent numTask time;

%to track what positions in base neighbourhood have already been chosen as
%targets while returning to base. This is to avoid all agents trying to
%reach the same location

targets = zeros(1,base.max_c_neighbour);


agents = update_role_vector(agents);

agents = process_role_vector(agents, base, tasks);

% for i = 1:numAgent
%     
%     % Agent behavior while returning to base station after task service is complete
%     
%     if ((agents(i).in_relay == 1) && (agents(i).free == 1))
%             
%         % used for keeping track of minimum distance to base.
%         min = 1000;
%         
%         % base neighbour location at minimum distance
%         min_loc = 0;
%         
%         for base_loc = 1:base.max_c_neighbour
%             if targets(1,base_loc) ~= 0
%                 continue;
%             end
%             source_index = agents(i).index;
%             target_index = base.c_neighbours{6,base_loc};
%             [cost_to_base , ~, ~] = graphshortestpath(agents(i).view,source_index,target_index,'Directed',false);
%             if (cost_to_base < min)
%                 min = cost_to_base;
%                 min_loc = base_loc;
%             end
%         end
%         if min_loc > 0
%             targets(1,min_loc) = i;
%             agents(i).target = [base.neighbours{1,min_loc}, base.neighbours{2,min_loc}, base.neighbours{6,min_loc}];
%         end
%         
%         if (agents(i).at_base == 1)
%             agents(i).in_relay = 0;
%         end
%     elseif (agents(i).free == 0) && (agents(i).is_connected == 0)
%         agents(i).free = 1;
%         
%         if agents(i).current_task ~= 0
%             agents(i).task_assigned = 0;
%             agents(i).task = zeros(1,numTask);
%         end
%     end
% end