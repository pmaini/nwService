function agent_node = refresh_agent_plot(agent_node)
%updates the agent plots and also gives them their importance value
%3: SA, 4: RA, 2: free in relay, 1: free at base

global numAgent;

%% step 1: delete old plots
for i = 1:numAgent
  delete(agent_node(i).plot);
end

%% step 2: make new agent plots
for i = 1:numAgent
    
    if(agent_node(i).task_assigned > 0)
%         if mod(agent_node(i).current_task,2) == 0
            agent_node(i).plot(1) = plot(agent_node(i).xc,agent_node(i).yc,'mo','MarkerFaceColor','blue','MarkerSize',10);
            agent_node(i).plot(2) = text(agent_node(i).xc - 0.3,agent_node(i).yc,[num2str(i) '-T' num2str(find(agent_node(i).role_vector==1))]);
%         else
%             agent_node(i).plot(1) = plot(agent_node(i).xc,agent_node(i).yc,'mo','MarkerFaceColor','blue','MarkerSize',10);
%         end
%         
%     elseif (agent_node(i).free == 0)
%         agent_node(i).plot(1) = plot(agent_node(i).xc,agent_node(i).yc,'mo','MarkerFaceColor','green','MarkerSize',10);
%         
    elseif (agent_node(i).in_relay > 0)
        agent_node(i).plot(1) = plot(agent_node(i).xc,agent_node(i).yc,'mo','MarkerFaceColor','green','MarkerSize',10);
        agent_node(i).plot(2) = text(agent_node(i).xc - 0.3,agent_node(i).yc,num2str(i));
    else
        agent_node(i).plot(1) = plot(agent_node(i).xc,agent_node(i).yc,'mo','MarkerFaceColor','yellow','MarkerSize',10);
        agent_node(i).plot(2) = text(agent_node(i).xc - 0.3,agent_node(i).yc,num2str(i));
        
    end
    set(agent_node(i).plot(2),'FontSize',8,'FontName','FixedWidth');
    

    
end