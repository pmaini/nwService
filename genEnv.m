function genEnv()

global  numRows grid_type numColumns xmin ymin sim_cont numCells xmax ymax;
global task_counter max_tasks current_tasks time Total_obstacle_space;
global gridlocation index_for_UD gridpoints_x gridpoints_y numObstacle;
global numAgent numTask comm_network aC_range bC_range;
global size_x size_y size_g covered_fraction aS_range d_max env_graph;
global aT_range base_connected gridCells s_time losMat NeighMat maxTargets;

initEnvSim;

% Define base station
base = define_baseStationSim();

save([num2str(numRows) 'Environ']);