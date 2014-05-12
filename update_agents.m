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