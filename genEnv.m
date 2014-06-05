function genEnv()

global grid_type numRows numColumns xmin ymin env_graph numCells xmax ymax;
global numAgent numTask numObstacle sim_cont comm_network aC_range bC_range aT_range;
global task_counter max_tasks current_tasks time Total_obstacle_space d_max;
global size_x size_y size_g gridpoints_x gridpoints_y covered_fraction aS_range;
global gridlocation gridCells s_time index_for_UD losMat cNeighMat maxTargets;

    initEnv;

    env_graph = make_graph();
    % view(biograph(env_graph,[],'ShowWeights','on','ShowArrows','off'));
    
    % Define base station
    base = define_baseStation();
    
    graph = env_graph;
    
    save([num2str(numRows) 'Env']);
    save([num2str(numRows) 'EnvGraph'],'graph');
