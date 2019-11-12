%% This code is for match and mismatch processing FOR All Theta Alpha Beta in Adaptive filtering
%   PARENT CODE FOR proper 0,1 and -1 conditions
%% Condition setting where the process is coming towards stability and if process is moving out of stability.

%% Reading the process alarm and variable value.\
%% NOTE
% HERE PROCESS VALUE DATA IS TAKEN FROM SLIDER ACTION TO SCENARIO
% COMPLETION
% Code for generation of Beta and Alpha Conclusion
% code 10 is the parent code after slider to scenario compeleted.
% Code for 0_1 is parent code for alarm to atart_ done till scenario
% complete +2 seconds
%% CODE 12 NOTE: Here process unstability is properly arranged according to position of alarm that has occured, if alarm has occured as low then pv going above the upper limit due to action of participant
%                will cause more unstability..
clc
% ASSIGNING THE FOLDER PATH AND SOURCE
warning off
for destination = 1:10
    clear conclusion_theta conclusion_alpha conclusion_beta 
    warning('off')
    format short g
    Main_Folder = 'D:\Mahindra\Adaptive_Filter_Without_Iteration\EEGDATA\';
    person = {strcat('P',num2str(destination))};
    participant = char(person);
    
    for i = 1
        if i == 1
            sch = 'm';
            Parent_Folder=strcat(Main_Folder,participant,'\Morning\'); % Folder destination
            AllFile=dir(fullfile(Parent_Folder,'*P*')); % Subfolders starting letter
            File_link=AllFile([AllFile.isdir]);
            Folder = natsortfiles({File_link.name});
            for i= 1:length(Folder)      % Assigning sorted value in AllFile in order
                AllFile(i).name = Folder{i};
            end
            Folder = AllFile;
            %             fold_nms1 = Folder;
            %             fold_nms2 = char(fold_nms1);
        else
            sch = 'n';
            Parent_Folder=strcat(Main_Folder,participant,'\Night\'); % Folder destination
            AllFile=dir(fullfile(Parent_Folder,'*P*')); % Subfolders starting letter
            File_link=AllFile([AllFile.isdir]);
            Folder = natsortfiles({File_link.name});
            for i= 1:length(Folder)      % Assigning sorted value in AllFile in order
                AllFile(i).name = Folder{i};
            end
            Folder = AllFile;
            %             fold_nms1 = Folder;
            %             fold_nms2 = char(fold_nms1);
        end
        
        %% Importing the Alarm Files
        alarm_file = [];
        alarm_name = [];
        alarm_file1 = [];alarm_name1 = []; mouseclick = [];mouseclick1 = []; txtData = []; txtData1= []; process_raw = [];PSD = [];
        
        
        for k=1:length(Folder)
            path=strcat(Parent_Folder,Folder(k).name,'\')
            for m=1:6
                read= {strcat(path,'Alarm_timing'),strcat('Sheet',num2str(m))}; %% ALARM IMING SORTED FILE
                [alarm_file{k,m},alarm_name{k,m}] = xlsread(read{1},read{2});
                read= {strcat(path,'Alarm_timing1'),strcat('Sheet',num2str(m))};%% ALRM TIMING OLD FILE
                [alarm_file1{k,m},alarm_name1{k,m}] = xlsread(read{1},read{2});
                read={strcat(path,'Mouse_click'),strcat('Sheet',num2str(m))};   %% MOUSE CLICK SORTED
                [mouseclick{k,m},txtData{k,m}]=xlsread(read{1},read{2});
                read={strcat(path,'Mouse_click1'),strcat('Sheet',num2str(m))};  %% MOUSECLICK OLD
                [mouseclick1{k,m},txtData1{k,m}]=xlsread(read{1},read{2});
                read={strcat(path,'Process_data'),strcat('Sheet',num2str(m))};  %% RAW PROCESS DATA
                process_raw{k,m}=xlsread(read{1},read{2});
                % Reading the raw PSD file without the rest period
                %                 read={strcat(path1,'Experiment_new_rest'),strcat('Sheet',num2str(m))};    %% EXPERIMENT SHEET CONTAINING THETA, ALPHA AND BETA
                %                 PSD_raw_old{k,m}=xlsread(read{1},read{2});
                
                % Reading the PSD_REST FILE
                for q = 1:7
                    read={strcat(path,'PSD_After_Time_Series_Adaptive_Filter_without_Iteration'),strcat('Sheet',num2str(q))};    %% EXPERIMENT+REST SHEET CONTAINING THETA, ALPHA AND BETA
                    PSD_raw_data{k,q} = xlsread(read{1},read{2});
                    PSD_raw{k,q} = PSD_raw_data{k,q};
                    if q == 7
                        PSD_raw_rest{destination,1}{k} = PSD_raw_data{k,q};
                        
                    end
                end
                
                C101_ul = 1555.6; C101_ll = 955.6; T103_ul = 33; T103_ll = 29.5;F101_ul = 950; F101_ll = 550;
                F102_ul = 200; F102_ll = 70;F105_ul = 993.7; F105_ll = 575.3;T104_ul = 100.5; T104_ll = 98.5;
                T105_ul = 89.5; T105_ll = 86.5;T106_ul = 80.4; T106_ll = 78.5;
                %% Forming a vector from high and low alarms
                
                
                clear index pv_f102 diff_F102 pv_length zone_diff_F102_low  zone_diff_T106_low zone_diff_T106_high zone_diff_T105_low zone_diff_T105_high
                clear zone_diff_T104_low zone_diff_T104_high zone_diff_C101_low zone_diff_C101_high zone_diff_F101_low zone_diff_F101_high zone_diff_F105_low
                clear zone_diff_F105_high zone_diff_F102_high diff_F102_low diff_F102_high diff_F101_low diff_F101_high diff_C101_low diff_C101_high
                clear part diff_F105_low diff_F105_high diff_T104_low diff_T104_high diff_T104=5_low diff_T105_high diff_T106_low diff_T106_high
                zone_diff_T106_high = []; zone_diff_T106_low = []; zone_diff_T105_high = []; zone_diff_T104_high = []; zone_diff_C101_high = [];
                zone_diff_F101_high = []; zone_diff_F102_high = []; zone_diff_F105_high = []; zone_diff_T105_low = []; zone_diff_T104_low = [];
                zone_diff_C101_low = []; zone_diff_F101_low = []; zone_diff_F102_low = [];zone_diff_F105_low = [];
                diff_F102_low = {};diff_F102_high = {};diff_F105_low = {};diff_F105_high = {};diff_F101_low = {};diff_F101_high = {};diff_C101_low = {};
                diff_C101_high = {};diff_T104_low = {};diff_T105_low = {};diff_T106_low = {};diff_T104_high = {};diff_T105_high = {};diff_T106_high = {};
                zone_diff_overall = []; zone_diff_total = [];
                
                %% F102 HIGH AND LOW ALARM
                
                %% F102 LOW
                if sum(strcmpi(alarm_name1{k,m}(1,1), 'F102_low'))>=1 % F102_LOW
                    %                     index = find(process_raw{k,m}(:,4)<F102_ll);
                    time_alarm_slider_action = mouseclick{k,m}(4,1);
                    range1 = mouseclick{k,m}(4,1) +1;
                    range2 = mouseclick{k,m}(4,1) -1;
                    range = [range2:range1];
                    for a = 1:3
                        if length(find(process_raw{k,m}(:,1)==range(1))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(1)));
                        end
                        if length(find(process_raw{k,m}(:,1)==range(2))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(2)));
                        end
                        if length(find(process_raw{k,m}(:,1)==range(3))) ==1
                            index_t(1,a) =(find(process_raw{k,m}(:,1)==range(3)));
                        end
                    end
                    index_t = max(index_t);
                    pv_f102_low = process_raw{k,m}(index_t:length(process_raw{k,m}(:,1)),4);
                    for j = 1:length(pv_f102_low)
                        if pv_f102_low(j) > F102_ul
                            diff_F102_low{j} = F102_ul - pv_f102_low(j);
                        elseif pv_f102_low(j)<F102_ll
                            diff_F102_low{j} = pv_f102_low(j) - F102_ll;
                        elseif pv_f102_low(j)<F102_ul && pv_f102_low(j)>F102_ll
                            diff_F102_low{j} = pv_f102_low(j) - F102_ll;
                        end
                    end
                    diff_F102_low = diff_F102_low;
                    length_action = length(PSD_raw{k,m}(1,:));
                    PSD_theta{k,m} = mean(PSD_raw{k,m}(5:8,3:length(PSD_raw{k,m}(1,:))));
                    PSD_beta{k,m} = mean(PSD_raw{k,m}(9:13,3:length(PSD_raw{k,m}(1,:))));
                    PSD_alpha{k,m} = mean(PSD_raw{k,m}(14:31,3:length(PSD_raw{k,m}(1,:))));
                    
                    time_slider = process_raw{k,m}(index_t,1);
                    time_end = process_raw{k,m}(end,1);
                    a = 1:ceil((time_end - time_slider)/10);
                    time_array = process_raw{k,m}(index_t:length(process_raw{k,m}),1);
                    part{1,1} = time_array(time_array<=(10+time_slider));
                    for no_psd = 2:length(a)
                        part{no_psd,1} = time_array(time_array<=time_slider+10*no_psd & time_array>max(part{no_psd-1,1}));
                    end
                    %                      pv_length = ceil(length(pv_f102_low)/length(PSD_theta{k,m}));
                    %                     if length(pv_f102_low)/length(PSD_theta{k,m}) < ceil(length(pv_f102_low)/length(PSD_theta{k,m}))-0.5
                    %                         pv_length = floor(length(pv_f102_low)/length(PSD_theta{k,m}));
                    %                     end
                    %                     parts = length(PSD_theta{k,m});
                    if length(part)==3
                        for n = 2:length(part)
                            zone_diff_F102_low{1} = cell2mat(diff_F102_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F102_low{n} = cell2mat(diff_F102_low(1,sum(cellfun('length',zone_diff_F102_low))+1:sum(cellfun('length',zone_diff_F102_low)):length(diff_F102_low)));
                            elseif n ~= length(part)
                                zone_diff_F102_low{n} = cell2mat(diff_F102_low(1,sum(cellfun('length',zone_diff_F102_low))+1:sum(cellfun('length',zone_diff_F102_low))+length(part{n,1})));
                            end
                        end
                    else
                        for n = 2:length(part)
                            zone_diff_F102_low{1} = cell2mat(diff_F102_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F102_low{n} = cell2mat(diff_F102_low(1,sum(cellfun('length',zone_diff_F102_low))+1:sum(cellfun('length',zone_diff_F102_low)):length(diff_F102_low)));
                            elseif n ~= length(part)
                                zone_diff_F102_low{n} = cell2mat(diff_F102_low(1,sum(cellfun('length',zone_diff_F102_low))+1:sum(cellfun('length',zone_diff_F102_low))+length(part{n,1})));
                            end
                        end
                    end
                end
                %% F102 HIGH
                if sum(strcmpi(alarm_name1{k,m}(1,1), 'F102_high'))>=1 % F102_high
                    %                     index = find(process_raw{k,m}(:,4)>F102_ul);
                    time_alarm_slider_action = mouseclick{k,m}(4,1);
                    range1 = mouseclick{k,m}(4,1) +1;
                    range2 = mouseclick{k,m}(4,1) -1;
                    range = [range2:range1];
                    for a = 1:3
                        if length(find(process_raw{k,m}(:,1)==range(1))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(1)));
                        end
                        if length(find(process_raw{k,m}(:,1)==range(2))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(2)));
                        end
                        if length(find(process_raw{k,m}(:,1)==range(3))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(3)));
                        end
                    end
                    index_t = max(index_t);
                    pv_f102_high = process_raw{k,m}(index_t:length(process_raw{k,m}(:,1)),4);
                    for j = 1:length(pv_f102_high)
                        if pv_f102_high(j) > F102_ul
                            diff_F102_high{j} = F102_ul - pv_f102_high(j);
                        elseif pv_f102_high(j)<F102_ll
                            diff_F102_high{j} = pv_f102_high(j) - F102_ll;
                        elseif pv_f102_high(j)<F102_ul && pv_f102_high(j)>F102_ll
                            diff_F102_high{j} = pv_f102_high(j) - F102_ll;
                        end
                    end
                    diff_F102_high = diff_F102_high;
                    length_action = length(PSD_raw{k,m}(1,:));
                    PSD_theta{k,m} = mean(PSD_raw{k,m}(5:8,3:length(PSD_raw{k,m}(1,:))));
                    PSD_beta{k,m} = mean(PSD_raw{k,m}(9:13,3:length(PSD_raw{k,m}(1,:))));
                    PSD_alpha{k,m} = mean(PSD_raw{k,m}(14:31,3:length(PSD_raw{k,m}(1,:))));
                    time_slider = process_raw{k,m}(index_t,1);
                    time_end = process_raw{k,m}(end,1);
                    a = 1:ceil((time_end - time_slider)/10);
                    time_array = process_raw{k,m}(index_t:length(process_raw{k,m}),1);
                    part{1,1} = time_array(time_array<=(10+time_slider));
                    for no_psd = 2:length(a)
                        part{no_psd,1} = time_array(time_array<=time_slider+10*no_psd & time_array>max(part{no_psd-1,1}));
                    end
                    %                     pv_length = ceil(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     if length(pv_f102_high)/length(PSD_theta{k,m}) < ceil(length(pv_f102_high)/length(PSD_theta{k,m}))-0.5
                    %                         pv_length = floor(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     end
                    %                     part = length(PSD_theta{k,m});
                    %                     if length(part)==3
                    
                    if length(part)==3
                        for n = 2:length(part)
                            zone_diff_F102_high{1} = cell2mat(diff_F102_high(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F102_high{n} = cell2mat(diff_F102_high(1,sum(cellfun('length',zone_diff_F102_high))+1:sum(cellfun('length',zone_diff_F102_high)):length(diff_F102_high)));
                            elseif n ~= length(part)
                                zone_diff_F102_high{n} = cell2mat(diff_F102_high(1,sum(cellfun('length',zone_diff_F102_high))+1:sum(cellfun('length',zone_diff_F102_high))+length(part{n,1})));
                            end
                        end
                    else
                        for n = 2:length(part)
                            zone_diff_F102_high{1} = cell2mat(diff_F102_high(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F102_high{n} = cell2mat(diff_F102_high(1,sum(cellfun('length',zone_diff_F102_high))+1:sum(cellfun('length',zone_diff_F102_high)):length(diff_F102_high)));
                            elseif n ~= length(part)
                                zone_diff_F102_high{n} = cell2mat(diff_F102_high(1,sum(cellfun('length',zone_diff_F102_high))+1:sum(cellfun('length',zone_diff_F102_high))+length(part{n,1})));
                            end
                        end
                    end
                end
                
                %% F101 LOW, F105 LOW, C101 HIGH and low alarms
                %% F101 LOW
                if sum(strcmpi(alarm_name1{k,m}(1,1), 'F101_low'))>=1 % F101_low
                    %                     index = find(process_raw{k,m}(:,3)<F101_ll);
                    time_alarm_slider_action = mouseclick{k,m}(4,1);
                    range1 = mouseclick{k,m}(4,1) +1;
                    range2 = mouseclick{k,m}(4,1) -1;
                    range = [range2:range1];
                    for a = 1:3
                        if length(find(process_raw{k,m}(:,1)==range(1))) ==1
                            index_t(1,a) =(find(process_raw{k,m}(:,1)==range(1)));
                        end
                        if length(find(process_raw{k,m}(:,1)==range(2))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(2)));
                        end
                        if length(find(process_raw{k,m}(:,1)==range(3))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(3)));
                        end
                    end
                    index_t = max(index_t);
                    pv_f101_low = process_raw{k,m}(index_t:length(process_raw{k,m}(:,1)),3);
                    for j = 1:length(pv_f101_low)
                        if pv_f101_low(j) > F101_ul
                            diff_F101_low{j} = F101_ul - pv_f101_low(j);
                        elseif pv_f101_low(j)<F101_ll
                            diff_F101_low{j} = pv_f101_low(j) - F101_ll;
                        elseif pv_f101_low(j)<F101_ul && pv_f101_low(j)>F101_ll
                            diff_F101_low{j} = pv_f101_low(j) - F101_ll;
                        end
                    end
                    diff_F101_low = diff_F101_low;
                    length_action = length(PSD_raw{k,m}(1,:));
                    PSD_theta{k,m} = mean(PSD_raw{k,m}(5:8,3:length(PSD_raw{k,m}(1,:))));
                    PSD_beta{k,m} = mean(PSD_raw{k,m}(9:13,3:length(PSD_raw{k,m}(1,:))));
                    PSD_alpha{k,m} = mean(PSD_raw{k,m}(14:31,3:length(PSD_raw{k,m}(1,:))));
                    
                    time_slider = process_raw{k,m}(index_t,1);
                    time_end = process_raw{k,m}(end,1);
                    a = 1:ceil((time_end - time_slider)/10);
                    time_array = process_raw{k,m}(index_t:length(process_raw{k,m}),1);
                    part{1,1} = time_array(time_array<=(10+time_slider));
                    for no_psd = 2:length(a)
                        part{no_psd,1} = time_array(time_array<=time_slider+10*no_psd & time_array>max(part{no_psd-1,1}));
                    end
                    %                     pv_length = ceil(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     if length(pv_f102_high)/length(PSD_theta{k,m}) < ceil(length(pv_f102_high)/length(PSD_theta{k,m}))-0.5
                    %                         pv_length = floor(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     end
                    %                     part = length(PSD_theta{k,m});
                    %                     if length(part)==3
                    
                    if length(part)==3
                        for n = 2:length(part)
                            zone_diff_F101_low{1} = cell2mat(diff_F101_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F101_low{n} = cell2mat(diff_F101_low(1,sum(cellfun('length',zone_diff_F101_low))+1:sum(cellfun('length',zone_diff_F101_low)):length(diff_F101_low)));
                            elseif n ~= length(part)
                                zone_diff_F101_low{n} = cell2mat(diff_F101_low(1,sum(cellfun('length',zone_diff_F101_low))+1:sum(cellfun('length',zone_diff_F101_low))+length(part{n,1})));
                            end
                        end
                    else
                        for n = 2:length(part)
                            zone_diff_F101_low{1} = cell2mat(diff_F101_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F101_low{n} = cell2mat(diff_F101_low(1,sum(cellfun('length',zone_diff_F101_low))+1:sum(cellfun('length',zone_diff_F101_low)):length(diff_F101_low)));
                            elseif n ~= length(part)
                                zone_diff_F101_low{n} = cell2mat(diff_F101_low(1,sum(cellfun('length',zone_diff_F101_low))+1:sum(cellfun('length',zone_diff_F101_low))+length(part{n,1})));
                            end
                        end
                    end
                    
                    %% F105 LOW ALARM
                    % index = find(process_raw{k,m}(:,7)<F105_ll);
                    pv_f105_low = process_raw{k,m}(index_t:length(process_raw{k,m}(:,1)),7);
                    for j = 1:length(pv_f105_low)
                        if pv_f105_low(j) > F105_ul
                            diff_F105_low{j} = F105_ul - pv_f105_low(j);
                        elseif pv_f105_low(j)<F105_ll
                            diff_F105_low{j} = pv_f105_low(j) - F105_ll;
                        elseif pv_f105_low(j)<F105_ul && pv_f105_low(j)>F105_ll
                            diff_F105_low{j} = pv_f105_low(j) - F105_ll;
                        end
                    end
                    diff_F105_low = diff_F105_low;
                    length_action = length(PSD_raw{k,m}(1,:));
                    PSD_theta{k,m} = mean(PSD_raw{k,m}(5:8,3:length(PSD_raw{k,m}(1,:))));
                    PSD_beta{k,m} = mean(PSD_raw{k,m}(9:13,3:length(PSD_raw{k,m}(1,:))));
                    PSD_alpha{k,m} = mean(PSD_raw{k,m}(14:31,3:length(PSD_raw{k,m}(1,:))));
                    
                    time_slider = process_raw{k,m}(index_t,1);
                    time_end = process_raw{k,m}(end,1);
                    a = 1:ceil((time_end - time_slider)/10);
                    time_array = process_raw{k,m}(index_t:length(process_raw{k,m}),1);
                    part{1,1} = time_array(time_array<=(10+time_slider));
                    for no_psd = 2:length(a)
                        part{no_psd,1} = time_array(time_array<=time_slider+10*no_psd & time_array>max(part{no_psd-1,1}));
                    end
                    %                     pv_length = ceil(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     if length(pv_f102_high)/length(PSD_theta{k,m}) < ceil(length(pv_f102_high)/length(PSD_theta{k,m}))-0.5
                    %                         pv_length = floor(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     end
                    %                     part = length(PSD_theta{k,m});
                    %                     if length(part)==3
                    if length(part)==3
                        for n = 2:length(part)
                            zone_diff_F105_low{1} = cell2mat(diff_F105_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F105_low{n} = cell2mat(diff_F105_low(1,sum(cellfun('length',zone_diff_F105_low))+1:sum(cellfun('length',zone_diff_F105_low)):length(diff_F105_low)));
                            elseif n ~= length(part)
                                zone_diff_F105_low{n} = cell2mat(diff_F105_low(1,sum(cellfun('length',zone_diff_F105_low))+1:sum(cellfun('length',zone_diff_F105_low))+length(part{n,1})));
                            end
                        end
                    else
                        for n = 2:length(part)
                            zone_diff_F105_low{1} = cell2mat(diff_F105_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F105_low{n} = cell2mat(diff_F105_low(1,sum(cellfun('length',zone_diff_F105_low))+1:sum(cellfun('length',zone_diff_F105_low)):length(diff_F105_low)));
                            elseif n ~= length(part)
                                zone_diff_F105_low{n} = cell2mat(diff_F105_low(1,sum(cellfun('length',zone_diff_F105_low))+1:sum(cellfun('length',zone_diff_F105_low))+length(part{n,1})));
                            end
                        end
                    end
                    clear part
                    
                    %% C101 HIGH ALARM
                    % index = find(process_raw{k,m}(:,12)>C101_ul);
                    pv_c101_high = process_raw{k,m}(index_t:length(process_raw{k,m}(:,1)),12);
                    for j = 1:length(pv_c101_high)
                        if pv_c101_high(j) > C101_ul
                            diff_C101_high{j} = C101_ul - pv_c101_high(j);
                        elseif pv_c101_high(j)<C101_ll
                            diff_C101_high{j} = pv_c101_high(j) - C101_ll;
                        elseif pv_c101_high(j)<C101_ul && pv_c101_high(j)>C101_ll
                            diff_C101_high{j} = pv_c101_high(j) - C101_ll;
                        end
                    end
                    diff_C101_high = diff_C101_high;
                    length_action = length(PSD_raw{k,m}(1,:));
                    PSD_theta{k,m} = mean(PSD_raw{k,m}(5:8,3:length(PSD_raw{k,m}(1,:))));
                    PSD_beta{k,m} = mean(PSD_raw{k,m}(9:13,3:length(PSD_raw{k,m}(1,:))));
                    PSD_alpha{k,m} = mean(PSD_raw{k,m}(14:31,3:length(PSD_raw{k,m}(1,:))));
                    time_slider = process_raw{k,m}(index_t,1);
                    time_end = process_raw{k,m}(end,1);
                    a = 1:ceil((time_end - time_slider)/10);
                    time_array = process_raw{k,m}(index_t:length(process_raw{k,m}),1);
                    part{1,1} = time_array(time_array<=(10+time_slider));
                    for no_psd = 2:length(a)
                        part{no_psd,1} = time_array(time_array<=time_slider+10*no_psd & time_array>max(part{no_psd-1,1}));
                    end
                    %                     pv_length = ceil(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     if length(pv_f102_high)/length(PSD_theta{k,m}) < ceil(length(pv_f102_high)/length(PSD_theta{k,m}))-0.5
                    %                         pv_length = floor(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     end
                    %                     part = length(PSD_theta{k,m});
                    %                     if length(part)==3
                    
                    if length(part)==3
                        for n = 2:length(part)
                            zone_diff_C101_high{1} = cell2mat(diff_C101_high(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_C101_high{n} = cell2mat(diff_C101_high(1,sum(cellfun('length',zone_diff_C101_high))+1:sum(cellfun('length',zone_diff_C101_high)):length(diff_C101_high)));
                            elseif n ~= length(part)
                                zone_diff_C101_high{n} = cell2mat(diff_C101_high(1,sum(cellfun('length',zone_diff_C101_high))+1:sum(cellfun('length',zone_diff_C101_high))+length(part{n,1})));
                            end
                        end
                    else
                        for n = 2:length(part)
                            zone_diff_C101_high{1} = cell2mat(diff_C101_high(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_C101_high{n} = cell2mat(diff_C101_high(1,sum(cellfun('length',zone_diff_C101_high))+1:sum(cellfun('length',zone_diff_C101_high)):length(diff_C101_high)));
                            elseif n ~= length(part)
                                zone_diff_C101_high{n} = cell2mat(diff_C101_high(1,sum(cellfun('length',zone_diff_C101_high))+1:sum(cellfun('length',zone_diff_C101_high))+length(part{n,1})));
                            end
                        end
                    end
                end
                
                %% F101 HIGH , F105 HIGH AND C101 LOW ALARM
                if sum(strcmpi(alarm_name1{k,m}(1,1), 'F101_high'))>=1 % F101_high
                    % F101 High
                    % index_t(1,a) = find(process_raw{k,m}(:,3)>F101_ul);
                    time_alarm_slider_action = mouseclick{k,m}(4,1);
                    range1 = mouseclick{k,m}(4,1) +1;
                    range2 = mouseclick{k,m}(4,1) -1;
                    range = [range2:range1];
                    for a = 1:3
                        if length(find(process_raw{k,m}(:,1)==range(1))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(1)));
                        end
                        if length(find(process_raw{k,m}(:,1)==range(2))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(2)));
                        end
                        if length(find(process_raw{k,m}(:,1)==range(3))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(3)));
                        end
                    end
                    index_t = max(index_t);
                    pv_f101_high = process_raw{k,m}(index_t:length(process_raw{k,m}(:,1)),3);
                    for j = 1:length(pv_f101_high)
                        if pv_f101_high(j) > F101_ul
                            diff_F101_high{j} = F101_ul - pv_f101_high(j);
                        elseif pv_f101_high(j)<F101_ll
                            diff_F101_high{j} = pv_f101_high(j) - F101_ll;
                        elseif pv_f101_high(j)<F101_ul && pv_f101_high(j)>F101_ll
                            diff_F101_high{j} = pv_f101_high(j) - F101_ll;
                        end
                    end
                    diff_F101_high = diff_F101_high;
                    length_action = length(PSD_raw{k,m}(1,:));
                    PSD_theta{k,m} = mean(PSD_raw{k,m}(5:8,3:length(PSD_raw{k,m}(1,:))));
                    PSD_beta{k,m} = mean(PSD_raw{k,m}(9:13,3:length(PSD_raw{k,m}(1,:))));
                    PSD_alpha{k,m} = mean(PSD_raw{k,m}(14:31,3:length(PSD_raw{k,m}(1,:))));
                    time_slider = process_raw{k,m}(index_t,1);
                    time_end = process_raw{k,m}(end,1);
                    a = 1:ceil((time_end - time_slider)/10);
                    time_array = process_raw{k,m}(index_t:length(process_raw{k,m}),1);
                    part{1,1} = time_array(time_array<=(10+time_slider));
                    for no_psd = 2:length(a)
                        part{no_psd,1} = time_array(time_array<=time_slider+10*no_psd & time_array>max(part{no_psd-1,1}));
                    end
                    %                     pv_length = ceil(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     if length(pv_f102_high)/length(PSD_theta{k,m}) < ceil(length(pv_f102_high)/length(PSD_theta{k,m}))-0.5
                    %                         pv_length = floor(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     end
                    %                     part = length(PSD_theta{k,m});
                    %                     if length(part)==3
                    if length(part)==3
                        for n = 2:length(part)
                            zone_diff_F101_high{1} = cell2mat(diff_F101_high(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F101_high{n} = cell2mat(diff_F101_high(1,sum(cellfun('length',zone_diff_F101_high))+1:sum(cellfun('length',zone_diff_F101_high)):length(diff_F101_high)));
                            elseif n ~= length(part)
                                zone_diff_F101_high{n} = cell2mat(diff_F101_high(1,sum(cellfun('length',zone_diff_F101_high))+1:sum(cellfun('length',zone_diff_F101_high))+length(part{n,1})));
                            end
                        end
                    else
                        for n = 2:length(part)
                            zone_diff_F101_high{1} = cell2mat(diff_F101_high(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F101_high{n} = cell2mat(diff_F101_high(1,sum(cellfun('length',zone_diff_F101_high))+1:sum(cellfun('length',zone_diff_F101_high)):length(diff_F101_high)));
                            elseif n ~= length(part)
                                zone_diff_F101_high{n} = cell2mat(diff_F101_high(1,sum(cellfun('length',zone_diff_F101_high))+1:sum(cellfun('length',zone_diff_F101_high))+length(part{n,1})));
                            end
                        end
                    end
                    clear part
                    
                    % C101 Low
                    % index = find(process_raw{k,m}(:,12)<C101_ll);
                    pv_c101_low = process_raw{k,m}(index_t:length(process_raw{k,m}(:,1)),12);
                    for j = 1:length(pv_c101_low)
                        if pv_c101_low(j) > C101_ul
                            diff_C101_low{j} = C101_ul - pv_c101_low(j);
                        elseif pv_c101_low(j)<C101_ll
                            diff_C101_low{j} = pv_c101_low(j) - C101_ll;
                        elseif pv_c101_low(j)<C101_ul && pv_c101_low(j)>C101_ll
                            diff_C101_low{j} = pv_c101_low(j) - C101_ll;
                        end
                    end
                    diff_C101_low = diff_C101_low;
                    length_action = length(PSD_raw{k,m}(1,:));
                    PSD_theta{k,m} = mean(PSD_raw{k,m}(5:8,3:length(PSD_raw{k,m}(1,:))));
                    PSD_beta{k,m} = mean(PSD_raw{k,m}(9:13,3:length(PSD_raw{k,m}(1,:))));
                    PSD_alpha{k,m} = mean(PSD_raw{k,m}(14:31,3:length(PSD_raw{k,m}(1,:))));
                    time_slider = process_raw{k,m}(index_t,1);
                    time_end = process_raw{k,m}(end,1);
                    a = 1:ceil((time_end - time_slider)/10);
                    time_array = process_raw{k,m}(index_t:length(process_raw{k,m}),1);
                    part{1,1} = time_array(time_array<=(10+time_slider));
                    for no_psd = 2:length(a)
                        part{no_psd,1} = time_array(time_array<=time_slider+10*no_psd & time_array>max(part{no_psd-1,1}));
                    end
                    %                     pv_length = ceil(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     if length(pv_f102_high)/length(PSD_theta{k,m}) < ceil(length(pv_f102_high)/length(PSD_theta{k,m}))-0.5
                    %                         pv_length = floor(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     end
                    %                     part = length(PSD_theta{k,m});
                    %                     if length(part)==3
                    if length(part)==3
                        for n = 2:length(part)
                            zone_diff_C101_low{1} = cell2mat(diff_C101_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_C101_low{n} = cell2mat(diff_C101_low(1,sum(cellfun('length',zone_diff_C101_low))+1:sum(cellfun('length',zone_diff_C101_low)):length(diff_C101_low)));
                            elseif n ~= length(part)
                                zone_diff_C101_low{n} = cell2mat(diff_C101_low(1,sum(cellfun('length',zone_diff_C101_low))+1:sum(cellfun('length',zone_diff_C101_low))+length(part{n,1})));
                            end
                        end
                    else
                        for n = 2:length(part)
                            zone_diff_C101_low{1} = cell2mat(diff_C101_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_C101_low{n} = cell2mat(diff_C101_low(1,sum(cellfun('length',zone_diff_C101_low))+1:sum(cellfun('length',zone_diff_C101_low)):length(diff_C101_low)));
                            elseif n ~= length(part)
                                zone_diff_C101_low{n} = cell2mat(diff_C101_low(1,sum(cellfun('length',zone_diff_C101_low))+1:sum(cellfun('length',zone_diff_C101_low))+length(part{n,1})));
                            end
                        end
                    end
                    clear part
                    
                    % F105 HIGH
                    % index = find(process_raw{k,m}(:,7)>F105_ul);
                    pv_f105_high = process_raw{k,m}(index_t:length(process_raw{k,m}(:,1)),7);
                    for j = 1:length(pv_f105_high)
                        if pv_f105_high(j) > F105_ul
                            diff_F105_high{j} = F105_ul - pv_f105_high(j);
                        elseif pv_f105_high(j)<F105_ll
                            diff_F105_high{j} = pv_f105_high(j) - F105_ll;
                        elseif pv_f105_high(j)<F105_ul && pv_f105_high(j)>F105_ll
                            diff_F105_high{j} = pv_f105_high(j) - F105_ll;
                        end
                    end
                    diff_F105_high = diff_F105_high;
                    length_action = length(PSD_raw{k,m}(1,:));
                    PSD_theta{k,m} = mean(PSD_raw{k,m}(5:8,3:length(PSD_raw{k,m}(1,:))));
                    PSD_beta{k,m} = mean(PSD_raw{k,m}(9:13,3:length(PSD_raw{k,m}(1,:))));
                    PSD_alpha{k,m} = mean(PSD_raw{k,m}(14:31,3:length(PSD_raw{k,m}(1,:))));
                    time_slider = process_raw{k,m}(index_t,1);
                    time_end = process_raw{k,m}(end,1);
                    a = 1:ceil((time_end - time_slider)/10);
                    time_array = process_raw{k,m}(index_t:length(process_raw{k,m}),1);
                    part{1,1} = time_array(time_array<=(10+time_slider));
                    for no_psd = 2:length(a)
                        part{no_psd,1} = time_array(time_array<=time_slider+10*no_psd & time_array>max(part{no_psd-1,1}));
                    end
                    %                     pv_length = ceil(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     if length(pv_f102_high)/length(PSD_theta{k,m}) < ceil(length(pv_f102_high)/length(PSD_theta{k,m}))-0.5
                    %                         pv_length = floor(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     end
                    %                     part = length(PSD_theta{k,m});
                    %                     if length(part)==3
                    if length(part)==3
                        for n = 2:length(part)
                            zone_diff_F105_high{1} = cell2mat(diff_F105_high(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F105_high{n} = cell2mat(diff_F105_high(1,sum(cellfun('length',zone_diff_F105_high))+1:sum(cellfun('length',zone_diff_F105_high)):length(diff_F105_high)));
                            elseif n ~= length(part)
                                zone_diff_F105_high{n} = cell2mat(diff_F105_high(1,sum(cellfun('length',zone_diff_F105_high))+1:sum(cellfun('length',zone_diff_F105_high))+length(part{n,1})));
                            end
                        end
                    else
                        for n = 2:length(part)
                            zone_diff_F105_high{1} = cell2mat(diff_F105_high(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_F105_high{n} = cell2mat(diff_F105_high(1,sum(cellfun('length',zone_diff_F105_high))+1:sum(cellfun('length',zone_diff_F105_high)):length(diff_F105_high)));
                            elseif n ~= length(part)
                                zone_diff_F105_high{n} = cell2mat(diff_F105_high(1,sum(cellfun('length',zone_diff_F105_high))+1:sum(cellfun('length',zone_diff_F105_high))+length(part{n,1})));
                            end
                        end
                    end
                end
                
                
                %% T104,T105,T106 High and LOW alarms
                
                if sum(strcmpi(alarm_name1{k,m}(1,1), 'T105_low'))>=1
                    % T105 LOW ALARM
                    %                     index_t(1,a) = find(process_raw{k,m}(:,9)<T105_ll);
                    
                    time_alarm_slider_action = mouseclick{k,m}(4,1);
                    range1 = mouseclick{k,m}(4,1) +1;
                    range2 = mouseclick{k,m}(4,1) -1;
                    range = [range2:range1];
                    for a = 1:3
                        if length(find(process_raw{k,m}(:,1)==range(1))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(1)));
                        end
                        if length(find(process_raw{k,m}(:,1)==range(2))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(2)));
                        end
                        if length(find(process_raw{k,m}(:,1)==range(3))) ==1
                            index_t(1,a) = (find(process_raw{k,m}(:,1)==range(3)));
                        end
                    end
                    index_t = max(index_t);
                    pv_t105_low = process_raw{k,m}(index_t:length(process_raw{k,m}(:,1)),9);
                    for j = 1:length(pv_t105_low)
                        if pv_t105_low(j) > T105_ul
                            diff_T105_low{j} = T105_ul - pv_t105_low(j);
                        elseif pv_t105_low(j)<T105_ll
                            diff_T105_low{j} = pv_t105_low(j) - T105_ll;
                        elseif pv_t105_low(j)<T105_ul && pv_t105_low(j)>T105_ll
                            diff_T105_low{j} = pv_t105_low(j) - T105_ll;
                        end
                    end
                    diff_T105_low = diff_T105_low;
                    length_action = length(PSD_raw{k,m}(1,:));
                    PSD_theta{k,m} = mean(PSD_raw{k,m}(5:8,3:length(PSD_raw{k,m}(1,:))));
                    PSD_beta{k,m} = mean(PSD_raw{k,m}(9:13,3:length(PSD_raw{k,m}(1,:))));
                    PSD_alpha{k,m} = mean(PSD_raw{k,m}(14:31,3:length(PSD_raw{k,m}(1,:))));
                    time_slider = process_raw{k,m}(index_t,1);
                    time_end = process_raw{k,m}(end,1);
                    a = 1:ceil((time_end - time_slider)/10);
                    time_array = process_raw{k,m}(index_t:length(process_raw{k,m}),1);
                    part{1,1} = time_array(time_array<=(10+time_slider));
                    for no_psd = 2:length(a)
                        part{no_psd,1} = time_array(time_array<=time_slider+10*no_psd & time_array>max(part{no_psd-1,1}));
                    end
                    %                     pv_length = ceil(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     if length(pv_f102_high)/length(PSD_theta{k,m}) < ceil(length(pv_f102_high)/length(PSD_theta{k,m}))-0.5
                    %                         pv_length = floor(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     end
                    %                     part = length(PSD_theta{k,m});
                    %                     if length(part)==3
                    if length(part)==3
                        for n = 2:length(part)
                            zone_diff_T105_low{1} = cell2mat(diff_T105_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_T105_low{n} = cell2mat(diff_T105_low(1,sum(cellfun('length',zone_diff_T105_low))+1:sum(cellfun('length',zone_diff_T105_low)):length(diff_T105_low)));
                            elseif n ~= length(part)
                                zone_diff_T105_low{n} = cell2mat(diff_T105_low(1,sum(cellfun('length',zone_diff_T105_low))+1:sum(cellfun('length',zone_diff_T105_low))+length(part{n,1})));
                            end
                        end
                    else
                        for n = 2:length(part)
                            zone_diff_T105_low{1} = cell2mat(diff_T105_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_T105_low{n} = cell2mat(diff_T105_low(1,sum(cellfun('length',zone_diff_T105_low))+1:sum(cellfun('length',zone_diff_T105_low)):length(diff_T105_low)));
                            elseif n ~= length(part)
                                zone_diff_T105_low{n} = cell2mat(diff_T105_low(1,sum(cellfun('length',zone_diff_T105_low))+1:sum(cellfun('length',zone_diff_T105_low))+length(part{n,1})));
                            end
                        end
                    end
                    clear part
                    
                    % T104_low ALARM
                    % index = find(process_raw{k,m}(:,10)<T104_ll);
                    pv_t104_low = process_raw{k,m}(index_t:length(process_raw{k,m}(:,1)),10);
                    for j = 1:length(pv_t104_low)
                        if pv_t104_low(j) > T104_ul
                            diff_T104_low{j} = T104_ul - pv_t104_low(j);
                        elseif pv_t104_low(j)<T104_ll
                            diff_T104_low{j} = pv_t104_low(j) - T104_ll;
                        elseif pv_t104_low(j)<T104_ul && pv_t104_low(j)>T104_ll
                            diff_T104_low{j} = pv_t104_low(j) - T104_ll;
                        end
                    end
                    diff_T104_low = diff_T104_low;
                    length_action = length(PSD_raw{k,m}(1,:));
                    PSD_theta{k,m} = mean(PSD_raw{k,m}(5:8,3:length(PSD_raw{k,m}(1,:))));
                    PSD_beta{k,m} = mean(PSD_raw{k,m}(9:13,3:length(PSD_raw{k,m}(1,:))));
                    PSD_alpha{k,m} = mean(PSD_raw{k,m}(14:31,3:length(PSD_raw{k,m}(1,:))));
                    time_slider = process_raw{k,m}(index_t,1);
                    time_end = process_raw{k,m}(end,1);
                    a = 1:ceil((time_end - time_slider)/10);
                    time_array = process_raw{k,m}(index_t:length(process_raw{k,m}),1);
                    part{1,1} = time_array(time_array<=(10+time_slider));
                    for no_psd = 2:length(a)
                        part{no_psd,1} = time_array(time_array<=time_slider+10*no_psd & time_array>max(part{no_psd-1,1}));
                    end
                    %                     pv_length = ceil(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     if length(pv_f102_high)/length(PSD_theta{k,m}) < ceil(length(pv_f102_high)/length(PSD_theta{k,m}))-0.5
                    %                         pv_length = floor(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     end
                    %                     part = length(PSD_theta{k,m});
                    %                     if length(part)==3
                    if length(part)==3
                        for n = 2:length(part)
                            zone_diff_T104_low{1} = cell2mat(diff_T104_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_T104_low{n} = cell2mat(diff_T104_low(1,sum(cellfun('length',zone_diff_T104_low))+1:sum(cellfun('length',zone_diff_T104_low)):length(diff_T104_low)));
                            elseif n ~= length(part)
                                zone_diff_T104_low{n} = cell2mat(diff_T104_low(1,sum(cellfun('length',zone_diff_T104_low))+1:sum(cellfun('length',zone_diff_T104_low))+length(part{n,1})));
                            end
                        end
                    else
                        for n = 2:length(part)
                            zone_diff_T104_low{1} = cell2mat(diff_T104_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_T104_low{n} = cell2mat(diff_T104_low(1,sum(cellfun('length',zone_diff_T104_low))+1:sum(cellfun('length',zone_diff_T104_low)):length(diff_T104_low)));
                            elseif n ~= length(part)
                                zone_diff_T104_low{n} = cell2mat(diff_T104_low(1,sum(cellfun('length',zone_diff_T104_low))+1:sum(cellfun('length',zone_diff_T104_low))+length(part{n,1})));
                            end
                        end
                    end
                    clear part
                    
                    
                    % T106 LOW ALARM
                    % index = find(process_raw{k,m}(:,8)<T106_ll);
                    pv_t106_low = process_raw{k,m}(index_t:length(process_raw{k,m}(:,1)),8);
                    for j = 1:length(pv_t106_low)
                        if pv_t106_low(j) > T106_ul
                            diff_T106_low{j} = T106_ul - pv_t106_low(j);
                        elseif pv_t106_low(j)<T106_ll
                            diff_T106_low{j} = pv_t106_low(j) - T106_ll;
                        elseif pv_t106_low(j)<T106_ul && pv_t106_low(j)>T106_ll
                            diff_T106_low{j} = pv_t106_low(j) - T106_ll;
                        end
                    end
                    diff_T106_low = diff_T106_low;
                    length_action = length(PSD_raw{k,m}(1,:));
                    PSD_theta{k,m} = mean(PSD_raw{k,m}(5:8,3:length(PSD_raw{k,m}(1,:))));
                    PSD_beta{k,m} = mean(PSD_raw{k,m}(9:13,3:length(PSD_raw{k,m}(1,:))));
                    PSD_alpha{k,m} = mean(PSD_raw{k,m}(14:31,3:length(PSD_raw{k,m}(1,:))));
                    time_slider = process_raw{k,m}(index_t,1);
                    time_end = process_raw{k,m}(end,1);
                    a = 1:ceil((time_end - time_slider)/10);
                    time_array = process_raw{k,m}(index_t:length(process_raw{k,m}),1);
                    part{1,1} = time_array(time_array<=(10+time_slider));
                    for no_psd = 2:length(a)
                        part{no_psd,1} = time_array(time_array<=time_slider+10*no_psd & time_array>max(part{no_psd-1,1}));
                    end
                    %                     pv_length = ceil(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     if length(pv_f102_high)/length(PSD_theta{k,m}) < ceil(length(pv_f102_high)/length(PSD_theta{k,m}))-0.5
                    %                         pv_length = floor(length(pv_f102_high)/length(PSD_theta{k,m}));
                    %                     end
                    %                     part = length(PSD_theta{k,m});
                    %                     if length(part)==3
                    if length(part)==3
                        for n = 2:length(part)
                            zone_diff_T106_low{1} = cell2mat(diff_T106_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_T106_low{n} = cell2mat(diff_T106_low(1,sum(cellfun('length',zone_diff_T106_low))+1:sum(cellfun('length',zone_diff_T106_low)):length(diff_T106_low)));
                            elseif n ~= length(part)
                                zone_diff_T106_low{n} = cell2mat(diff_T106_low(1,sum(cellfun('length',zone_diff_T106_low))+1:sum(cellfun('length',zone_diff_T106_low))+length(part{n,1})));
                            end
                        end
                    else
                        for n = 2:length(part)
                            zone_diff_T106_low{1} = cell2mat(diff_T106_low(1,1:length(part{1,1})));
                            if n == length(part)
                                zone_diff_T106_low{n} = cell2mat(diff_T106_low(1,sum(cellfun('length',zone_diff_T106_low))+1:sum(cellfun('length',zone_diff_T106_low)):length(diff_T106_low)));
                            elseif n ~= length(part)
                                zone_diff_T106_low{n} = cell2mat(diff_T106_low(1,sum(cellfun('length',zone_diff_T106_low))+1:sum(cellfun('length',zone_diff_T106_low))+length(part{n,1})));
                            end
                        end
                    end
                end
                
                
                %% CODE FOR FINDING FAILED AND PASSED INDEX
                if sum(strcmpi(txtData1{k,m}(:,1),'Automatic_Shutdown'))==1 || sum(strcmpi(txtData1{k,m}(:,1),'Emergency_Shutdown'))==1
                    index_fail{k,m} = 1;
                else
                    index_fail{k,m} = 0;
                end
                indexfail{k,m} = index_fail{k,m};
                
                %% CODE FOR FINDING THE MATCHES AND MISMATCHES
                variablesToConcatenate = {};
                variablesToConcatenate{end+1} = 'zone_diff_C101_low';
                variablesToConcatenate{end+1} = 'zone_diff_F101_low';
                variablesToConcatenate{end+1} = 'zone_diff_F105_low';
                variablesToConcatenate{end+1} = 'zone_diff_F105_high';
                variablesToConcatenate{end+1} = 'zone_diff_F101_high';
                variablesToConcatenate{end+1} = 'zone_diff_C101_high';
                variablesToConcatenate{end+1} = 'zone_diff_F102_high';
                variablesToConcatenate{end+1} = 'zone_diff_F102_low';
                variablesToConcatenate{end+1} = 'zone_diff_T104_high';
                variablesToConcatenate{end+1} = 'zone_diff_T105_high';
                variablesToConcatenate{end+1} = 'zone_diff_T106_high';
                variablesToConcatenate{end+1} = 'zone_diff_T104_low';
                variablesToConcatenate{end+1} = 'zone_diff_T105_low';
                variablesToConcatenate{end+1} = 'zone_diff_T106_low';
                
                numberOfVariables = length(variablesToConcatenate);
                
                result = {};
                result{1} = [];
                result{2} = [];
                result{3} = [];
                result{4} = [];
                result{5} = [];
                result{6} = [];
                result{7} = [];
                result{8} = [];
                result{9} = [];
                result{10} = [];
                result{11} = [];
                result{12} = [];
                result{13} = [];
                result{14} = [];
                
                
                if sum(strcmpi(alarm_name1{k,m}(1,1), 'T105_low'))>=1
                    indexNonZero1 = [13 14 12];
                elseif sum(strcmpi(alarm_name1{k,m}(1,1), 'F101_low'))>=1
                    indexNonZero1 = [2 3 6];
                elseif sum(strcmpi(alarm_name1{k,m}(1,1), 'F101_high'))>=1
                    indexNonZero1 = [5 4 1];
                elseif sum(strcmpi(alarm_name1{k,m}(1,1), 'F102_high'))>=1
                    indexNonZero1 = 7;
                else
                    indexNonZero1 = 8;
                end
                
                
                %                 indexNonZero = {};
                %                 for i = 1:numberOfVariables
                %                     indexNonZero{i} = find(~isempty(eval(variablesToConcatenate{1,i})));
                %                 end
                %                 indexNonZero1 = find(~cellfun(@isempty,indexNonZero));
                
                
                if length(indexNonZero1) ==1
                    currentVariable = variablesToConcatenate{indexNonZero1};
                    for internalIndex = 1:length(part)
                        a = [];
                        if isempty(eval(strcat(currentVariable,'{',num2str(internalIndex),'}',strcat('(',currentVariable,'{',num2str(internalIndex),'}','<0)'))))
                            result{internalIndex} = [a 0];
                        elseif ~isempty(eval(strcat(currentVariable,'{',num2str(internalIndex),'}',strcat('(',currentVariable,'{',num2str(internalIndex),'}','<0)'))))
                            result{internalIndex} = [a  eval(strcat(currentVariable,'{',num2str(internalIndex),'}',strcat('(',currentVariable,'{',num2str(internalIndex),'}','<0)')))];
                        end
                    end
                elseif length(indexNonZero1)>1
                    for index = 1:length(indexNonZero1)
                        currentVariable = variablesToConcatenate{indexNonZero1(index)};
                        for internalIndex = 1:length(part)
                            a = [];
                            if isempty(eval(strcat(currentVariable,'{',num2str(internalIndex),'}',strcat('(',currentVariable,'{',num2str(internalIndex),'}','<0)'))))
                                result{index,internalIndex} = [a 0];
                            elseif ~isempty(eval(strcat(currentVariable,'{',num2str(internalIndex),'}',strcat('(',currentVariable,'{',num2str(internalIndex),'}','<0)'))))
                                result{index,internalIndex} = [a  eval(strcat(currentVariable,'{',num2str(internalIndex),'}',strcat('(',currentVariable,'{',num2str(internalIndex),'}','<0)')))];
                            end
                        end
                    end
                end
                result1{k,m} = result;
                
                %% Giving if match or mismatch
                % Giving if match or mismatch for Theta
                for v = 1:length(result(:,1))
                    for n = 1:length(part)-1
                        if sum(result{v,n}) <0 && sum(result{v,n+1}) < 0 && abs(sum(result{v,n})) <= abs(sum(result{v,n+1})) && PSD_theta{k,m}(1,n)<PSD_theta{k,m}(1,n+1)
                            conclusion_theta{k,m}{v,n} = -1;
                        elseif sum(result{v,n}) <0 && sum(result{v,n+1}) < 0 && abs(sum(result{v,n}))>= abs(sum(result{v,n+1})) && PSD_theta{k,m}(1,n)>PSD_theta{k,m}(1,n+1)
                            conclusion_theta{k,m}{v,n} = 1;
                        elseif sum(result{v,n}) == 0 && sum(result{v,n+1}) == 0 && PSD_theta{k,m}(1,n)>PSD_theta{k,m}(1,n+1)
                            conclusion_theta{k,m}{v,n} = 1;
                        elseif sum(result{v,n}) == 0 && sum(result{v,n+1}) < 0 && PSD_theta{k,m}(1,n)<PSD_theta{k,m}(1,n+1)
                            conclusion_theta{k,m}{v,n} = -1;
                        elseif sum(result{v,n}) < 0 && sum(result{v,n+1}) == 0 && PSD_theta{k,m}(1,n)>PSD_theta{k,m}(1,n+1)
                            conclusion_theta{k,m}{v,n} = 1;
                        else
                            conclusion_theta{k,m}{v,n} = 0;
                        end
                    end
                end
                
                % Giving if match or mismatch for Alpha
                for v = 1:length(result(:,1))
                    for n = 1:length(part)-1
                        if sum(result{v,n}) <0 && sum(result{v,n+1}) < 0 && abs(sum(result{v,n})) <= abs(sum(result{v,n+1})) && PSD_alpha{k,m}(1,n)>PSD_alpha{k,m}(1,n+1)
                            conclusion_alpha{k,m}{v,n} = -1;
                        elseif sum(result{v,n}) <0 && sum(result{v,n+1}) < 0 && abs(sum(result{v,n})) >= abs(sum(result{v,n+1})) && PSD_alpha{k,m}(1,n)<PSD_alpha{k,m}(1,n+1)
                            conclusion_alpha{k,m}{v,n} = 1;
                        elseif sum(result{v,n}) == 0 && sum(result{v,n+1}) == 0 && PSD_alpha{k,m}(1,n) < PSD_alpha{k,m}(1,n+1)
                            conclusion_alpha{k,m}{v,n} = 1;
                        elseif sum(result{v,n}) == 0 && sum(result{v,n+1}) < 0 && PSD_alpha{k,m}(1,n)> PSD_alpha{k,m}(1,n+1)
                            conclusion_alpha{k,m}{v,n} = -1;
                        elseif sum(result{v,n}) < 0 && sum(result{v,n+1}) == 0 && PSD_alpha{k,m}(1,n) < PSD_alpha{k,m}(1,n+1)
                            conclusion_alpha{k,m}{v,n} = 1;
                        else
                            conclusion_alpha{k,m}{v,n} = 0;
                        end
                    end
                end
                
                % Giving if match or mismatch for Beta
                for v = 1:length(result(:,1))
                    for n = 1:length(part)-1
                        if sum(result{v,n}) <0 && sum(result{v,n+1}) < 0 && abs(sum(result{v,n})) <= abs(sum(result{v,n+1})) && PSD_beta{k,m}(1,n)<PSD_beta{k,m}(1,n+1)
                            conclusion_beta{k,m}{v,n} = -1;
                        elseif sum(result{v,n}) <0 && sum(result{v,n+1}) < 0 && abs(sum(result{v,n}))>= abs(sum(result{v,n+1})) && PSD_beta{k,m}(1,n)>PSD_beta{k,m}(1,n+1)
                            conclusion_beta{k,m}{v,n} = 1;
                        elseif sum(result{v,n}) == 0 && sum(result{v,n+1}) == 0 && PSD_beta{k,m}(1,n)>PSD_beta{k,m}(1,n+1)
                            conclusion_beta{k,m}{v,n} = 1;
                        elseif sum(result{v,n}) == 0 && sum(result{v,n+1}) < 0 && PSD_beta{k,m}(1,n)<PSD_beta{k,m}(1,n+1)
                            conclusion_beta{k,m}{v,n} = -1;
                        elseif sum(result{v,n}) < 0 && sum(result{v,n+1}) == 0 && PSD_beta{k,m}(1,n)>PSD_beta{k,m}(1,n+1)
                            conclusion_beta{k,m}{v,n} = 1;
                        else
                            conclusion_beta{k,m}{v,n} = 0;
                        end
                    end
                end
                
                
                PSD_BETA_Action_only{destination,1}{k,m}  =PSD_beta{k,m}; % Contains PSD only in the Action medium
                PSD_THETA_Action_only{destination,1}{k,m} =PSD_theta{k,m};
                PSD_ALPHA_Action_only{destination,1}{k,m} =PSD_alpha{k,m};
                
                PSD_BETA_Rest{destination,1}{k} = mean(PSD_raw_rest{destination,1}{k}(14:31,:));
                PSD_THETA_Rest{destination,1}{k} =mean(PSD_raw_rest{destination,1}{k}(5:8,:));
                PSD_ALPHA_Rest{destination,1}{k} =mean(PSD_raw_rest{destination,1}{k}(9:13,:));
                
                PSD_BETA_Observation{destination,1}{k,m}  = mean(PSD_raw{k,m}(14:31,1)); % PSD of Observation period only
                PSD_THETA_Observation{destination,1}{k,m} = mean(PSD_raw{k,m}(5:8,1));
                PSD_ALPHA_Observation{destination,1}{k,m} = mean(PSD_raw{k,m}(9:13,1));
                
                PSD_BETA_decision{destination,1}{k,m} =  mean(PSD_raw{k,m}(14:31,2)); % PSD of decison only
                PSD_THETA_decision{destination,1}{k,m} = mean(PSD_raw{k,m}(5:8,2));
                PSD_ALPHA_decision{destination,1}{k,m} = mean(PSD_raw{k,m}(9:13,2));
                
                PSD_BETA_Action_with_decision{destination,1}{k,m} = [PSD_beta{k,m} PSD_BETA_decision{destination,1}{k,m} ]; % Contains PSD including the decision medium
                PSD_THETA_Action_with_decision{destination,1}{k,m} =[PSD_theta{k,m} PSD_THETA_decision{destination,1}{k,m}];
                PSD_ALPHA_Action_with_decision{destination,1}{k,m} =[PSD_alpha{k,m} PSD_ALPHA_decision{destination,1}{k,m}];
                
                PSD_BETA_full_task{destination,1}{k,m} = [PSD_BETA_Observation{destination,1}{k,m} PSD_BETA_decision{destination,1}{k,m} PSD_beta{k,m}]; % Contains PSD including the decision medium
                PSD_THETA_full_task{destination,1}{k,m} =[PSD_THETA_Observation{destination,1}{k,m} PSD_THETA_decision{destination,1}{k,m} PSD_theta{k,m}];
                PSD_ALPHA_full_task{destination,1}{k,m} =[PSD_ALPHA_Observation{destination,1}{k,m} PSD_ALPHA_decision{destination,1}{k,m} PSD_alpha{k,m}];
                
                %% Calculation of variance of Rest and Action phase
                
                PSD_Theta_variance_rest{destination,1}{k}          = var(PSD_THETA_Rest{destination,1}{k});
                PSD_Beta_variance_rest{destination,1}{k}           = var(PSD_BETA_Rest{destination,1}{k});
                PSD_Alpha_variance_rest{destination,1}{k}          = var(PSD_ALPHA_Rest{destination,1}{k});
                
                PSD_Theta_variance_task_action{destination,1}{k,m} = var(PSD_THETA_Action_only{destination,1}{k,m});
                PSD_Alpha_variance_task_action{destination,1}{k,m} = var(PSD_ALPHA_Action_only{destination,1}{k,m});
                PSD_Beta_variance_task_action{destination,1}{k,m}  = var(PSD_BETA_Action_only{destination,1}{k,m});
                
                PSD_Theta_variance_task_with_decision{destination,1}{k,m} = var(PSD_THETA_Action_with_decision{destination,1}{k,m});
                PSD_Alpha_variance_task_with_decision{destination,1}{k,m} = var(PSD_ALPHA_Action_with_decision{destination,1}{k,m});
                PSD_Beta_variance_task_with_decision{destination,1}{k,m}  = var(PSD_BETA_Action_with_decision{destination,1}{k,m});
                
                PSD_Theta_variance_fulltask{destination,1}{k,m} = var(PSD_THETA_full_task{destination,1}{k,m});
                PSD_Alpha_variance_fulltask{destination,1}{k,m} = var(PSD_ALPHA_full_task{destination,1}{k,m});
                PSD_Beta_variance_fulltask{destination,1}{k,m}  = var(PSD_BETA_full_task{destination,1}{k,m});
                
                %% Calculation of Standard deviation of Rest and Action phase and Observation 
                PSD_Theta_std_rest{destination,1}{k}          = std(PSD_THETA_Rest{destination,1}{k});
                PSD_Beta_std_rest{destination,1}{k}           = std(PSD_BETA_Rest{destination,1}{k});
                PSD_Alpha_std_rest{destination,1}{k}          = std(PSD_ALPHA_Rest{destination,1}{k});
                
                PSD_Theta_std_task_action{destination,1}{k,m} = std(PSD_THETA_Action_only{destination,1}{k,m});
                PSD_Alpha_std_task_action{destination,1}{k,m} = std(PSD_ALPHA_Action_only{destination,1}{k,m});
                PSD_Beta_std_task_action{destination,1}{k,m}  = std(PSD_BETA_Action_only{destination,1}{k,m});
                
                PSD_Theta_std_task_with_decision{destination,1}{k,m}    = std(PSD_THETA_Action_with_decision{destination,1}{k,m});
                PSD_Alpha_std_taskall_with_decision{destination,1}{k,m} = std(PSD_ALPHA_Action_with_decision{destination,1}{k,m});
                PSD_Beta_std_taskall_with_decision{destination,1}{k,m}  = std(PSD_BETA_Action_with_decision{destination,1}{k,m});

                PSD_Theta_std_fulltask{destination,1}{k,m} = std(PSD_THETA_full_task{destination,1}{k,m});
                PSD_Alpha_std_fulltask{destination,1}{k,m} = std(PSD_ALPHA_full_task{destination,1}{k,m});
                PSD_Beta_std_fulltask{destination,1}{k,m}  = std(PSD_BETA_full_task{destination,1}{k,m});
                
                %% Comparison of means of rest and Standard deviation
                PSD_Theta_mean_rest{destination,1}{k}          = mean(PSD_THETA_Rest{destination,1}{k});
                PSD_Beta_mean_rest{destination,1}{k}           = mean(PSD_BETA_Rest{destination,1}{k});
                PSD_Alpha_mean_rest{destination,1}{k}          = mean(PSD_ALPHA_Rest{destination,1}{k});
                
                PSD_Theta_mean_task_action{destination,1}{k,m} = mean(PSD_THETA_Action_only{destination,1}{k,m});
                PSD_Alpha_mean_task_action{destination,1}{k,m} = mean(PSD_ALPHA_Action_only{destination,1}{k,m});
                PSD_Beta_mean_task_action{destination,1}{k,m}  = mean(PSD_BETA_Action_only{destination,1}{k,m});
                
                PSD_Theta_mean_task_with_decision{destination,1}{k,m}    = mean(PSD_THETA_Action_with_decision{destination,1}{k,m});
                PSD_Alpha_mean_taskall_with_decision{destination,1}{k,m} = mean(PSD_ALPHA_Action_with_decision{destination,1}{k,m});
                PSD_Beta_mean_taskall_with_decision{destination,1}{k,m}  = mean(PSD_BETA_Action_with_decision{destination,1}{k,m});
                
                PSD_Theta_mean_fulltask{destination,1}{k,m} = mean(PSD_THETA_full_task{destination,1}{k,m});
                PSD_Alpha_mean_fulltask{destination,1}{k,m} = mean(PSD_ALPHA_full_task{destination,1}{k,m});
                PSD_Beta_mean_fulltask{destination,1}{k,m}  = mean(PSD_BETA_full_task{destination,1}{k,m});
            end
        end
        result_overall{destination,1} = result1;
        conclusion_overall_theta{destination,1} = conclusion_theta;
        conclusion_overall_alpha{destination,1} = conclusion_alpha;
        conclusion_overall_beta{destination,1} = conclusion_beta;
        result{destination,1} = result;
        
    end
end

% %% Plotting the variation of theta, beta and alpha for variance, std deviation and mean
% for destination = 1:10
%     clear conclusion
%     warning('off')
%     format short g
%     Main_Folder = 'D:\Mahindra\From Rest Period\4_points_to_10seconds_expt_file\4_points_new\4_point\EEGDATA\';
%     person = {strcat('P',num2str(destination))};
%     participant = char(person);
%     
%     for i = 1
%         if i == 1
%             sch = 'm';
%             Parent_Folder=strcat(Main_Folder,participant,'\Morning\'); % Folder destination
%             AllFile=dir(fullfile(Parent_Folder,'*P*')); % Subfolders starting letter
%             File_link=AllFile([AllFile.isdir]);
%             Folder = natsortfiles({File_link.name});
%             for i= 1:length(Folder)      % Assigning sorted value in AllFile in order
%                 AllFile(i).name = Folder{i};
%             end
%             Folder = AllFile;
%             %             fold_nms1 = Folder;
%             %             fold_nms2 = char(fold_nms1);
%         end
%     end
%     name_participant{destination} = strcat(' OPERATOR - ',num2str(destination));
%     for m = 1
%         Properties = [" VARIANCE", " STD DEVIATION" ," MEAN"];
%         statistic = ["variance","std","mean"];
%         waves = ["Theta","Alpha","Beta"];
%         for plotstat = 1:3
%             for wave = 1:3
%                 for sample = 1:2
%                     if sample == 1
%                         figure(plotstat)
%                         type = '_task_action';
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m),')')));
%                         vector = [base,task_value];
%                         figure(plotstat)
%                         %                             title(strcat('PSD ',Properties(plotstat),' COMPARISON IN REST AND ACTION PHASE FOR ',name_participant{destination}))
%                         s(m) = subplot(2,6,m);
%                         bar(vector,1);
%                         ylabel(strcat('Task 1 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                         
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m+1),')')));
%                         vector = [base,task_value];
%                         s(m+1) = subplot(2,6,(m+1));
%                         bar(vector,1);
%                         ylabel(strcat('Task 2 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                         
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m+2),')')));
%                         vector = [base,task_value];
%                         s(m+2)=subplot(2,6,(m+2));
%                         bar(vector,1);
%                         ylabel(strcat('Task 3 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                         
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m+3),')')));
%                         vector = [base,task_value];
%                         s(m+3)=subplot(2,6,(m+3));
%                         bar(vector,1);
%                         ylabel(strcat('Task 4 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                         
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m+4),')')));
%                         vector = [base,task_value];
%                         s(m+4) = subplot(2,6,(m+4));
%                         bar(vector,1);
%                         ylabel(strcat('Task 5 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                         
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m+5),')')));
%                         vector = [base,task_value];
%                         s(m+5) = subplot(2,6,(m+5));
%                         bar(vector,1);
%                         ylabel(strcat('Task 6 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                         
%                     else
%                         type = '_fulltask';
%                         
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m),')')));
%                         vector = [base,task_value];
%                         figure(plotstat)
%                         %                             title(strcat('PSD ',Properties(plotstat),' COMPARISON IN REST AND ACTION PHASE FOR ',name_participant{destination}))
%                         s(m+6)= subplot(2,6,m+6);
%                         bar(vector,1);
%                         ylabel(strcat('Task 1 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                         
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m+1),')')));
%                         vector = [base,task_value];
%                         s(m+7) = subplot(2,6,(m+7));
%                         bar(vector,1);
%                         ylabel(strcat('Task 2 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                         
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m+2),')')));
%                         vector = [base,task_value];
%                         s(m+8) = subplot(2,6,(m+6+2));
%                         bar(vector,1);
%                         ylabel(strcat('Task 3 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                         
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m+3),')')));
%                         vector = [base,task_value];
%                         s(m+9) = subplot(2,6,(m+6+3));
%                         bar(vector,1);
%                         ylabel(strcat('Task 4 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                         
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m+4),')')));
%                         vector = [base,task_value];
%                         s(m+10) = subplot(2,6,(m+6+4));
%                         bar(vector,1);
%                         ylabel(strcat('Task 5 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                         
%                         base = transpose(cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),'_rest{',num2str(destination),',',num2str(1),'}'))));
%                         task_value = cell2mat(eval(strcat('PSD_',waves(wave),'_',statistic(plotstat),type,'{',num2str(destination),',',num2str(1),'}(:,',num2str(m+5),')')));
%                         vector = [base,task_value];
%                         s(m+11) = subplot(2,6,(m+6+5));
%                         bar(vector,1);
%                         ylabel(strcat('Task 6 - ',upper(waves(wave)),'-',upper(statistic(plotstat))))
%                         xlabel('Experiment')
%                         xlim([0 length(Folder)+1])
%                     end
%                     
%                     a = axes;
%                     t1 = title(strcat(name_participant{destination},'-',Properties(plotstat),'-',upper(waves(wave)),' REST AND ACTION'));
%                     a.Visible = 'off'; % set(a,'Visible','off');
%                     t1.Visible = 'on'; % set(t1,'Visible','on');
%                     set(figure(plotstat), 'units','normalized','outerposition',[0 0 1 1])
%                     linkaxes(s,'xy')
%                     saveas(figure(plotstat),fullfile(strcat(Main_Folder,participant),[strcat(name_participant{destination},' EXPERIMENT- ',upper(waves(wave)),'-',Properties(plotstat),'_TASK_ALL', '.png')]));
%                 end
%                 close all
%             end
%         end
%     end
% end
%% CONCLUSION NEW FROM OVERALL CONCLUSION ABOVE IN THETA ALPHA AND BETA
for Participant = 1:10
    for i = 1:size(conclusion_overall_theta{Participant,1},1)
        for m=1:6
            for No_alarms = 1:size(conclusion_overall_theta{Participant,1}{i,m},1)
                for length_alarms = 1:size(conclusion_overall_theta{Participant,1}{i,m},2)
                    if sum(cell2mat(conclusion_overall_theta{Participant,1}{i,m}(:,length_alarms)))>=1
                        Conclusion_theta{Participant,1}{i,m}(1,length_alarms) = 1;
                    elseif sum(cell2mat(conclusion_overall_theta{Participant,1}{i,m}(:,length_alarms)))<= -1
                        Conclusion_theta{Participant,1}{i,m}(1,length_alarms) = -1;
                    else
                        Conclusion_theta{Participant,1}{i,m}(1,length_alarms) = 0;
                    end
                end
            end
        end
    end
end

% ALPHA
for Participant = 1:10
    for i = 1:size(conclusion_overall_alpha{Participant,1},1)
        for m=1:6
            for No_alarms = 1:size(conclusion_overall_alpha{Participant,1}{i,m},1)
                for length_alarms = 1:size(conclusion_overall_alpha{Participant,1}{i,m},2)
                    if sum(cell2mat(conclusion_overall_alpha{Participant,1}{i,m}(:,length_alarms)))>=1
                        Conclusion_alpha{Participant,1}{i,m}(1,length_alarms) = 1;
                    elseif sum(cell2mat(conclusion_overall_alpha{Participant,1}{i,m}(:,length_alarms)))<= -1
                        Conclusion_alpha{Participant,1}{i,m}(1,length_alarms) = -1;
                    else
                        Conclusion_alpha{Participant,1}{i,m}(1,length_alarms) = 0;
                    end
                end
            end
        end
    end
end

% BETA
for Participant = 1:10
    for i = 1:size(conclusion_overall_beta{Participant,1},1)
        for m=1:6
            for No_alarms = 1:size(conclusion_overall_beta{Participant,1}{i,m},1)
                for length_alarms = 1:size(conclusion_overall_beta{Participant,1}{i,m},2)
                    if sum(cell2mat(conclusion_overall_beta{Participant,1}{i,m}(:,length_alarms)))>=1
                        Conclusion_beta{Participant,1}{i,m}(1,length_alarms) = 1;
                    elseif sum(cell2mat(conclusion_overall_beta{Participant,1}{i,m}(:,length_alarms)))<= -1
                        Conclusion_beta{Participant,1}{i,m}(1,length_alarms) = -1;
                    else
                        Conclusion_beta{Participant,1}{i,m}(1,length_alarms) = 0;
                    end
                end
            end
        end
    end
end


%% Percentage_Change_match_mismatch_Overall Participants all experiments in Theta , Alpha and Beta
% THETA
for Participant = 1:10
    for m=1:6
        for i = 1:size(Conclusion_theta{Participant,1},1)
            length_PSD = length(PSD_THETA_Action_only{Participant,1}{i,m});
            for zone = 1:length(Conclusion_theta{Participant,1}{i,m})
                if PSD_THETA_Action_only{Participant,1}{i,m}(1,zone)>PSD_THETA_Action_only{Participant,1}{i,m}(1,zone+1) &&  Conclusion_theta{Participant,1}{i,m}(1,zone) == 1
                    Percentage_Change_match_mismatch_theta{i,m}(zone,1) = 100*(PSD_THETA_Action_only{Participant,1}{i,m}(1,zone+1) - PSD_THETA_Action_only{Participant,1}{i,m}(1,zone))/PSD_THETA_Action_only{Participant,1}{i,m}(1,zone);
                elseif PSD_THETA_Action_only{Participant,1}{i,m}(1,zone)<PSD_THETA_Action_only{Participant,1}{i,m}(1,zone+1) && Conclusion_theta{Participant,1}{i,m}(1,zone) ==-1
                    Percentage_Change_match_mismatch_theta{i,m}(zone,1) = 100*(PSD_THETA_Action_only{Participant,1}{i,m}(1,zone+1) - PSD_THETA_Action_only{Participant,1}{i,m}(1,zone))/PSD_THETA_Action_only{Participant,1}{i,m}(1,zone);
                else
                    Percentage_Change_match_mismatch_theta{i,m}(zone,1) = NaN;
                end
            end
        end
    end
    Percentage_Change_match_mismatch_Overall_theta{Participant,1} = Percentage_Change_match_mismatch_theta;
    clear Percentage_Change_match_mismatch_theta
end

%ALPHA
a = [];
for Participant = 1:10
    for m=1:6
        for i = 1:size(Conclusion_alpha{Participant,1},1)
            length_PSD = length(PSD_ALPHA_Action_only{Participant,1}{i,m});
            for zone = 1:length(Conclusion_alpha{Participant,1}{i,m})
                if PSD_ALPHA_Action_only{Participant,1}{i,m}(1,zone)<PSD_ALPHA_Action_only{Participant,1}{i,m}(1,zone+1) &&  Conclusion_alpha{Participant,1}{i,m}(1,zone) == 1
                    Percentage_Change_match_mismatch_alpha{i,m}(zone,1) = 100*(PSD_ALPHA_Action_only{Participant,1}{i,m}(1,zone+1) - PSD_ALPHA_Action_only{Participant,1}{i,m}(1,zone))/PSD_ALPHA_Action_only{Participant,1}{i,m}(1,zone);
                elseif PSD_ALPHA_Action_only{Participant,1}{i,m}(1,zone)>PSD_ALPHA_Action_only{Participant,1}{i,m}(1,zone+1) && Conclusion_alpha{Participant,1}{i,m}(1,zone) ==-1
                    Percentage_Change_match_mismatch_alpha{i,m}(zone,1) = 100*(PSD_ALPHA_Action_only{Participant,1}{i,m}(1,zone+1) - PSD_ALPHA_Action_only{Participant,1}{i,m}(1,zone))/PSD_ALPHA_Action_only{Participant,1}{i,m}(1,zone);
                else
                    Percentage_Change_match_mismatch_alpha{i,m}(zone,1) = NaN;
                end
            end
        end
    end
    Percentage_Change_match_mismatch_Overall_alpha{Participant,1} = Percentage_Change_match_mismatch_alpha;
    clear Percentage_Change_match_mismatch_alpha
end

% BETA
a = [];
for Participant = 1:10
    for m=1:6
        for i = 1:size(Conclusion_beta{Participant,1},1)
            length_PSD = length(PSD_BETA_Action_only{Participant,1}{i,m});
            for zone = 1:length(Conclusion_beta{Participant,1}{i,m})
                if PSD_BETA_Action_only{Participant,1}{i,m}(1,zone)>PSD_BETA_Action_only{Participant,1}{i,m}(1,zone+1) &&  Conclusion_beta{Participant,1}{i,m}(1,zone) == 1
                    Percentage_Change_match_mismatch_beta{i,m}(zone,1) = 100*(PSD_BETA_Action_only{Participant,1}{i,m}(1,zone+1) - PSD_BETA_Action_only{Participant,1}{i,m}(1,zone))/PSD_BETA_Action_only{Participant,1}{i,m}(1,zone);
                elseif PSD_BETA_Action_only{Participant,1}{i,m}(1,zone)<PSD_BETA_Action_only{Participant,1}{i,m}(1,zone+1) && Conclusion_beta{Participant,1}{i,m}(1,zone) ==-1
                    Percentage_Change_match_mismatch_beta{i,m}(zone,1) = 100*(PSD_BETA_Action_only{Participant,1}{i,m}(1,zone+1) - PSD_BETA_Action_only{Participant,1}{i,m}(1,zone))/PSD_BETA_Action_only{Participant,1}{i,m}(1,zone);
                else
                    Percentage_Change_match_mismatch_beta{i,m}(zone,1) = NaN;
                end
            end
        end
    end
    Percentage_Change_match_mismatch_Overall_beta{Participant,1} = Percentage_Change_match_mismatch_beta;
    clear Percentage_Change_match_mismatch_beta
end



%% MATCH, MISMATCH AND MISCLASSIFICATION
% THETA
for Participant = 1:10
    for i = 1 :size(Conclusion_theta{Participant,1},1)
        for m=1:6
            sum_i{i,m} = sum(Conclusion_theta{Participant,1}{i,m} == 1) + sum(Conclusion_theta{Participant,1}{i,m} == -1);
            sum_mismatch_theta{i,m} = sum(sum(Conclusion_theta{Participant,1}{i,m} == -1));
            sum_match_theta{i,m} = sum(sum(Conclusion_theta{Participant,1}{i,m} == 1));
            sum_misclassification_theta{i,m} = sum(sum(Conclusion_theta{Participant,1}{i,m} == 0)) ;
            sum_total_theta{i,m} = sum(Conclusion_theta{Participant,1}{i,m} == -1) + sum(Conclusion_theta{Participant,1}{i,m} == 1) +sum(Conclusion_theta{Participant,1}{i,m} == 0) ;
            
        end
        
        percentage_theta{i,1} = 100*sum(cell2mat(sum_i(i,:)))/sum(cell2mat(sum_total_theta(i,:)));
        SUM_MATCH_THETA{Participant,1}{i,1} = sum(cell2mat(sum_match_theta(i,:)));
        SUM_MISMATCH_THETA{Participant,1}{i,1} = sum(cell2mat(sum_mismatch_theta(i,:)));
        SUM_MISCLASSIFICATION_THETA{Participant,1}{i,1} = sum(cell2mat(sum_misclassification_theta(i,:)));
        SUM_TOTAL_THETA{Participant,1}{i,1} = sum(cell2mat(sum_total_theta(i,:)));
    end
    
    Sum_experiment_match_mismatch_theta{Participant,1} = cell2mat(sum_i);
    Sum_total_match_mismatch_misclassification_theta{Participant,1} = cell2mat(sum_total_theta);
    Percentage_theta_experiment{Participant,1} = cell2mat(percentage_theta');
    
    clear percentage_theta sum_total_theta sum_match_theta sum_mismatch_theta sum_i sum_misclassification_theta
end

% ALPHA
for Participant = 1:10
    for i = 1 :size(Conclusion_alpha{Participant,1},1)
        for m=1:6
            sum_i{i,m} = sum(Conclusion_alpha{Participant,1}{i,m} == 1) + sum(Conclusion_alpha{Participant,1}{i,m} == -1);
            sum_mismatch_alpha{i,m} = sum(sum(Conclusion_alpha{Participant,1}{i,m} == -1));
            sum_match_alpha{i,m} = sum(sum(Conclusion_alpha{Participant,1}{i,m} == 1));
            sum_misclassification_alpha{i,m} = sum(sum(Conclusion_alpha{Participant,1}{i,m} == 0)) ;
            sum_total_alpha{i,m} = sum(Conclusion_alpha{Participant,1}{i,m} == -1) + sum(Conclusion_alpha{Participant,1}{i,m} == 1) +sum(Conclusion_alpha{Participant,1}{i,m} == 0) ;

        end

        percentage_alpha{i,1} = 100*sum(cell2mat(sum_i(i,:)))/sum(cell2mat(sum_total_alpha(i,:)));
        SUM_MATCH_alpha{Participant,1}{i,1} = sum(cell2mat(sum_match_alpha(i,:)));
        SUM_MISMATCH_alpha{Participant,1}{i,1} = sum(cell2mat(sum_mismatch_alpha(i,:)));
        SUM_Misclassification_alpha{Participant,1}{i,1} = sum(cell2mat(sum_misclassification_alpha(i,:)));
        SUM_TOTAL_alpha{Participant,1}{i,1} = sum(cell2mat(sum_total_alpha(i,:)));
    end

    Sum_experiment_match_mismatch_alpha{Participant,1} = cell2mat(sum_i);
    Sum_total_match_mismatch_misclassification_alpha{Participant,1} = cell2mat(sum_total_alpha);
    Percentage_alpha_experiment{Participant,1} = cell2mat(percentage_alpha');

    clear percentage_alpha sum_total_alpha sum_match_alpha sum_mismatch_alpha sum_i sum_misclassification_alpha
end

% BETA
for Participant = 1:10
    for i = 1 :size(Conclusion_beta{Participant,1},1)
        for m=1:6
            sum_i{i,m} = sum(Conclusion_beta{Participant,1}{i,m} == 1) + sum(Conclusion_beta{Participant,1}{i,m} == -1);
            sum_mismatch_beta{i,m} = sum(sum(Conclusion_beta{Participant,1}{i,m} == -1));
            sum_match_beta{i,m} = sum(sum(Conclusion_beta{Participant,1}{i,m} == 1));
            sum_misclassification_beta{i,m} = sum(sum(Conclusion_beta{Participant,1}{i,m} == 0)) ;
            sum_total_beta{i,m} = sum(Conclusion_beta{Participant,1}{i,m} == -1) + sum(Conclusion_beta{Participant,1}{i,m} == 1) +sum(Conclusion_beta{Participant,1}{i,m} == 0) ;

        end

        percentage_beta_prediction{i,1} = 100*sum(cell2mat(sum_i(i,:)))/sum(cell2mat(sum_total_beta(i,:)));
        SUM_MATCH_beta{Participant,1}{i,1} = sum(cell2mat(sum_match_beta(i,:)));
        SUM_MISMATCH_beta{Participant,1}{i,1} = sum(cell2mat(sum_mismatch_beta(i,:)));
        SUM_MISCLASSIFICATION_beta{Participant,1}{i,1} = sum(cell2mat(sum_misclassification_beta(i,:)));
        SUM_TOTAL_beta{Participant,1}{i,1} = sum(cell2mat(sum_total_beta(i,:)));
    end

    Sum_experiment_match_mismatch_beta{Participant,1} = cell2mat(sum_i);
    Sum_total_match_mismatch_misclassification_beta{Participant,1} = cell2mat(sum_total_beta);
    Percentage_beta_experiment_beta{Participant,1} = cell2mat(percentage_beta_prediction');

    clear percentage_beta sum_total_beta sum_match_beta sum_mismatch_beta sum_i sum_misclassification_beta
end


% %% CONCLUSION NEW FROM OVERALL CONCLUSION ABOVE
% for Participant = 1:10
%     for i = 1:size(conclusion_overall{Participant,1},1)
%         for m=1:6
%             for No_alarms = 1:size(conclusion_overall{Participant,1}{i,m},1)
%                 for length_alarms = 1:size(conclusion_overall{Participant,1}{i,m},2)
%                     if sum(cell2mat(conclusion_overall{Participant,1}{i,m}(:,length_alarms)))>=1
%                         Conclusion_theta{Participant,1}{i,m}(1,length_alarms) = 1;
%                     elseif sum(cell2mat(conclusion_overall{Participant,1}{i,m}(:,length_alarms)))<= -1
%                         Conclusion_theta{Participant,1}{i,m}(1,length_alarms) = -1;
%                     else
%                         Conclusion_theta{Participant,1}{i,m}(1,length_alarms) = 0;
%                     end
%                 end
%             end
%         end
%     end
% end
% 
% % % warning('off')
% % % progressbar(['Participant'],['m'],['i'])
% % % for Participant = 1
% % %     for m = 1:size(PSD_THETA{Participant,1},2)
% % %         %     for i = 1:size(PSD_THETA{Participant,1},1)
% % %         path_save = 'G:\EEG Results\Matfiles for all participants_4 points\';
% % %         data_dum=[];
% % %         for i = 1:size(PSD_THETA{Participant,1},1)
% % %             sz(i,:)=size(PSD_THETA{Participant,1}{i,m});
% % %         end
% % %         dim= max(sz);
% % %         %buff=Nan((dim(1)+1),dim(2));
% % %         for i = 1:size(PSD_THETA{Participant,1},1)
% % %             filename = strcat(path_save,'THETA.P',num2str(Participant),'.xlsx');
% % %             data_PSD = PSD_THETA{Participant,1}{i,m};
% % %             sheet = m;
% % %             xlRange = 'A';
% % %             hz_buff=NaN(size(data_PSD,1),dim(2)-size(data_PSD,2));
% % %             vert_buff=NaN(1,dim(2));
% % %             data_PSD2=[[data_PSD hz_buff];vert_buff];
% % %             data_dum=[data_dum; data_PSD2];
% % %             clear hz_buff vert_buff data_PSD data_PSD2
% % %             progressbar([],[],i/size(PSD_THETA{Participant,1},1))
% % %         end
% % %         %data_dum(find(isnan(data_dum)))=[];
% % %
% % %         xlswrite(filename,data_dum,sheet,xlRange)
% % %         clear data_dum
% % %         progressbar([],m/size(PSD_THETA{Participant,1},2),[])
% % %     end
% % %     progressbar(Participant/10,[],[])
% % % end
% %
% %
% % % progressbar(['Participant'],['m'],['i'])
% % % for Participant = 1
% % %     for m = 1:size(conclusion_overall{Participant,1},2)
% % %         %     for i = 1:size(conclusion_overall{Participant,1},1)
% % %         path_save = 'G:\EEG Results\Matfiles for all participants_4 points\';
% % %         data_dum=[];
% % %         for i = 1:size(conclusion_overall{Participant,1},1)
% % %             sz(i,:)=size(conclusion_overall{Participant,1}{i,m});
% % %         end
% % %         dim= max(sz);
% % %         %buff=Nan((dim(1)+1),dim(2));
% % %         for i = 1:size(conclusion_overall{Participant,1},1)
% % %             filename = strcat(path_save,'Conclusion.P',num2str(Participant),'.xlsx');
% % %             data_PSD = cell2mat(conclusion_overall{Participant,1}{i,m});
% % %             sheet = m;
% % %             xlRange = 'A';
% % %             hz_buff=NaN(size(data_PSD,1),dim(2)-size(data_PSD,2));
% % %             vert_buff=NaN(1,dim(2));
% % %             data_PSD2=[[data_PSD hz_buff];vert_buff];
% % %             data_dum=[data_dum; data_PSD2];
% % %             clear hz_buff vert_buff data_PSD data_PSD2
% % %             progressbar([],[],i/size(conclusion_overall{Participant,1},1))
% % %         end
% % %         %data_dum(find(isnan(data_dum)))=[];
% % %
% % %         xlswrite(filename,data_dum,sheet,xlRange)
% % %         clear data_dum
% % %         progressbar([],m/size(conclusion_overall{Participant,1},2),[])
% % %     end
% % %     progressbar(Participant/10,[],[])
% % % end
% % %
% % % progressbar(['Participant'],['m'],['i'])
% % % for Participant = 1
% % %     for m = 1:size(Conclusion_theta{Participant,1},2)
% % %         %     for i = 1:size(Conclusion_theta{Participant,1},1)
% % %         path_save = 'G:\EEG Results\Matfiles for all participants_4 points\';
% % %         data_dum=[];
% % %         for i = 1:size(Conclusion_theta{Participant,1},1)
% % %             sz(i,:)=size(Conclusion_theta{Participant,1}{i,m});
% % %         end
% % %         dim= max(sz);
% % %         %buff=Nan((dim(1)+1),dim(2));
% % %         for i = 1:size(Conclusion_theta{Participant,1},1)
% % %             filename = strcat(path_save,'Conclusion_theta.P',num2str(Participant),'.xlsx');
% % %             data_PSD = Conclusion_theta{Participant,1}{i,m};
% % %             sheet = m;
% % %             xlRange = 'A';
% % %             hz_buff=NaN(size(data_PSD,1),dim(2)-size(data_PSD,2));
% % %             vert_buff=NaN(1,dim(2));
% % %             data_PSD2=[[data_PSD hz_buff];vert_buff];
% % %             data_dum=[data_dum; data_PSD2];
% % %             clear hz_buff vert_buff data_PSD data_PSD2
% % %             progressbar([],[],i/size(Conclusion_theta{Participant,1},1))
% % %         end
% % %         %data_dum(find(isnan(data_dum)))=[];
% % %
% % %         xlswrite(filename,data_dum,sheet,xlRange)
% % %         clear data_dum
% % %         progressbar([],m/size(Conclusion_theta{Participant,1},2),[])
% % %     end
% % %     progressbar(Participant/10,[],[])
% % % end
% %
% % % for Participant = 1
% % %     for i = 1:size(PSD_THETA{participant,1},1)
% % %         for m = 1:6
% % %             mean_participant_task{i,m} = mean(PSD_THETA{participant,1}{i,m});
% % %         end
% % %     end
% % %     mean_overall_task{participant,1} = mean_participant_task;
% % %     clear mean_participant
% % % end
% % %
% % %
% % % for Participant = 1
% % %     for i = 1:size(PSD_THETA{participant,1},1)
% % %         for m = 1:6
% % %             Std_participant_task{i,m} = std(PSD_THETA{participant,1}{i,m});
% % %         end
% % %     end
% % %     STD_overall_task{participant,1} = Std_participant;
% % %     clear Std_participant
% % % end
% % %
% %
% % %% Finding the variation in PSD
% % a = [];
% for Participant = 1:10
%     for m=1:6
%         for i = 1:size(Conclusion_theta{Participant,1},1)
%             length_PSD = length(PSD_THETA_Action_only{Participant,1}{i,m});
%             for zone = 1:length(Conclusion_theta{Participant,1}{i,m})
%                 if PSD_THETA_Action_only{Participant,1}{i,m}(1,zone)>PSD_THETA_Action_only{Participant,1}{i,m}(1,zone+1) &&  Conclusion_theta{Participant,1}{i,m}(1,zone) == 1
%                     Percentage_Change_match_mismatch{i,m}(zone,1) = 100*(PSD_THETA_Action_only{Participant,1}{i,m}(1,zone+1) - PSD_THETA_Action_only{Participant,1}{i,m}(1,zone))/PSD_THETA_Action_only{Participant,1}{i,m}(1,zone);
%                 elseif PSD_THETA_Action_only{Participant,1}{i,m}(1,zone)<PSD_THETA_Action_only{Participant,1}{i,m}(1,zone+1) && Conclusion_theta{Participant,1}{i,m}(1,zone) ==-1
%                     Percentage_Change_match_mismatch{i,m}(zone,1) = 100*(PSD_THETA_Action_only{Participant,1}{i,m}(1,zone+1) - PSD_THETA_Action_only{Participant,1}{i,m}(1,zone))/PSD_THETA_Action_only{Participant,1}{i,m}(1,zone);
%                 else
%                     Percentage_Change_match_mismatch{i,m}(zone,1) = NaN;
%                 end
%             end
%         end
%     end
%     Percentage_Change_match_mismatch_Overall{Participant,1} = Percentage_Change_match_mismatch;
%     clear Percentage_Change_match_mismatch
% end
% %
% % % progressbar(['Participant'],['m'],['i'])
% % % for Participant = 1
% % %     for m = 1:6
% % %         %     for i = 1:size(PSD_THETA{Participant,1},1)
% % %         path_save = 'G:\EEG Results\Matfiles for all participants_4 points\';
% % %         data_dum=[];
% % %         for i = 1:size(Conclusion_theta{Participant,1},1)
% % %             sz(i,:)=size(Percentage_Change_match_mismatch_Overall{Participant,1}{i,m});
% % %         end
% % %         dim= max(sz);
% % %         %buff=Nan((dim(1)+1),dim(2));
% % %         for i = 1:size(Percentage_Change_match_mismatch_Overall{Participant,1},1)
% % %             filename = strcat(path_save,'THETA_Change.P',num2str(Participant),'.xlsx');
% % %             data_PSD = Percentage_Change_match_mismatch_Overall{Participant,1}{i,m};
% % %             sheet = m;
% % %             xlRange = 'A';
% % %             hz_buff=NaN(size(data_PSD,1),dim(2)-size(data_PSD,2));
% % %             vert_buff=NaN(1,dim(2));
% % %             data_PSD2=[[data_PSD hz_buff];vert_buff];
% % %             data_dum=[data_dum; data_PSD2];
% % %             clear hz_buff vert_buff data_PSD data_PSD2
% % %             progressbar([],[],i/size(Percentage_Change_match_mismatch_Overall{Participant,1},1))
% % %         end
% % %         %data_dum(find(isnan(data_dum)))=[];
% % %
% % %         xlswrite(filename,data_dum,sheet,xlRange)
% % %         clear data_dum
% % %         progressbar([],m/size(Percentage_Change_match_mismatch_Overall{Participant,1},2),[])
% % %     end
% % %     progressbar(Participant/10,[],[])
% % % end
% %
% % %%
% for Participant = 1:10
%     for i = 1 :size(Conclusion_theta{Participant,1},1)
%         for m=1:6
%             sum_i{i,m} = sum(Conclusion_theta{Participant,1}{i,m} == 1) + sum(Conclusion_theta{Participant,1}{i,m} == -1);
%             sum_mismatch{i,m} = sum(sum(Conclusion_theta{Participant,1}{i,m} == -1));
%             sum_match{i,m} = sum(sum(Conclusion_theta{Participant,1}{i,m} == 1));
%             sum_no_conclusion{i,m} = sum(sum(Conclusion_theta{Participant,1}{i,m} == 0)) ;
%             sum_total{i,m} = sum(Conclusion_theta{Participant,1}{i,m} == -1) + sum(Conclusion_theta{Participant,1}{i,m} == 1) +sum(Conclusion_theta{Participant,1}{i,m} == 0) ;
%             
%         end
%         
%         percentage_theta_prediction{i,1} = 100*sum(cell2mat(sum_i(i,:)))/sum(cell2mat(sum_total(i,:)));
%         SUM_MATCH{Participant,1}{i,1} = sum(cell2mat(sum_match(i,:)));
%         SUM_MISMATCH{Participant,1}{i,1} = sum(cell2mat(sum_mismatch(i,:)));
%         SUM_NO_CONCLUSION{Participant,1}{i,1} = sum(cell2mat(sum_no_conclusion(i,:)));
%         SUM_TOTAL{Participant,1}{i,1} = sum(cell2mat(sum_total(i,:)));
%     end
%     
%     Sum_experiment_match_mismatch{Participant,1} = cell2mat(sum_i);
%     Sum_total_match_mismatch_noconclusion{Participant,1} = cell2mat(sum_total);
%     Percentage_theta_experiment{Participant,1} = cell2mat(percentage_theta_prediction');
%     
%     clear percentage_theta_prediction sum_total sum_match sum_mismatch sum_i sum_no_conclusion
% end
% 
% 
% 
% 
% % Process is varying above the limit
% % Process is varying below the limit
% 
% %%
% %
% % variablesToConcatenate = {};
% % variablesToConcatenate{end+1} = 'zone_diff_C101_low';
% % variablesToConcatenate{end+1} = 'zone_diff_F101_low';
% % variablesToConcatenate{end+1} = 'zone_diff_F105_low';
% % variablesToConcatenate{end+1} = 'zone_diff_F105_high';
% % variablesToConcatenate{end+1} = 'zone_diff_F101_high';
% % variablesToConcatenate{end+1} = 'zone_diff_C101_high';
% % variablesToConcatenate{end+1} = 'zone_diff_F102_high';
% % variablesToConcatenate{end+1} = 'zone_diff_F102_low';
% % variablesToConcatenate{end+1} = 'zone_diff_T104_high';
% % variablesToConcatenate{end+1} = 'zone_diff_T105_high';
% % variablesToConcatenate{end+1} = 'zone_diff_T106_high';
% % variablesToConcatenate{end+1} = 'zone_diff_T104_low';
% % variablesToConcatenate{end+1} = 'zone_diff_T105_low';
% % variablesToConcatenate{end+1} = 'zone_diff_T106_low';
% %
% %
% %
% %
% % numberOfVariables = length(variablesToConcatenate);
% %
% % result = {};
% % result{1} = [];
% % result{2} = [];
% % result{3} = [];
% % result{4} = [];
% % result{5} = [];
% % result{6} = [];
% % result{7} = [];
% % result{8} = [];
% % result{9} = [];
% % result{10} = [];
% % result{11} = [];
% % result{12} = [];
% % result{13} = [];
% % result{14} = [];
% %
% % for index = 1 : numberOfVariables
% %
% %     currentVariable = eval(variablesToConcatenate{index});
% %
% %     for internalIndex = 1 : parts
% %
% %         result{internalIndex} = [result{internalIndex}  currentVariable{internalIndex}
% %     end
% %
% % end
clear PSD_THETA_decision PSD_ALPHA_decision PSD_BETA_Action_with_decision PSD_THETA_Action_with_decision PSD_ALPHA_Action_with_decision PSD_theta_variance_rest PSD_theta_variance_task_action PSD_alpha_variance_task_action
clear PSD_beta_variance_task_action PSD_theta_variance_task_with_decision
clear PSD_alpha_variance_task_with_decision PSD_beta_variance_task_with_decision PSD_theta_variance_rest
clear PSD_theta_variance_task_action PSD_alpha_variance_task_action PSD_beta_variance_task_action PSD_theta_variance_task_with_decision  PSD_alpha_variance_taskall_with_decision PSD_beta_variance_taskall_with_decision
clear PSD_theta_variance_rest PSD_theta_variance_task_action PSD_alpha_variance_task_action  PSD_beta_variance_task_action PSD_theta_variance_task_with_decision
clear PSD_alpha_variance_taskall_with_decision PSD_beta_variance_taskall_with_decision
