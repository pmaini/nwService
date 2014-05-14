function agents = process_role_vector(agents, base, tasks)
%%set various flags based upon the updated role_vector. Populate targets
%%for every agent

global numAgent gridpoints_x gridpoints_y gridCells;

for i = 1:numAgent
    
   agents(i).old_targets = agents(i).targets;
   [agents(i).targets.valid] = deal(0);
   agents(i).n_factor = 0;
   
   if agents(i).is_connected == 100
       agIndices = [agents(i).s_neighbours{6,:}];
       agIndices(agIndices==0) = [];
       agLevels = [gridCells(agIndices).bNeighL];
       minAgL = min(agLevels);
       minAgIndices = agIndices(agLevels == minAgL);
       dist = 100;
       for j = 1:length(minAgIndices)
          [dist1,~,~] = graphshortestpath(agents(i).view,agents(i).index,minAgIndices(j));
          if dist1 <= dist
              dist = dist1;
              tarLoc = minAgIndices(j);
          end
       end
       agents(i).targets(1).valid = 1;
       agents(i).targets(1).type = 'toBase';
       agents(i).targets(1).goal = numAgent+1;
       agents(i).targets(1).xc = gridpoints_x(tarLoc);
       agents(i).targets(1).yc = gridpoints_y(tarLoc);
       agents(i).targets(1).index = tarLoc;
       agents(i).targets(1).distance_to_target = dist;
       agents(i).targets(1).weight = 1;
       agents(i).n_factor = agents(i).targets(1).weight;
   
      %%change behavior to maintain network connectivity 
   else
   
       num_targets = length(find(agents(i).role_vector));

       leader = find(agents(i).role_vector == 1);
       relayTasks = find(agents(i).role_vector == 2);
       relays = agents(i).relay_vector(relayTasks);


       if num_targets ~= length(leader) + length(relays)
          %if the role_vector is only limited to 0,1,2 values, write error
          %handling code here when num_targets ~= leader+relays
       end

       for j = 1:length(leader)
           agents(i).targets(j).valid = 1;
           agents(i).targets(j).type = 'leader';
           agents(i).targets(j).goal = leader(j);
           agents(i).targets(j).xc = tasks(leader(j)).xc;
           agents(i).targets(j).yc = tasks(leader(j)).yc;
           agents(i).targets(j).index = tasks(leader(j)).index;
           agents(i).targets(j).distance_to_target = agents(i).leader_cost_vector(leader);
           if (agents(i).targets(j).distance_to_target==0)
               agents(i).targets(j).weight = 1;
           else
               agents(i).targets(j).weight = 1/agents(i).targets(j).distance_to_target;%50;
           end
           agents(i).n_factor = agents(i).n_factor + agents(i).targets(j).weight;
       end
       for j = 1:length(relays)
           agents(i).targets(length(leader)+j).valid = 1;
           agents(i).targets(length(leader)+j).type = 'relay';
           agents(i).targets(length(leader)+j).goal = relays(j);
           agents(i).targets(length(leader)+j).xc = agents(relays(j)).xc;
           agents(i).targets(length(leader)+j).yc = agents(relays(j)).yc;
           agents(i).targets(length(leader)+j).index = agents(relays(j)).index;
           agents(i).targets(length(leader)+j).distance_to_target = agents(i).cost_to_relay_vector(relayTasks(j));

           if (agents(i).targets(length(leader)+j).distance_to_target == 0)
               agents(i).targets(length(leader)+j).weight = 1;
           else
               agents(i).targets(length(leader)+j).weight = 1/agents(i).targets(length(leader)+j).distance_to_target;%20;
           end
           agents(i).n_factor = agents(i).n_factor + agents(i).targets(length(leader)+j).weight;
       end
    %    targets = agents(i).max_targets;
    %    agents(i).targets(targets+1).valid = 1;
    %    agents(i).targets(targets+1).type = 'bConnect';
    %    agents(i).targets(targets+1).goal = numAgent+1;
    %    agents(i).targets(targets+1).xc = base.xc - 1;
    %    agents(i).targets(targets+1).yc = base.yc - 1;
    %    agents(i).targets(targets+1).index = find_index(agents(i).targets(targets+1).xc,agents(i).targets(targets+1).yc);
    %    agents(i).targets(targets+1).distance_to_target = graphshortestpath(agents(i).view,agents(i).index,agents(i).targets(targets+1).index);
    %    agents(i).targets(targets+1).weight = 75 - agents(i).n_factor;
    %    agents(i).n_factor = 75;
    end
end