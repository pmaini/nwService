function return_value = index2cood(f_name,indices,cood_index_list,argslist,no_iargs,no_oargs)
%it is assumed that x and y coordinates of an index appear together

global gridpoints_x  gridpoints_y;

args = cell(1,no_iargs);
r_value = cell(1,no_oargs);
cood_index = 1;
i = 1;
indices_index = 1;

while i <= no_iargs
    if i < cood_index_list(cood_index)
        args{1,i} = argslist(1);
        argslist = argslist(2:end);
    elseif i == cood_index_list(cood_index)        
  
            args{1,i} = gridpoints_x(indices(indices_index));
            args{1,i+1} = gridpoints_y(indices(indices_index));
            indices_index = indices_index + 1;
            cood_index = cood_index + 1;
            i = i+1;                
    end
    
    i=i+1;
end

r_value{:} = f_name(args{:});
return_value = r_value;
       
    
    
        