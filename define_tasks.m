function task_node = define_tasks(base, obstacle, filename)
%%Task node definition. Plot with task number. Generate non overlapping
%tasks within the world boundary, which also do not lie within base or
%obstacle cells.

global xmin xmax ymin ymax numTask;

task_node = struct([]);

if nargin == 3
    load(filename);
    for j = 1:numTask
        if mod(j,2) == 0
            task_node(j).plot(1) = plot(task_node(j).xc,task_node(j).yc,'hr','MarkerSize',16,'MarkerFaceColor','magenta');
        else
            task_node(j).plot(1) = plot(task_node(j).xc,task_node(j).yc,'hr','MarkerSize',16,'MarkerFaceColor','blue');
        end
        task_node(j).plot(2) = text(task_node(j).xc - 0.4,task_node(j).yc,num2str(j));
        set(task_node(j).plot(2),'FontSize',8,'FontName','FixedWidth');
    end
    return;
end

for j = 1:numTask
    task_node(j).type = 'task';
    task_node(j).name = ['task',num2str(j)];
    task_node(j).active = 0;
    
    task_node = generate_task(base, task_node, j, obstacle);
    
    task_node(j).size = [1,1];
    task_node(j).distance_from_base = abs(task_node(j).xc - ((xmax+xmin)/2)) + abs(task_node(j).yc - ((ymax+ymin)/2));
    
    %relative infinite value, actual value would be in number of steps,
    %calculated initially during task service and saved for record keeping
    task_node(j).distance_to_nearest_agent = 100;
    
    %relative infinite value, actual value would be in number of steps,
    %calculated dynamically, gives the current value.
    task_node(j).distance_to_service_agent = 100;
    
    % default 0 as new SA found, change!
    task_node(j).servicing_agent = 0 ;
    task_node(j).serviced = 0;
    task_node(j).service_time = 0;
    
    if mod(j,2) == 0
        task_node(j).plot(1) = plot(task_node(j).xc,task_node(j).yc,'hr','MarkerSize',16,'MarkerFaceColor','magenta');
    else
        task_node(j).plot(1) = plot(task_node(j).xc,task_node(j).yc,'hr','MarkerSize',16,'MarkerFaceColor','blue');
    end
    
    task_node(j).plot(2) = text(task_node(j).xc - 0.4,task_node(j).yc,num2str(j));
    set(task_node(j).plot(2),'FontSize',8,'FontName','FixedWidth');
end