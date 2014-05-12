function [agents task_node] = update_task_information(agents, base, task_node)

global numAgent numTask

for i = 1:numAgent
    if agents(i).is_connected == 100
        continue;
    end
   leader = find(agents(i).role_vector == 1);
   if ~isempty(leader)
      if agents(i).index == task_node(leader).index
         agents(i).task_status(leader) = 2; 
      end
   end    
end

flag = 0;
for i = 1:numTask
   if task_node(i).serviced == 1
       task_node(i).active = 0;
       flag = 1;
   end
   if task_node(i).serviced == 0 && task_node(i).active == 0
       if flag == 1
           task_node(i).active = 1;
           flag = 0;
       end
   end
end