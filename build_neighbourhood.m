function base = build_neighbourhood(base,obstacle)
%%Since base is immobile its environment is fixed and can be sensed once.
%This includes boundary validation and obstacle detection. Agent level
%sensing would still happen dynamically

%Not only obstacled cells also cells not in LOS are marked null
xpoly = [base.xc base.xc+base.size(1)-1 base.xc+base.size(1)-1 base.xc base.xc];
ypoly = [base.yc base.yc base.yc+base.size(2)-1 base.yc+base.size(2)-1 base.yc];

for j = 1:base.max_c_neighbour
%         neighIndex = NeighMat(agents(k).index,:,2)==agents(k).s_neighbours{6,j};
%         if losMat(agents(k).index,neighIndex,2) == 0
%             continue;
%         end
    connected = isConnectionPossible(base.c_neighbours{1,j},base.c_neighbours{2,j},xpoly,ypoly,base,obstacle,base.c_range);
    if ismember(base.c_neighbours{6,j},[obstacle(:).index]) || (connected == 0)
        base.c_neighbours{3,j} = 'NULL';
        base.c_neighbours{4,j} = 'NULL';
        base.current_c_neighbour_number = base.current_c_neighbour_number - 1;
    end
end