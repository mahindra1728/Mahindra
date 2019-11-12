clc
close all
clear all


ParentFolder='\\babji-lab-pc-01\D\aatif\data\before_24_june\dinesh\';
AllFile=dir(fullfile(ParentFolder,'*dinesh*'));
FolderOnly=AllFile([AllFile.isdir]);
fold_nms1 = extractfield(FolderOnly,'name');
fold_nms2 = char(fold_nms1);

xlswrite(strcat(ParentFolder,'FD_all_4phases.xlsx'),cellstr(fold_nms2))
for k=1:length(FolderOnly)
     path=   strcat(ParentFolder,FolderOnly(k).name,'\');
     lagTime = {strcat(path,'lag_time')};
        lag_time = xlsread(lagTime{1});
     for m=2:7
f_read={strcat(path,'fixation'),strcat('Sheet',num2str(m))};
FD = xlsread(f_read{1},f_read{2},'E:E');
time = xlsread(f_read{1},f_read{2},'B:B');
AOI = xlsread(f_read{1},f_read{2},'H:H');
matrix = [time(1:length(AOI)) FD(1:length(AOI)) AOI];
lastColumn = matrix(:, end);
non_zeros = matrix(lastColumn ~= 0, :);

a_read={strcat(path,'alarm'),strcat('Sheet',num2str(m-1))};
alarm = xlsread(a_read{1},a_read{2});
alarm_add=alarm(:,1)+alarm(:,2)+lag_time(1,1);
alarm_index=max(find(non_zeros(:,1) <= alarm_add(1,1)));

%% mouse click file
mouse_file = {strcat(path,'mouse'),strcat('Sheet',num2str(m-1))};
[mouseclick mousetext] = xlsread(mouse_file{1}, mouse_file{2});
mouse_time = mouseclick(:,1) + mouseclick(:,2) + lag_time(1,1);

%% nature of scenario: Completed,Automatic shutdown, emergency shutdown
nature_index = find(contains(mousetext,'Scena'));
if isempty(nature_index)
    nature_index = find(contains(mousetext,'Aut'));
end
if isempty(nature_index)
    nature_index = find(contains(mousetext,'Emergency'));
  
end

  mouse_data = mousetext(1:nature_index);
  slider_index1 = find(contains(mouse_data,'Slider'));
first_slider_index = max(find(non_zeros(:,1) <= mouse_time(slider_index1(1))));
last_slider_index = max(find(non_zeros(:,1) <= mouse_time(slider_index1(end))));
complete_index = max(find(non_zeros(:,1) <= mouse_time(nature_index)));

FD1(:,m-1) = mean(non_zeros(1:alarm_index,2));
FD2(:,m-1) = mean(non_zeros(alarm_index:first_slider_index,2));
FD3(:,m-1) = mean(non_zeros(first_slider_index:last_slider_index,2));
FD4(:,m-1) = mean(non_zeros(last_slider_index:complete_index,2));
FD_all = [FD1;FD2;FD3;FD4];

     end
for i = 1:6
    FD_compare(i) = FD3(i)-FD2(i);
end
      FS_compareAll(k,:) = FD_compare;
     FD1_all_files{:,k} = FD_all;
     FD1 = [];FD2 = [];FD3 = [];FD4 = [];
     FD_all = [];
end
%% count how much tasks have more mean FD in phase 3 compared to phase 2
s=sign(FS_compareAll);
ipositif=sum(s(:)==1)
inegatif=sum(s(:)==-1)

j=1;
for i=1:length(FD1_all_files)
    if ~isempty(FD1_all_files{i})
    xlswrite(strcat(ParentFolder,'FD_all_4phases.xlsx'),FD1_all_files{i},'Sheet1',strcat('B',num2str(j)))
    j=j+5;
    end
end