function addAgents2Env()
for i =1:10
    for j=8:4:24
        filename = ([ num2str(i) 'Sno20x20O36']);
        filename1 = ([filename 'c3s2t1' ]);
        load (filename1);
        numAgent = j;

        % Define agents
        agent_node = define_agentsSim(base, obstacle, graph);

        save([filename1 'a' num2str(numAgent)]);
        clearvars -except i j;
    end    
end

% close all;
% clear all;

for i =1:10
    for j=8:4:24
        for k=2:2:10
            filename = (['dataEnv\' num2str(i) 'Sno20x20O36']);
            filename1 = ([filename 'c3s2t1' ]);
            filename2 = ([filename1 'a' num2str(j) ]);

            load (filename2);
            numTask = k;

            % Define agents
            agent_node = define_agentsSim(base, obstacle, graph,filename2);
            
            % Task Node definition
            task_node = define_tasks(base, obstacle);

            save([filename2 't' num2str(numTask)]);
            clearvars -except i j k;
        end
    end
end


% % Define agents
% agent_node = define_agents(base, obstacle, graph);
% % Task Node definition
% task_node = define_tasks(base, obstacle, filename);