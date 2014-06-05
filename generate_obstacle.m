function obstacle  = generate_obstacle(base,filename)
%%Generate obstacles which are non overlapping with each other and the base
%%station, within the world boundary. Plot. Add to environment graph. Record total
%%obstructed space. No neighbour field, since not needed.

global numObstacle xmax xmin ymax ymin env_graph Total_obstacle_space;
global numCells covered_fraction;

obstacle = struct([]);

%0:custom, 1:random
if nargin == 2
    load(filename);
    for i = 1:numObstacle
        obstacle(i).plot = rectangle('Position',[obstacle(i).xc,obstacle(i).yc,obstacle(i).size(1),obstacle(i).size(2)],'FaceColor','black');
    end
    return;
end

for i=1:numObstacle
    
    obstacle(i).size = [1 1];
    
    buffer = 1;%max(obstacle(i).size(1),obstacle(i).size(2));
    
    %to check the obstacle is new. Does not overlap with previously
    %generated ones.
    is_new = 0;
    
    while (is_new ~= 1)
        x_rand = (xmin) + round(((xmax-xmin)-buffer)*rand());
        
        if (x_rand < (((xmax+xmin)/2)-(base.size(1)/2)-buffer))%mind it is strictly less than
            y_rand = (ymin) + round(((ymax-ymin)-buffer)*rand());  % y_rand = (ymin) + round(((ymax-ymin)-buffer)*rand());
        elseif (x_rand < (((xmax+xmin)/2)+(base.size(1)/2)+buffer))
            y_rand_1 = round(rand());
            if y_rand_1 == 0
                y_rand = (ymin) + round((((ymax-ymin)/2)-(base.size(2)/2)-2*buffer)*rand());
            else
                y_rand = (((ymax + ymin)/2)+(base.size(2)/2)+buffer) + round((((ymax-ymin)/2)-(base.size(2)/2)-2*buffer)*rand());
            end
        elseif (x_rand <= (((xmax+xmin)/2)+((xmax-xmin)/2)-buffer))
            y_rand = (ymin) + round(((ymax-ymin)-buffer)*rand());
        end
        
        
        obstacle(i).xc = x_rand;
        obstacle(i).yc = y_rand;
        
        
        obstacle(i).index =  find_index(obstacle(i).xc,obstacle(i).yc);
        if xor((i==1),((i > 1) && ~ismember(obstacle(i).index,[obstacle(1:i-1).index])))
            is_new = 1;
        end
    end
    
    obstacle(i).xpoly = [obstacle(i).xc obstacle(i).xc+obstacle(i).size(1) obstacle(i).xc+obstacle(i).size(1) obstacle(i).xc obstacle(i).xc];
    obstacle(i).ypoly = [obstacle(i).yc obstacle(i).yc obstacle(i).yc+obstacle(i).size(2) obstacle(i).yc+obstacle(i).size(2) obstacle(i).yc];
    obstacle(i).name = ['o' num2str(i)];
    
    obstacle(i).dir = 0;
    obstacle(i).type = 'hard';
    obstacle(i).space = ((obstacle(1).size(1))*(obstacle(1).size(2)));
    
%     obstacle(i).plot = rectangle('Position',[obstacle(i).xc,obstacle(i).yc,obstacle(i).size(1),obstacle(i).size(2)],'FaceColor','black','EdgeColor','none');
    
    env_graph = update_graph(env_graph, obstacle(i), 1);
    
end

Total_obstacle_space = Total_obstacle_space + sum([obstacle(:).space]);
covered_fraction = Total_obstacle_space/numCells;