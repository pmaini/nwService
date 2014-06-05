function genEnvs()

global numRows grid_type numColumns xmin ymin sim_cont numCells xmax ymax;
global task_counter max_tasks current_tasks time Total_obstacle_space numObstacle;
global gridlocation index_for_UD gridpoints_x gridpoints_y covered_fraction;
global numAgent numTask comm_network aC_range bC_range;
global size_x size_y size_g aS_range d_max env_graph maxTargets;
global aT_range base_connected gridCells s_time losMat NeighMat;

for i= 1:20
    load('20Environ');
    numObstacle = 36;
    
    filename = [ num2str(i) 'Sno' num2str(numRows) 'x' ...
    num2str(numColumns) 'O' num2str(numObstacle)];

    % Add Obstacles
    obstacle = generate_obstacleSim(base);

    save(filename);

    clear all;
end