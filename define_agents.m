function agent_node = define_agents(base, obstacle, graph, filename)
%%Define agent nodes. Initialize. Give them locations(uniformly) around the
%%base station. Give world graph with only base added(no obstacles detected)
%%Plot with their agent numbers.

global numAgent index_for_UD numTask gridpoints_x gridpoints_y aC_range maxTargets;

agent_node = struct([]);

if nargin == 4
    load(filename);
    for i = 1:numAgent        
        %Plot, label and font properties
        agent_node(i).plot(1) = plot(agent_node(i).xc,agent_node(i).yc,'mo','MarkerFaceColor','yellow','MarkerSize',10,'DisplayName',num2str(i));
        agent_node(i).plot(2) = text(agent_node(i).xc - 0.3 ,agent_node(i).yc,num2str(i));
        set(agent_node(i).plot(2),'FontSize',8,'FontName','FixedWidth');
    end
    return;
end

loc_options = setdiff(setdiff([base.c_neighbours{6,:}],[obstacle(:).index]),0);

for i = 1:numAgent
    
    agent_node(i).type = 'agent';
    agent_node(i).name = i;
    agent_node(i).size = [1,1];
    
    location_finder = ceil(rand()*length(loc_options));
    location = loc_options(location_finder);
    loc_options(location_finder) = [];
%    switch i
%         case 1
%             location = 103;
%         case 2
%             location = 106;
%         case 3
%             location = 154;
%         case 4
%             location = 151;
%     end
    tempx = gridpoints_x(location);
    tempy = gridpoints_y(location);
    
    agent_node(i).xc = tempx;
    agent_node(i).yc = tempy;
    agent_node(i).index = find_index(agent_node(i).xc,agent_node(i).yc);
    
    %typically c_range > s_range > t_range
    agent_node(i).c_range = aC_range;
    agent_node(i).s_range = sqrt(2);
    agent_node(i).t_range = 1;
    
    %maximum number of valid neighbouring locations possible(found here to allocate memory in next step)
    agent_node(i).max_c_neighbour = length(get_neighbours_in_range(agent_node(i).index,agent_node(i).c_range));
    agent_node(i).max_s_neighbour = length(get_neighbours_in_range(agent_node(i).index,agent_node(i).s_range));
    agent_node(i).max_t_neighbour = length(get_neighbours_in_range(agent_node(i).index,agent_node(i).t_range));
      
    %1st row for xc, 2nd for yc, 3rd for valid neighbour, 
    %4th for who occupies it!, 5th for the plot handle, 6 for index
    agent_node(i).c_neighbours = cell(6,agent_node(i).max_c_neighbour);
    agent_node(i).s_neighbours = cell(6,agent_node(i).max_s_neighbour);
    agent_node(i).t_neighbours = cell(6,agent_node(i).max_t_neighbour);  
    
    %number of locations currently valid
    agent_node(i).current_c_neighbour_number = agent_node(i).max_c_neighbour;
    agent_node(i).current_s_neighbour_number = agent_node(i).max_s_neighbour;
    agent_node(i).current_t_neighbour_number = agent_node(i).max_t_neighbour;
    
    %agents in commnunication range
    agent_node(i).agentsInRange = [];
    agent_node(i).oldAgentsInRange = [numAgent+1];    
    
    %next possible locations of agents in range(allows agents to be heterogenous)
    agent_node(i).agentsNextLocs = [];
    
    %obstacles known
    agent_node(i).obstacles = [];
        
    agent_node(i).leader = 0;
    agent_node(i).follower = 0;
    
    %number,xc,yc,index of targets
    agent_node(i).max_targets = maxTargets;
    agent_node(i).targets(1:agent_node(i).max_targets+1) = struct('valid',0,'type','NULL','xc',0,'yc',0,'index',0,'distance_to_target',0,'weight',0);
    agent_node(i).old_targets = agent_node(i).targets;
    agent_node(i).n_factor = sum([agent_node(i).targets(:).weight]);
    
    %flags
    agent_node(i).at_base = 1;
    
    %flag set if there is movement in an iteration, can be used to detect
    %whether or not there it moved
    agent_node(i).will_move = 0;
    
    %how much time has elapsed since I wanted but could not move.
    agent_node(i).moved = 0;
    
    %where am i from my last location
    agent_node(i).new_loc = 0;
    
    %Number of hops initialized with relative infinity
    agent_node(i).is_connected = 100;
    agent_node(i).bconnectpath = [i numAgent+1];
    agent_node(i).links = cell(1,numAgent);
    
    %involvement with a task service(as SA or as RA)
    agent_node(i).free = 1;
    
    %busy as RA, may or may not be involved with task service
    agent_node(i).in_relay = 0;
    agent_node(i).task_assigned = 0;
    
    %0: unprocessed, 1: active, being processed, 2: serviced, processed
    agent_node(i).task_status = zeros(1,numTask);
    agent_node(i).oldTask_status = ones(1,numTask);
    
    agent_node(i).current_task = 0;
    agent_node(i).cost_vector = 100*ones(1,numTask);
    
    %0: not concerned,1: SA, 2: RA, 3: I coudn't service you, find a new SA
    agent_node(i).role_vector = zeros(1,numTask);
    agent_node(i).utility_vector = zeros(1,numAgent);
    agent_node(i).old_role_vector = zeros(1,numTask);
    agent_node(i).leader_cost_vector = 100*ones(1,numTask);
    agent_node(i).leader_vector = i*ones(1,numTask);
    agent_node(i).relay_cost_vector = 0*ones(1,numTask);
    agent_node(i).relay_vector = zeros(1,numTask);
    agent_node(i).cost_to_relay_vector = 0*ones(1,numTask);
    agent_node(i).num_relay_cand = zeros(1,numTask);
    
    %100: relative infinity, manhattan distance to the current task
    agent_node(i).distance_to_task = 100;
    agent_node(i).request_follower = [0 0 0];
    agent_node(i).need_cover = [0 0 0];
    agent_node(i).give_cover = [0 0];
    
    %set flags if at boundary
    agent_node(i).at_rxwall = 0;               %read at right  x-axis wall
    agent_node(i).at_lxwall = 0;               %read at left   x-axis wall
    agent_node(i).at_tywall = 0;               %read at top    y-axis wall
    agent_node(i).at_bywall = 0;               %read at bottom y-axis wall
    
    agent_node(i) = get_neighbours(agent_node(i));

    %enviro-view
    agent_node(i).view = graph;
    agent_node(i).path = 0;
    
    %Plot, label and font properties
    agent_node(i).plot(1) = plot(agent_node(i).xc,agent_node(i).yc,'mo','MarkerFaceColor','yellow','MarkerSize',10,'DisplayName',num2str(i));
    agent_node(i).plot(2) = text(agent_node(i).xc - 0.3 ,agent_node(i).yc,num2str(i));
    set(agent_node(i).plot(2),'FontSize',8,'FontName','FixedWidth');
end
index_for_UD = 0;