function task_node = generate_task(base, task_node, task, obstacle)
%%Generate task nodes which do not lie in any of the obstructd cells
% (base or obstacles). Also they should not overlap(mutually exclusive)

global  numCells gridpoints_x gridpoints_y ;%xmax xmin ymax ymin

valid_task = 0;
while ~(valid_task)
    
    new_rand = round(numCells*rand(1));
%     switch task
%         case 1
%             new_rand = 69;
%         case 2
%             new_rand = 76;
%         case 3
%             new_rand = 188;
%         case 4
%             new_rand = 181;
%     end
    if ~ismember(new_rand, base.indices)
        if ~ismember(new_rand, [obstacle(:).index])
            if xor((task == 1),((task > 1)&&(~ismember(new_rand, [task_node(1:task-1).index]))))
                valid_task = 1;
            end
        end
    end
    
    if new_rand == 0
        valid_task = 0;
    end
end

task_node(task).index = new_rand;
task_node(task).xc = gridpoints_x(new_rand);
task_node(task).yc = gridpoints_y(new_rand);
