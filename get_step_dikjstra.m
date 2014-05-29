function [x_next, y_next, got_move] = get_step_dikjstra(agents, agent)
%Process each target ie. find the next step towards each target location.
%Decide weights for each target
%According to the weights for each of the target location find a mean
%location. Find floor of x and y coordinates and find corresponding index.
%Return this value which is the next step given the current targets

global gridpoints_x gridpoints_y ;

c_index = agents(agent).index;
% xt = agents(agent).xc;
% yt = agents(agent).yc;

x_total = 0;
y_total = 0;
n_factor = 0;
path_index = zeros(1,agents(agent).max_targets);

for i = 1:agents(agent).max_targets
    
    if agents(agent).targets(i).valid == 0
        continue;
    end
    
    t_index = agents(agent).targets(i).index;
    
    [distance,path,~] = graphshortestpath(agents(agent).view,c_index,t_index,'Directed',true);
    
    %When in relay mode, if the leader is close by, ideal region(s_range)
    %then no need to move
    if strcmp(agents(agent).targets(i).type,'relay') == 1
        if ismember(agents(agent).targets(i).index,[agents(agent).t_neighbours{6,:}])
            path = c_index;
            distance = 0;
        end     
    end
    
    if (numel(path) > 1) && (distance ~= Inf)
        path_index(i) = path(2);
        x_total = x_total + agents(agent).targets(i).weight*gridpoints_x(path_index(i));
        y_total = y_total + agents(agent).targets(i).weight*gridpoints_y(path_index(i));
    else
        path_index(i) = c_index;
        x_total = x_total + agents(agent).targets(i).weight*gridpoints_x(c_index);
        y_total = y_total + agents(agent).targets(i).weight*gridpoints_y(c_index);
    end
end

%normalizing factor
n_factor = agents(agent).n_factor;

% % using old targets
% for i = 1:agents(agent).max_targets
%     
%     if agents(agent).old_targets(i).valid == 0
%         continue;
%     end
%     
%     t_index = agents(agent).old_targets(i).index;
%     
%     [distance,path,~] = graphshortestpath(agents(agent).view,c_index,t_index,'Directed',true);
%     
%     %When in relay mode, if the leader is close by, ideal region(s_range)
%     %then no need to move
%     if strcmp(agents(agent).old_targets(i).type,'relay') == 1
%         agents(agent).old_targets(i).weight = 0;%1/agents(agent).old_targets(i).distance_to_target;%50;
%         if ismember(agents(agent).old_targets(i).index,[agents(agent).s_neighbours{6,:}])
%             path = c_index;
%             distance = 0;
%         end
%     elseif strcmp(agents(agent).old_targets(i).type,'leader') == 1
%         agents(agent).old_targets(i).weight = 0;
%     end
%     
%     n_factor = n_factor + agents(agent).old_targets(i).weight;
%     
%     if (numel(path) > 1) && (distance ~= Inf)
%         path_index(i) = path(2);
%         x_total = x_total + agents(agent).old_targets(i).weight*gridpoints_x(path_index(i));
%         y_total = y_total + agents(agent).old_targets(i).weight*gridpoints_y(path_index(i));
%     else
%         path_index(i) = 0;
%         x_total = x_total + agents(agent).old_targets(i).weight*gridpoints_x(c_index);
%         y_total = y_total + agents(agent).old_targets(i).weight*gridpoints_y(c_index);
%     end
% end

% x_next = floor(x_total/n_factor) + 0.5;
% y_next = floor(y_total/n_factor) + 0.5;
% n_index = find_index(x_next,y_next);

% code possibly useful for discrete next move selection
if isequal(path_index(1)*ones(1,length(path_index)),path_index)
    n_index = path_index(1);
else
    [~, i] = max([agents(agent).targets(:).weight]);
    n_index = path_index(i);    
end

if n_index == 0 %(x_total == 0) && (y_total == 0)
    got_move = 0;
    x_next = 0;
    y_next = 0;
else        
    got_move = 1;
    x_next = gridpoints_x(n_index);
    y_next = gridpoints_y(n_index);        
%     if (n_index-c_index)==1
%         xt = xt+1;
%         dir = 'right';
%     elseif (n_index-c_index)== -1
%         xt = xt-1;
%         dir = 'left';
%     elseif (n_index-c_index)== size_x
%         yt = yt+1;
%         dir = 'north';
%     elseif (n_index-c_index) == -size_x
%         yt = yt-1;
%         dir = 'south';
%     end
end