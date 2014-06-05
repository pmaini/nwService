function [base, obstacle] = create_worldSim(filename)
%%Initialize global variables. Create base station, obstacles, agents and
%%tasks. Make environment graph. Debugging made easy. Environment for every
%%run is saved. May be run again by calling create_world with filename as
%%argument.

global grid_type numRows numColumns xmin ymin env_graph numCells xmax ymax;
global numAgent numTask numObstacle sim_cont comm_network aC_range bC_range aT_range;
global task_counter max_tasks current_tasks time Total_obstacle_space d_max base_connected;
global size_x size_y size_g gridpoints_x gridpoints_y covered_fraction aS_range;
global gridlocation gridCells s_time index_for_UD losMat NeighMat maxTargets;

if nargin == 1
    
    load(filename,'numObstacle','Total_obstacle_space','covered_fraction');
    
    initEnvSim(filename);
    
    env_graph = make_graph();
    % view(biograph(env_graph,[],'ShowWeights','on','ShowArrows','off'));
    
    graph = env_graph;

    % Define base station
    base = define_baseStationSim(filename);

    % Add Obstacles
    obstacle = generate_obstacleSim(base,filename);
    
    % Los Data
    [losMat NeighMat] = getLosMatrix(base,obstacle);
    
%     % Define agents
%     agent_node = define_agentsSim(base, obstacle, graph);
%     
%     % Task Node definition    
%     task_node = define_tasks(base, obstacle);

    save([filename 'c' num2str(floor(aC_range/sqrt(2))) 's' num2str(floor(aS_range/sqrt(2))) 't' num2str(floor(aT_range/sqrt(2)))]);

end