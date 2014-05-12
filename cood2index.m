function  return_value = cood2index(f_name,cood_list,index_loc_list,argslist,no_iargs,no_oargs)

if length(cood_list)/2 ~= length(index_loc_list)
    msgbox('Number of coordinates does not match expected number of indices');
    return;
end

args = cell(1,no_iargs);
r_value = cell(1,no_oargs);
index_loc_index = 1;
cood_list_index = 1;

for i=1:no_iargs
    if i < index_loc_list(index_loc_index)
        args{1,i} = argslist(1);
        argslist = argslist(2:end);
    elseif i == index_loc_list(index_loc_index)
        args{1,i} = find_index(cood_list(cood_list_index),cood_list(cood_list_index));
        cood_list_index = cood_list_index + 2;
        index_loc_index = index_loc_index + 1;   
    end        
end

r_value{:} = f_name(args{:});
return_value = r_value;