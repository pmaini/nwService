function [agents task_node] = update_task_information(agents, base, task_node, obstacle)

global numAgent numTask current_tasks task_counter max_tasks

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
   if task_node(i).serviced == 1 && task_node(i).processed == 0
       task_node(i).active = 0;
       flag = 1;
       task_node(i).processed = 1;
   end
   if task_node(i).serviced == 0 && task_node(i).active == 0
       if flag == 1
           feasible = check_feasible(agents,tasks(task_counter+1),base,obstacle);
           if (feasible==1)
               task_node(i).active = 1;
               flag = 0;
               task_counter = task_counter + 1;
               current_tasks = current_tasks + 1;
               max_tasks = max(max_tasks,current_tasks);
           end
       end
   end
end