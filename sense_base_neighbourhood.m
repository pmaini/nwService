function base = sense_base_neighbourhood(base, obstacle, agents)
%%Sense base neighbourhood for agents. For the base to detect who all are
%%at the base ie. agents within communication range of the base to be
%%base.connected.

% First initializes base.c_neighbours{4,} to 'EMPTY'
% and then populates it to agent names

global numAgent ;

base.connected = [];

% Do not initialize the c_neighbours{3,:} and c_neighbours{4,:}. They are
% being initialized in get_neighbours function
   
for j = 1:base.max_c_neighbour
    if (strcmp(base.c_neighbours{3,j},'NULL') == 0)
        base.c_neighbours{4,j} = 'EMPTY';
        for i = 1:numAgent
            if (base.c_neighbours{6,j} ==  agents(i).index)                
                connected = isConnectionPossible(agents(i).xc,agents(i).yc,base.xpoly,base.ypoly,base,obstacle,base.c_range);
                if (connected == 1)
                    base.c_neighbours{4,j} = i;
                    base.connected = [base.connected i];
                end
                break;
            end
        end
    end
end
