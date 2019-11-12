
read={strcat(path,'Process_data.xlsx'),strcat('Sheet',num2str(m))}; % Reading the process data
process_raw{k,m} = {xlsread(read{1},read{2})};
time = process_raw{k,m}{1,1}(:,1);

% Plotting the Slider values
stem(mouseclick1{k,m}(:,1),mouseclick1{k,m}(:,7),'MarkerFaceColor','red','Color','b')
xlim([mouseclick1{k,m}(1,1)-10 time(length(time),1)+10])
ylim([0 1])
hold on

% Highlighting the tags pressed in the scenario and Start Point
Index_time = find(contains(txtData1{k,m}(:,1),'F'));
time_alarm_file1 = alarm_file1{k,m}(:,1);
time_mouse_click = mouseclick1{k,m}(:,1);
time_tags_flow = time_mouse_click(Index_time);
alarms_flow = txtData1{k,m}(Index_time,1);
y = zeros(length(Index_time),1)+0.02;
text(time_tags_flow,y,char(alarms_flow),'Rotation',90,'FontSize',8)
hold on
text(mouseclick1{k,m}(1,1),0.02,'Start','Rotation',90,'FontSize',12,'Color','g') % Noting the start location in the time range

% Highlighting the alarm points by triangular symbol
Index_alarm = find(contains(alarm_name1{k,m}(:,1),'F'));
for i = 1:length(Index_alarm(:,1))
    if sum(strcmpi(alarm_name1{k,m}(i,1),'F102_low'))>=1
        index = find(strcmpi(alarm_name1{k,m}(:,1),'F102_low'));
        time_Tlow = time_alarm_file1(index);
        alarm = alarm_name1{k,m};
        alarm_T= split(alarm(index),"_");
        alarm_Tlow = char(alarm_T(:,1));
        y = zeros(length(index),1)+0.5;
        plot(time_Tlow,y,'v','MarkerFaceColor','red','MarkerSize',14)
        if length(index)==1
            text(time_Tlow,y+0.01,'F102','Rotation',90,'FontSize',12)
        else
            text(time_Tlow,y+0.01,alarm_Tlow,'Rotation',90,'FontSize',12)
        end
        
    elseif sum(strcmpi(alarm_name1{k,m}(i,1),'F102_cleared'))>=1
        index = find(strcmpi(alarm_name1{k,m}(:,1),'F102_cleared'));
        time_Tlow = time_alarm_file1(index);
        alarm = alarm_name1{k,m};
        alarm_T= split(alarm(index),"_");
        alarm_Tlow = char(alarm_T(:,1));
        y = zeros(length(index),1);
        plot(time_Tlow,y,'s','MarkerFaceColor','green','MarkerSize',14)
        if length(index)==1
            text(time_Tlow,y+0.01,'F102','Rotation',90,'FontSize',12)
        else
            text(time_Tlow,y+0.01,alarm_Tlow,'Rotation',90,'FontSize',12)
        end
        
    elseif sum(strcmpi(alarm_name1{k,m}(i,1),'F102_high'))>=1
        index = find(strcmpi(alarm_name1{k,m}(:,1),'F102_high'));
        time_Tlow = time_alarm_file1(index);
        alarm = alarm_name1{k,m};
        alarm_T= split(alarm(index),"_");
        alarm_Tlow = char(alarm_T(:,1));
        y = zeros(length(index),1) +0.50;
        plot(time_Tlow,y,'^','MarkerFaceColor','red','MarkerSize',14)
        if length(index)==1
            text(time_Tlow,y+0.01,'F102','Rotation',90,'FontSize',12)
        else
            text(time_Tlow,y+0.01,alarm_Tlow,'Rotation',90,'FontSize',12)
        end
    end
end
hold on
index4 = find(strcmpi(txtData1{k,m}(:,1),'Scenario_Completed'));
index5 = find(strcmpi(txtData1{k,m}(:,1),'Automatic_Shutdown'));
index6 = find(strcmpi(txtData1{k,m}(:,1),'Emergency_Shutdown'));
if sum(index4)>=1
    plot(time_mouse_click(index4),0,'s','MarkerFaceColor','green','MarkerSize',14)
    text(time_mouse_click(index4),0.01,'SC','Rotation',90,'FontSize',12)
elseif sum(index5)>=1
    plot(time_mouse_click(index5),0,'s','MarkerFaceColor','red','MarkerSize',14)
    text(time_mouse_click(index5),0.01,'ASD','Rotation',90,'FontSize',12)
else
   plot(time_mouse_click(index6),0,'s','MarkerFaceColor','red','MarkerSize',14)
   text(time_mouse_click(index6),0.01,'ESD','Rotation',90,'FontSize',12) 
end
hold off


    