function base = build_neighbourhood(base,obstacle)
%%Since base is immobile its environment is fixed and can be sensed once.
%This includes boundary validation and obstacle detection. Agent level
%sensing would still happen dynamically


for j = 1:base.max_c_neighbour    
    if ismember(base.c_neighbours{6,j},[obstacle(:).index])
        base.c_neighbours{3,j} = 'NULL';
        base.c_neighbours{4,j} = 'NULL';
        base.current_c_neighbour_number = base.current_c_neighbour_number - 1;
    end
end