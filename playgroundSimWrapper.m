
close all;
clear all;

global grid_type numRows numColumns xmin ymin env_graph numCells xmax ymax;
global numAgent numTask numObstacle sim_cont comm_network aC_range bC_range aT_range;
global task_counter max_tasks current_tasks time Total_obstacle_space d_max;
global size_x size_y size_g gridpoints_x gridpoints_y covered_fraction aS_range;
global gridlocation gridCells s_time index_for_UD losMat NeighMat maxTargets;


for i =1:20
    for j=8:4:24
        for k=2:2:10
            path = 'dataEnv\';
            filename = ([ num2str(i) 'Sno20x20O36']);
            filename1 = ([filename 'c3s2t1' ]);
            filename2 = ([filename1 'a' num2str(j) 't' num2str(k) ]);
            fullpath = [path filename2];
            playgroundSim(fullpath);
        end
    end
end
