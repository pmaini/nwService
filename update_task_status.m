function [tasks agents] = update_task_status(tasks,agents,base)
%%Update the task status ie. wind up old tasks and start new ones. Record
%%task service time. Assign new SAs to tasks whose SAs have given up. Keep
%%record of number of tasks active, serviced, max_simultaneous etc.

global numTask sim_cont current_tasks max_tasks env_graph;

max_tasks = max(max_tasks,current_tasks);
tasks_left = 0;

for task = 1:numTask    
    if tasks(task).active == 1         
        tasks(task).service_time = tasks(task).service_time + 1;
    end
    if tasks(task).serviced == 0
        tasks_left = tasks_left + 1;
    end        
end

if tasks_left == 0
    sim_cont = 0;
end
    

% if (task_counter < numTask)
%     feasible = check_feasible(agents,tasks(task_counter+1),base);
%     if (feasible==1)
%         tasks(task_counter + 1).active = 1;
%         task_counter = task_counter + 1;
%         current_tasks = current_tasks + 1;
%     end
% end