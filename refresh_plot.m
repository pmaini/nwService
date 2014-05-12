function [agent_node task_node] = refresh_plot(agent_node, task_node)
%%DRaw plots for agents and tasks. More plots if needed should be added
%%here only


agent_node = refresh_agent_plot(agent_node);
task_node = refresh_task_plot(task_node);