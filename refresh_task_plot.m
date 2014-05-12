function task_node = refresh_task_plot(task_node)
%%Draw plots for task nodes
%1st step: delete old plots
%2nd step: make new plots 

%% Declaration

global numTask;

%% Delete
for i = 1:numTask
    if task_node(i).active ~= 1 %serviced == 1%
        set (task_node(i).plot(1),'Visible','off');
        set (task_node(i).plot(2),'Visible','off'); 
%     %         delete(task_node(i).plot);
%         if (ishandle(task_node(i).plot))
%             delete(task_node(i).plot);
% %             delete(task_node(i).plot(2));
%         end
    end
end
%% Delete old plots & Draw new plots

for i = 1:numTask
     
    if task_node(i).active == 1       
        set (task_node(i).plot(1),'Visible','on');
        set (task_node(i).plot(2),'Visible','on');
%         if mod(i,2) == 0
%             task_node(i).plot(1) = plot(task_node(i).xc,task_node(i).yc,'hr','MarkerSize',16,'MarkerFaceColor','magenta');
%         else
%             task_node(i).plot(1) = plot(task_node(i).xc,task_node(i).yc,'hr','MarkerSize',16,'MarkerFaceColor','blue');
%         end        
%         task_node(i).plot(2) = text(task_node(i).xc - 0.4,task_node(i).yc,num2str(i));
%         set(task_node(i).plot(2),'FontSize',8,'FontName','FixedWidth');
    end
end