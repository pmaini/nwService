function location = get_location(index)
%%Gives region-based location of the cell "index" in the map:
%{
0-invalid
1-botton-left corner
2-bottom boundary
3-bottom-right corner
4-right-boundary
5-top-right corner
6-top boundary
7-top-left corner,
8-left boundary
9-inside
%}

global numCells numColumns numRows;

if ((index == 0) || (index > numCells))
    location = 0;
else
    n = index-1;
    if n == 0 
        location = 1;
    elseif n<numColumns-1
        location = 2;
    elseif n == numColumns-1
        location = 3;
    elseif n == numCells - 1
        location = 5;
    elseif mod(n,numColumns) == numColumns-1
        location = 4;
    elseif n>(numRows-1)*numColumns
        location = 6;
    elseif n == (numRows-1)*numColumns
        location = 7;
    elseif mod(n,numColumns) == 0
        location = 8;
    else
        location = 9;
    end
end