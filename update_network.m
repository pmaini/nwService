function [agents base] = update_network(agents,base,obstacle)
%%Find obstacles, base and agents in c_range. Make graphical representation
%of the communication network formed. Update the agentsInRange and
%is_connected flag. The is_connected flag gives the number of hops to the
%base station.
global numAgent comm_network losMat NeighMat;

a = [];
b = [];

for k = 1:numAgent
    
    agents(k).current_c_neighbour = agents(k).max_c_neighbour;
    
    %Check for obstacles
    array_indices = find(ismember([agents(k).c_neighbours{6,:}],[obstacle(:).index]));
    for j = 1:length(array_indices)
        agents(k).c_neighbours{3,array_indices(j)} = 'NULL';
        agents(k).c_neighbours{4,array_indices(j)} = 'NULL';
        agents(k).current_c_neighbour = agents(k).current_c_neighbour - 1;
    end
    
    agents(k).is_connected = 100;
    agents(k).agentsInRange = [];
    agents(k).utility_vector = zeros(1,numAgent);
    
    %Check for base connectivity
    bconnectivity = isConnectionPossible(agents(k).xc,agents(k).yc,base.xpoly,base.ypoly,base,obstacle,base.c_range);
    if bconnectivity==1
        agents(k).agentsInRange =  numAgent+1;
        agents(k).is_connected = 1;
        agents(k).at_base = 1;
        array_indices = find(ismember([agents(k).c_neighbours{6,:}],base.indices));
        for j = 1:length(array_indices)
            agents(k).c_neighbours{3,array_indices(j)} = 'NULL';
            agents(k).c_neighbours{4,array_indices(j)} = 0;
            agents(k).current_c_neighbour = agents(k).current_c_neighbour - 1;
        end
    end
    
    %Check for connecitvity with other agents
    for i = 1:numAgent
        
        if i==k
            continue;
        end
        
        agentIndex = agents(i).index;
        neighIndex = find([NeighMat(agents(k).index,:,1)]==agentIndex);
        connectivity = 0;
        if neighIndex ~= 0
            connectivity = losMat(agents(k).index,neighIndex);
        end
%         connectivity = isConnectionPossible(agents(k).xc,agents(k).yc,agents(i).xc,agents(i).yc,base,obstacle,agents(k).c_range);
        
        if (connectivity == 1)
            if (~(ismember(i,agents(k).agentsInRange)))
                agents(k).agentsInRange = [agents(k).agentsInRange i];
                agents(k).c_neighbours{3,ismember([agents(k).c_neighbours{6,:}],agents(i).index)} = 'OK';
                agents(k).c_neighbours{4,ismember([agents(k).c_neighbours{6,:}],agents(i).index)} = i;
            end
        end
        
    end
end

%make graph: adjacency matrix
for k = 1:numAgent
    agents(k).agentsInRange = sort(agents(k).agentsInRange);
    numConn = numel(agents(k).agentsInRange);
    connections = k*ones(1,numConn);
    a = [a connections];
    b = [b agents(k).agentsInRange];
    
    if ismember(k,base.connected)
        a = [a numAgent+1];
        b = [b k];
    end
end

comm_network = sparse(a,b,1,numAgent+1,numAgent+1,((numAgent+1)^2));

%Find number of hops to base
for k = 1:numAgent
    [cost,path,~] = graphshortestpath(comm_network,k,numAgent+1);
    if (cost ~= Inf)&&(numel(path)>1)
        agents(k).is_connected = length(path)-1;%cost;
        agents(k).bconnectPath = path;
    end
end