read={strcat(path,'Process_data.xlsx'),strcat('Sheet',num2str(m))}; % Reading the process data
process_raw{1,3} = {xlsread(read{1},read{2})};
time = process_raw{1,3}{1,1}(:,1);


Index = find(contains(txtData{1,3}(:,1),'T'));
stem(mouseclick{1,3}(:,1),mouseclick{1,3}(:,7),'MarkerFaceColor','red','Color','b')
xlim([time(1,1)-10 time(length(time),1)+10])
ylim([0 1])
hold on
if strcmpi(table2array(alarm_name{1,3}(:,1)),'F101_low')
    plot(alarm_file{1,3}(1,1),0.5,'v','MarkerFaceColor','red','MarkerSize',12)
    hold on 
    plot(alarm_file{1,3}(length(alarm_file{1,3}),1),0,'s','MarkerFaceColor','green','MarkerSize',12)
else
    plot(alarm_file{1,3}(1,1),0.5,'^','MarkerFaceColor','red','MarkerSize',12)
    hold on
    plot(alarm_file{1,3}(length(alarm_file{1,3}),1),0,'s','MarkerFaceColor','green','MarkerSize',12)
end
hold on
alarmname = split(alarm_name{1,3}(:,1),"_"); %% From the Alarm data Splitting the String
text(alarm_file{1,3}(1,1),0.55,alarmname,'Rotation',90,'FontSize',10) % Rotating to 90 degree counterclockwise
hold on
text(mouseclick{1,3}(1,1),0.1,'Start','Rotation',90,'FontSize',10) % Noting the start location in the time range
hold on
pointfive = ones(size(alarm_file{1,3}(:,1)))/2; % Setting 0.5 as location for String 
name_array = split(alarm_name{1,3},"_");
name_array1 = char(name_array{:,1});
text(alarm_file{1,3}(:,1),pointfive(:,1),name_array1 ,'Rotation',90,'FontSize',10) % Noting all alarms in the scenario
hold off
