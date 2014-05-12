%% Strategies for base network constrained task servicing at multiple sites

%% Initializations

clear all;
close all;

global grid_type numRows numColumns xmin ymin env_graph numCells xmax ymax;
global numAgent numTask numObstacle sim_cont comm_network aC_range bC_range;
global task_counter max_tasks current_tasks time Total_obstacle_space;
global size_x size_y size_g gridpoints_x gridpoints_y covered_fraction;
global gridlocation gridCells s_time index_for_UD losMat cNeighMat maxTargets;

%0: square: coordinates at bottom left of the cell
%1: hexagon: coordinates at the center of the cell
grid_type = 0;% 1;%
numRows = 16;
numColumns = 16;
xmin = 0;
ymin = 0;
numAgent = 6;
numTask = 4;
numObstacle = 2;
aC_range = 2*sqrt(2);
bC_range = 2*sqrt(2);
maxTargets = 1;

[base, obstacle, agent_node, task_node] = create_world();%(filename);%

[base, agent_node, task_node] = setup_world(base, obstacle, agent_node, task_node);

[base, agent_node, task_node] = simulate_world(base, obstacle, agent_node, task_node);

%{
%     images(imgframe) = getframe;
%     imgframe = imgframe + 1;
% for x = xmin:1:xmax-0.5
%     for y = ymin:1:ymax-0.5
%         index = find_index(x,y);
%         plot = text(x,y+0.5,num2str(index));
%         set(plot,'FontSize',8,'FontName','FixedWidth');
%     end
% end

% save (['a',num2str(numAgent),'t',num2str(numTask),'l',num2str(task_limit)]);

% for i = 1:imgframe-1
%    [im, map] = frame2im(images(i));
%    name = ['plot',num2str(i),'.jpg'];
%    imwrite(im,name,'jpg');
% end

% movie2avi(images,'movie.avi','compression','Cinepak','fps',4);
%}