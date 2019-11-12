% Plotting the Ladder diagram for Sliderpositioning
subplot(3,2,[5,6])
stem(mouseclick{k,m}(:,1),mouseclick{k,m}(:,7),'MarkerFaceColor','red','Color','b')
xlim([time(1,1)-10 time(length(time),1)+10])
ylim([0 1])
hold on
if strcmpi(table2array(alarm_name{k,m}(1,1)),'F102_low')
    plot(alarm_file{k,m}(1,1),0.4,'v','MarkerFaceColor','red','MarkerSize',12)
    hold on 
    plot(alarm_file{k,m}(length(alarm_file{k,m}),1),0,'s','MarkerFaceColor','green','MarkerSize',12)
else
    plot(alarm_file{k,m}(1,1),0.4,'^','MarkerFaceColor','red','MarkerSize',12)
    hold on
    plot(alarm_file{k,m}(length(alarm_file{k,m}),1),0,'s','MarkerFaceColor','green','MarkerSize',12)
end
hold on
alarmname = table2array(split(table2array(alarm_name{k,m}(1,1)),"_")); %% From the Alarm data Splitting the String
text(alarm_file{k,m}(1,1),0.51,alarmname,'Rotation',90,'FontSize',10) % Rotating to 90 degree counterclockwise
hold on
text(mouseclick{k,m}(1,1),0,'Start','Rotation',90,'FontSize',10) % Noting the start location in the time range
hold on
pointfive = ones(size(alarm_file{k,m}(:,1)))/2;
name_array = split(alarm_name{k,m},"_");
name_array1 = char(name_array{:,1});

text(alarm_file{k,m}(:,1),pointfive(:,1),name_array1 ,'Rotation',90,'FontSize',10) % Noting all alarms in the scenario
hold off


% Slider Plotting for F101 HIGH OR F101 LOW
subplot(5,2,[9,10])
stem(mouseclick{k,m}(:,1),mouseclick{k,m}(:,7),'MarkerFaceColor','red','Color','b')
xlim([time(1,1)-10 time(length(time),1)+10])
ylim([0 1])
hold on
if strcmpi(table2array(alarm_name{1,2}(1,1)),'F101_low')
    plot(alarm_file{k,m}(1,1),0.4,'v','MarkerFaceColor','red','MarkerSize',12)
    hold on 
    plot(alarm_file{k,m}(length(alarm_file{k,m}),1),0,'s','MarkerFaceColor','green','MarkerSize',12)
else
    plot(alarm_file{k,m}(1,1),0.4,'^','MarkerFaceColor','red','MarkerSize',12)
    hold on
    plot(alarm_file{k,m}(length(alarm_file{k,m}),1),0,'s','MarkerFaceColor','green','MarkerSize',12)
end
hold on
alarmname = table2array(split(table2array(alarm_name{k,m}(1,1)),"_")); %% From the Alarm data Splitting the String
text(alarm_file{k,m}(1,1),0.51,alarmname,'Rotation',90,'FontSize',10) % Rotating to 90 degree counterclockwise
hold on
text(mouseclick{k,m}(1,1),0,'Start','Rotation',90,'FontSize',10) % Noting the start location in the time range
hold on
pointfive = ones(size(alarm_file{k,m}(:,1)))/2; % Setting 0.5 as location for String 
name_array = split(alarm_name{k,m},"_");
name_array1 = char(name_array{:,1});
text(alarm_file{k,m}(:,1),pointfive(:,1),name_array1 ,'Rotation',90,'FontSize',10) % Noting all alarms in the scenario
hold off

    
    
    
    
x = 1:10; y = 1:10; scatter(x,y);
a = [1:10]'; b = num2str(a); c = cellstr(b);
dx = 0.1; dy = 0.1; % displacement so the text does not overlay the data points
text(x+dx, y+dy, c);