function plotPotGradient(base)
global numCells gridCells gridpoints_x gridpoints_y

levels = max([gridCells(:).bNeighL]);
for ind1 = 1:numCells
    if ismember(ind1,base.indices)
        continue;
    end
    level = gridCells(ind1).bNeighL;
     x = gridpoints_x(ind1)-0.5;
     y = gridpoints_y(ind1)-0.5;
     rectangle('Position',[x,y,1,1],'FaceColor',[1 1 1] - ((level-1)/levels)*[1 1 1]);%,'EdgeColor','none');
     if ind1 == 180
         pause(1);
     end
end