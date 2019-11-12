clc
% ASSIGNING THE FOLDER PATH AND SOURCE
for destination = 1
    clearvars -except destination PSD_THETA PSD_BETA PSD_ALPHA  conclusion_overall_alpha result_overall Sum_experiment_match_mismatch SUM_MATCH SUM_MISMATCH Conclusion_alpha conclusion_overall_beta SUM_NO_CONCLUSION
    clc
    warning('off')
    format short g
    Main_Folder = 'D:\Mahindra\PSD_Filters\From Rest Period\4_points_to_10seconds_expt_file\4_points_new\4_point\EEGDATA\';
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
                read={strcat(path,'Experiment_new_rest'),strcat('Sheet',num2str(7))};
                psd_data_rest = xlsread(read{1},read{2});
                
                FileList = fullfile(path, 'eeg_data.txt'); % Importing the EEG DATA
                ip_signal{destination,1}{k} = load(FileList);
                start_scenario{k,m} =  mouseclick{k,m};
                start_alarm{k,m} = alarm_file1{k,m};
                
                
                % Filtered data Theta
                sampleRate = 512; % Hz
                lowEnd  = 4; % Hz
                highEnd = 8; % Hz
                filterOrder = 2; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
                [b, a] = butter(filterOrder, [lowEnd highEnd]/(sampleRate/2)); % Generate filter coefficients
                filteredData_theta = filtfilt(b, a, ip_signal{destination,1}{k}); % Apply filter to data using zero-phase filtering
                
                % Filtered data Alpha
                sampleRate = 512; % Hz
                lowEnd  = 8; % Hz
                highEnd = 12; % Hz
                filterOrder = 2; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
                [b, a] = butter(filterOrder, [lowEnd highEnd]/(sampleRate/2)); % Generate filter coefficients
                filteredData_alpha = filtfilt(b, a, ip_signal{destination,1}{k}); % Apply filter to data using zero-phase filtering
                
                % Filtered data Beta
                sampleRate = 512; % Hz
                lowEnd  = 12; % Hz
                highEnd = 30; % Hz
                filterOrder = 2; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
                [b, a] = butter(filterOrder, [lowEnd highEnd]/(sampleRate/2)); % Generate filter coefficients
                filteredData_beta = filtfilt(b, a, ip_signal{destination,1}{k}); % Apply filter to data using zero-phase filtering
                
                % Filtered data eye blinks
                sampleRate = 512; % Hz
                lowEnd  = 0.5; % Hz
                highEnd = 3.0; % Hz
                filterOrder = 2; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
                [b, a] = butter(filterOrder, [lowEnd highEnd]/(sampleRate/2)); % Generate filter coefficients
                filteredData_eye = filtfilt(b, a, ip_signal{destination,1}{k}); % Apply filter to data using zero-phase filtering
                
                for phase = 1
                    if m<= 5
                        % fOR REST PERIOD
                        lr = 10*length(psd_data_rest(1,:));                                                                                 % Length_Rest
                        
                        std_deviation_delta_rest = std(filteredData_eye(1:lr*512));
                        std_deviation_theta_rest = std(filteredData_theta(1:lr*512));
                        std_deviation_alpha_rest = std(filteredData_alpha(1:lr*512));
                        std_deviation_beta_rest  = std(filteredData_beta(1:lr*512));
                        
                        S_entropy{destination,1}{k,m}(1,phase)  = sampen_new(filteredData_eye(1:lr*512),512,0.20*std_deviation_delta_rest);   % Delta
                        S_entropy{destination,1}{k,m}(1,phase+1)= sampen_new(filteredData_theta(1:lr*512),512,0.20*std_deviation_theta_rest); % Theta
                        S_entropy{destination,1}{k,m}(1,phase+2)= sampen_new(filteredData_alpha(1:lr*512),512,0.20*std_deviation_alpha_rest); % Alpha
                        S_entropy{destination,1}{k,m}(1,phase+3)= sampen_new(filteredData_beta(1:lr*512),512,0.20*std_deviation_beta_rest);   % Beta
                        
                        % Start to 1st alarm
                        std_deviation_delta_s21 = std(filteredData_eye((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512));
                        std_deviation_theta_s21 = std(filteredData_theta((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512));
                        std_deviation_alpha_s21 = std(filteredData_alpha((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512));
                        std_deviation_beta_s21  = std(filteredData_beta((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512));
                        
                        S_entropy{destination,1}{k,m}(2,phase)  = sampen_new(filteredData_eye(  (lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512),512,0.20*std_deviation_delta_s21); % Delta
                        S_entropy{destination,1}{k,m}(2,phase+1)= sampen_new(filteredData_theta((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512),512,0.20*std_deviation_theta_s21); % Theta
                        S_entropy{destination,1}{k,m}(2,phase+2)= sampen_new(filteredData_alpha((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512),512,0.20*std_deviation_alpha_s21); % Alpha
                        S_entropy{destination,1}{k,m}(2,phase+3)= sampen_new(filteredData_beta( (lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512),512,0.20*std_deviation_beta_s21);  % Beta
                        
                        % 1ST ALARM TO fIRST SLIDER ACTION
                        std_deviation_delta_s21s = std(filteredData_eye((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512));
                        std_deviation_theta_s21s = std(filteredData_theta((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512));
                        std_deviation_alpha_s21s = std(filteredData_alpha((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512));
                        std_deviation_beta_s21s  = std(filteredData_beta((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512));
                        
                        S_entropy{destination,1}{k,m}(3,phase)  = sampen_new(filteredData_eye(  (lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512),512,0.20*std_deviation_delta_s21s); % Delta
                        S_entropy{destination,1}{k,m}(3,phase+1)= sampen_new(filteredData_theta((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512),512,0.20*std_deviation_theta_s21s); % Theta
                        S_entropy{destination,1}{k,m}(3,phase+2)= sampen_new(filteredData_alpha((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512),512,0.20*std_deviation_alpha_s21s); % Alpha
                        S_entropy{destination,1}{k,m}(3,phase+3)= sampen_new(filteredData_beta( (lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512),512,0.20*std_deviation_beta_s21s); % Beta
                        
                        % Slider Action to Plant coming back to normal
                        std_deviation_delta_s2norm = std(filteredData_eye((lr+start_scenario{k,m}(4,1))*512:(lr+start_scenario{k,m}(length(start_scenario{k,m}(:,1)),1))*512));
                        std_deviation_theta_s2norm = std(filteredData_theta((lr+start_scenario{k,m}(4,1))*512:(lr+start_scenario{k,m}(length(start_scenario{k,m}(:,1)),1))*512));
                        std_deviation_alpha_s2norm = std(filteredData_alpha((lr+start_scenario{k,m}(4,1))*512:(lr+start_scenario{k,m}(length(start_scenario{k,m}(:,1)),1))*512));
                        std_deviation_beta_s2norm  = std(filteredData_beta((lr+start_scenario{k,m}(4,1))*512:(lr+start_scenario{k,m}(length(start_scenario{k,m}(:,1)),1))*512));
                        
                        S_entropy{destination,1}{k,m}(4,phase)  = sampen_new(filteredData_eye(  (lr+start_scenario{k,m}(4,1))*512:(lr+start_scenario{k,m}(length(start_scenario{k,m}(:,1)),1))*512),512,0.20*std_deviation_delta_s2norm); % Delta
                        S_entropy{destination,1}{k,m}(4,phase+1)= sampen_new(filteredData_theta((lr+start_scenario{k,m}(4,1))*512:(lr+start_scenario{k,m}(length(start_scenario{k,m}(:,1)),1))*512),512,0.20*std_deviation_theta_s2norm); % Theta
                        S_entropy{destination,1}{k,m}(4,phase+2)= sampen_new(filteredData_alpha((lr+start_scenario{k,m}(4,1))*512:(lr+start_scenario{k,m}(length(start_scenario{k,m}(:,1)),1))*512),512,0.20*std_deviation_alpha_s2norm); % Alpha
                        S_entropy{destination,1}{k,m}(4,phase+3)= sampen_new(filteredData_beta( (lr+start_scenario{k,m}(4,1))*512:(lr+start_scenario{k,m}(length(start_scenario{k,m}(:,1)),1))*512),512,0.20*std_deviation_beta_s2norm); % Beta
                    else
                    
                    % fOR REST PERIOD
                        lr = 10*length(psd_data_rest(1,:));                                                                                 % Length_Rest
                        
                        std_deviation_delta_rest = std(filteredData_eye(1:lr*512));
                        std_deviation_theta_rest = std(filteredData_theta(1:lr*512));
                        std_deviation_alpha_rest = std(filteredData_alpha(1:lr*512));
                        std_deviation_beta_rest  = std(filteredData_beta(1:lr*512));
                        
                        S_entropy{destination,1}{k,m}(1,phase)  = sampen_new(filteredData_eye(1:lr*512),512,0.20*std_deviation_delta_rest);   % Delta
                        S_entropy{destination,1}{k,m}(1,phase+1)= sampen_new(filteredData_theta(1:lr*512),512,0.20*std_deviation_theta_rest); % Theta
                        S_entropy{destination,1}{k,m}(1,phase+2)= sampen_new(filteredData_alpha(1:lr*512),512,0.20*std_deviation_alpha_rest); % Alpha
                        S_entropy{destination,1}{k,m}(1,phase+3)= sampen_new(filteredData_beta(1:lr*512),512,0.20*std_deviation_beta_rest);   % Beta
                        
                        % Start to 1st alarm
                        std_deviation_delta_s21 = std(filteredData_eye((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512));
                        std_deviation_theta_s21 = std(filteredData_theta((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512));
                        std_deviation_alpha_s21 = std(filteredData_alpha((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512));
                        std_deviation_beta_s21  = std(filteredData_beta((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512));
                        
                        S_entropy{destination,1}{k,m}(2,phase)  = sampen_new(filteredData_eye(  (lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512),512,0.20*std_deviation_delta_s21); % Delta
                        S_entropy{destination,1}{k,m}(2,phase+1)= sampen_new(filteredData_theta((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512),512,0.20*std_deviation_theta_s21); % Theta
                        S_entropy{destination,1}{k,m}(2,phase+2)= sampen_new(filteredData_alpha((lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512),512,0.20*std_deviation_alpha_s21); % Alpha
                        S_entropy{destination,1}{k,m}(2,phase+3)= sampen_new(filteredData_beta( (lr+start_scenario{k,m}(1,1))*512:(lr+start_alarm{k,m}(1,1))*512),512,0.20*std_deviation_beta_s21);  % Beta
                        
                        % 1ST ALARM TO fIRST SLIDER ACTION
                        std_deviation_delta_s21s = std(filteredData_eye((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512));
                        std_deviation_theta_s21s = std(filteredData_theta((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512));
                        std_deviation_alpha_s21s = std(filteredData_alpha((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512));
                        std_deviation_beta_s21s  = std(filteredData_beta((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512));
                        
                        S_entropy{destination,1}{k,m}(3,phase)  = sampen_new(filteredData_eye(  (lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512),512,0.20*std_deviation_delta_s21s); % Delta
                        S_entropy{destination,1}{k,m}(3,phase+1)= sampen_new(filteredData_theta((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512),512,0.20*std_deviation_theta_s21s); % Theta
                        S_entropy{destination,1}{k,m}(3,phase+2)= sampen_new(filteredData_alpha((lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512),512,0.20*std_deviation_alpha_s21s); % Alpha
                        S_entropy{destination,1}{k,m}(3,phase+3)= sampen_new(filteredData_beta( (lr+start_alarm{k,m}(1,1))*512:(lr+start_scenario{k,m}(4,1))*512),512,0.20*std_deviation_beta_s21s); % Beta
                        
                        % Slider Action to Plant coming back to normal
                        std_deviation_delta_s2norm = std(filteredData_eye((lr+start_scenario{k,m}(4,1))*512:end));
                        std_deviation_theta_s2norm = std(filteredData_theta((lr+start_scenario{k,m}(4,1))*512:end));
                        std_deviation_alpha_s2norm = std(filteredData_alpha((lr+start_scenario{k,m}(4,1))*512:end));
                        std_deviation_beta_s2norm  = std(filteredData_beta((lr+start_scenario{k,m}(4,1))*512:end));
                        
                        S_entropy{destination,1}{k,m}(4,phase)  = sampen_new(filteredData_eye(  (lr+start_scenario{k,m}(4,1))*512:end),512,0.20*std_deviation_delta_s2norm); % Delta
                        S_entropy{destination,1}{k,m}(4,phase+1)= sampen_new(filteredData_theta((lr+start_scenario{k,m}(4,1))*512:end),512,0.20*std_deviation_theta_s2norm); % Theta
                        S_entropy{destination,1}{k,m}(4,phase+2)= sampen_new(filteredData_alpha((lr+start_scenario{k,m}(4,1))*512:end),512,0.20*std_deviation_alpha_s2norm); % Alpha
                        S_entropy{destination,1}{k,m}(4,phase+3)= sampen_new(filteredData_beta( (lr+start_scenario{k,m}(4,1))*512:end),512,0.20*std_deviation_beta_s2norm); % Beta
                    end
                    
                end
            end
        end
    end
end









