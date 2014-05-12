function indices = find_valid_neighbour_indices(index)
%%neighbouring locations starting bottom-left corner in anticlockwise fashion
%maximum -- 8 in square grid and 6 in hexagonal

global grid_type gridlocation numColumns;

if grid_type == 0
    %square grid
    switch gridlocation(index)
        case 0
            indices = [0,0,0,0,0,0,0,0];
        case 1 
            indices = [0,0,0,index+1,index+numColumns+1,index+numColumns,index+numColumns-1,0];
        case 2
            indices = [0,0,0,index+1,index+numColumns+1,index+numColumns,index+numColumns-1,index-1];
        case 3
            indices = [0,0,0,0,0,index+numColumns,index+numColumns-1,index-1];
        case 4
            indices = [index-numColumns-1,index-numColumns,0,0,0,index+numColumns,index+numColumns-1,index-1];
        case 5
            indices = [index-numColumns-1,index-numColumns,0,0,0,0,0,index-1];
        case 6
            indices = [index-numColumns-1,index-numColumns,index-numColumns+1,index+1,0,0,0,index-1];
        case 7
            indices = [0,index-numColumns,index-numColumns+1,index+1,0,0,0,0];
        case 8
            indices = [0,index-numColumns,index-numColumns+1,index+1,index+numColumns+1,index+numColumns,0,0];
        case 9
            indices = [index-numColumns-1,index-numColumns,index-numColumns+1,index+1,index+numColumns+1,index+numColumns,index+numColumns-1,index-1];  
    end
    
elseif grid_type == 1
    %hexagonal grid -- to be verified

   switch gridlocation(index)
        case 0
            indices = [0,0,0,0,0,0];
        case 1 
            indices = [0,0,index+1,index+numColumns,0,0];
        case 2
            indices = [0,0,index+1,index+numColumns,index+numColumns-1,index-1];
        case 3
            indices = [0,0,0,index+numColumns,index+numColumns-1,index-1];
        case 4
            indices = [index-numColumns,0,0,index+numColumns,index+numColumns-1,index-1];
        case 5
            indices = [index-numColumns,0,0,0,0,index-1];
        case 6
            indices = [index-numColumns,index-numColumns+1,index+1,0,0,index-1];
        case 7
            indices = [index-numColumns,index-numColumns+1,index+1,0,0,0];
        case 8
            indices = [index-numColumns,index-numColumns+1,index+1,index+numColumns,0,0];
        case 9
            indices = [index-numColumns,index-numColumns+1,index+1,index+numColumns,index+numColumns-1,index-1];  
    end
    
end