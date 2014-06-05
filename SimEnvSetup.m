%% Strategies for base network constrained task servicing at multiple sites

%% Initializations

clear all;
close all;

global grid_type numRows numColumns xmin ymin numObstacle;

%0: square: coordinates at bottom left of the cell
grid_type = 0;
numRows = 8;
numColumns = 8;
xmin = 0;
ymin = 0;
genEnv();
numObstacle = 6;
genEnvs();