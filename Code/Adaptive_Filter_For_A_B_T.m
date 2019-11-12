%% Frequency-domain adaptive filter
% this is a demo of Frequency-domain adaptive filter
% the algorithm is based on Haykin, Adaptive Filter Theory 4th ed
% partially inspaired by John Forte's work in Mathworks File Exchange
% the results are identical to the build-in Matlab system object: FrequencyDomainAdaptiveFilter
% If you don't have dsp toolbox, comment the last section
%
% Author: Xiao Liu, UW-STREAM Lab, Dalhousie University
% Mar. 19, 2017
%% signal generation
clc
clear
close all

for destination = 2:10
    clearvars -except destination Delta_EEG_eye_tracker PSD_Raw
    clc
    warning('off')
    format short g
    Main_Folder1 = 'D:\Mahindra\From Rest Period\4_points_to_10seconds_expt_file\4_points_new\4_point\EEGDATA\';
    Main_Folder2 = 'D:\Mahindra\Adaptive filter\PSD_Filters\From Rest Period\4_points_to_10seconds_expt_file\4_points_new\4_point\EEGDATA\';
    person = {strcat('P',num2str(destination))};
    participant = char(person);
    
    for  i = 1
        if i == 1
            sch = 'm';
            Parent_Folder1=strcat(Main_Folder1,participant,'\Morning\'); % Folder destination
            AllFile=dir(fullfile(Parent_Folder1,'*P*')); % Subfolders starting letter
            File_link=AllFile([AllFile.isdir]);
            Folder1 = natsortfiles({File_link.name});
            for i= 1:length(Folder1)      % Assigning sorted value in AllFile in order
                AllFile(i).name = Folder1{i};
            end
            Folder1 = AllFile;
            %             fold_nms1 = Folder;
            %             fold_nms2 = char(fold_nms1);
            
            sch = 'm';
            Parent_Folder2=strcat(Main_Folder2,participant,'\Morning\'); % Folder destination
            AllFile=dir(fullfile(Parent_Folder2,'*P*')); % Subfolders starting letter
            File_link=AllFile([AllFile.isdir]);
            Folder2 = natsortfiles({File_link.name});
            for i= 1:length(Folder2)      % Assigning sorted value in AllFile in order
                AllFile(i).name = Folder2{i};
            end
            Folder2 = AllFile;
            %             fold_nms1 = Folder;
            %             fold_nms2 = char(fold_nms1);
            
        else
            sch = 'n';
            Parent_Folder1=strcat(Main_Folder1,participant,'\Night\'); % Folder destination
            AllFile=dir(fullfile(Parent_Folder1,'*P*')); % Subfolders starting letter
            File_link=AllFile([AllFile.isdir]);
            Folder1 = natsortfiles({File_link.name});
            for i= 1:length(Folder1)      % Assigning sorted value in AllFile in order
                AllFile(i).name = Folder1{i};
            end
            Folder1 = AllFile;
            %             fold_nms1 = Folder;
            %             fold_nms2 = char(fold_nms1);
            Parent_Folder2=strcat(Main_Folder2,participant,'\Night\'); % Folder destination
            AllFile=dir(fullfile(Parent_Folder2,'*P*')); % Subfolders starting letter
            File_link=AllFile([AllFile.isdir]);
            Folder2 = natsortfiles({File_link.name});
            for i= 1:length(Folder2)      % Assigning sorted value in AllFile in order
                AllFile(i).name = Folder2{i};
            end
            Folder2 = AllFile;
            %             fold_nms1 = Folder;
            %             fold_nms2 = char(fold_nms1);
            
        end
        %% Reading the Actual PSD Data
        for k=1:length(Folder1)
            PSD_Actual{destination,1}{k} = [];
            path1=strcat(Parent_Folder1,Folder1(k).name,'\')
            for m=1:6
                read={strcat(path1,'Experiment_new_rest'),strcat('Sheet',num2str(m))};    %% EXPERIMENT+REST SHEET CONTAINING THETA, ALPHA AND BETA
                PSD_raw_data{k,m} = xlsread(read{1},read{2});
                PSD_raw{k,m} = PSD_raw_data{k,m};
                len_raw(k,m+1) = length(PSD_raw{k,m}(1,:));
                if m+1 == 7
                    read={strcat(path1,'Experiment_new_rest'),strcat('Sheet',num2str(7))};    %% EXPERIMENT+REST SHEET CONTAINING THETA, ALPHA AND BETA
                    PSD_raw_data{k,7} = xlsread(read{1},read{2});
                    PSD_raw_rest{destination,1}{k} = PSD_raw_data{k,7};
                end
                PSD_Actual{destination,1}{k} = [PSD_Actual{destination,1}{k},PSD_raw{k,m}];
                
            end
            PSD_Actual{destination,1}{k} = [PSD_raw_rest{destination,1}{k},PSD_Actual{destination,1}{k}];
            len_raw(k,1) = length(PSD_raw_rest{destination,1}{k}(1,:));
            
        end
    %% Reading the Desired PSD Data
        for k=1:length(Folder2)
            PSD_Desired{destination,1}{k} = [];
            path2=strcat(Parent_Folder2,Folder2(k).name,'\')
            for m=1:6
                read={strcat(path2,'PSD_FOR_AF'),strcat('Sheet',num2str(m))};    %% EXPERIMENT+REST SHEET CONTAINING THETA, ALPHA AND BETA
                PSD_raw_data{k,m} = xlsread(read{1},read{2});
                PSD_raw{k,m} = PSD_raw_data{k,m};
                len_desired(k,m+1) = length(PSD_raw{k,m}(1,:));
                if m+1 == 7
                    read={strcat(path2,'PSD_FOR_AF'),strcat('Sheet',num2str(7))};    %% EXPERIMENT+REST SHEET CONTAINING THETA, ALPHA AND BETA
                    PSD_raw_data{k,7} = xlsread(read{1},read{2});
                    PSD_raw_rest{destination,1}{k} = PSD_raw_data{k,7};
                end
                PSD_Desired{destination,1}{k} = [PSD_Desired{destination,1}{k},PSD_raw{k,m}];
            end
            PSD_Desired{destination,1}{k} = [PSD_raw_rest{destination,1}{k},PSD_Desired{destination,1}{k}];
            len_desired(k,1) = length(PSD_raw_rest{destination,1}{k}(1,:));
            length_PSD(k,1) = length(PSD_Desired{destination,1}{k}(1,:));
        end
        
        % plot(mean(PSD_Desired{destination,1}{k,1}(5:8,:)),'b');hold on;plot(mean(PSD_Actual{destination,1}{k,1}(5:8,:)),'r')
        
        %% Adaptive filter Algorithm using the Dsp.toolbox frequency domain adaptive filter Algorithm
        % using frequency-domain fast block LMS algorithm
            % Notations and algorithm are based on Haykin, Adaptive Filter Theory 4th ed. P.35
        for k=1:length(Folder2)
            path2=strcat(Parent_Folder2,Folder2(k).name,'\')
            alpha = 0.08; % StepSize
            gamma = 0.9; % forgetting factor
            if rem(length_PSD(k,1),2) == 0
                ntr = length_PSD(k,1);
                Actual_theta  = mean(PSD_Actual{destination,1}{k}(5:8,:));  % Actual Data
                desired_theta = mean(PSD_Desired{destination,1}{k}(5:8,:)); % Desired Data
                
                Actual_alpha  = mean(PSD_Actual{destination,1}{k}(9:13,:));  % Actual Data
                desired_alpha = mean(PSD_Desired{destination,1}{k}(9:13,:)); % Desired Data
                
                Actual_beta   = mean(PSD_Actual{destination,1}{k}(14:31,:));  % Actual Data
                desired_beta = mean(PSD_Desired{destination,1}{k}(14:31,:)); % Desired Data
            else
                ntr = length_PSD(k,1)-1;
                Actual_theta  = mean(PSD_Actual{destination,1}{k}(5:8,2:end));  % Actual Data
                desired_theta = mean(PSD_Desired{destination,1}{k}(5:8,2:end)); % Desired Data
                
                Actual_alpha  = mean(PSD_Actual{destination,1}{k}(9:13,:));  % Actual Data
                desired_alpha = mean(PSD_Desired{destination,1}{k}(9:13,:)); % Desired Data
                
                Actual_beta   = mean(PSD_Actual{destination,1}{k}(14:31,:));  % Actual Data
                desired_beta = mean(PSD_Desired{destination,1}{k}(14:31,:)); % Desired Data
            end
            M = 2;            %Data points size
            W = zeros(M*2,1); % filter weights
            P = ones(M*2,1);  % initial power estimation
            temp = zeros(M*2,1); % temp u
            error = zeros(ntr,1);
            y2 = zeros(ntr,1); % output
            
            u = Actual_theta';     % Actual Data
            mu  = 0.11;
            N = 2;
            ha = dsp.FrequencyDomainAdaptiveFilter('Length',N,'StepSize',mu);
            [y2,e] = step(ha,Actual_theta,desired_theta);
            %         disp(sum(abs(e)))
            
            Actual_theta  = mean(PSD_Actual{destination,1}{k}(5:8,:));  % Actual Data
            desired_theta = mean(PSD_Desired{destination,1}{k}(5:8,:)); % Desired Data
            
            Actual_alpha  = mean(PSD_Actual{destination,1}{k}(9:13,:));  % Actual Data
            desired_alpha = mean(PSD_Desired{destination,1}{k}(9:13,:)); % Desired Data
            
            Actual_beta   = mean(PSD_Actual{destination,1}{k}(14:31,:));  % Actual Data
            desired_beta = mean(PSD_Desired{destination,1}{k}(14:31,:)); % Desired Data
            
            if rem(length_PSD(k,1),2) >0
                y2(length_PSD(k,1)) = desired_theta(length_PSD(k,1));
                y2(length_PSD(k,1)) = desired_theta(length_PSD(k,1));
                y2(length_PSD(k,1)) = desired_theta(length_PSD(k,1));

            end
            y2(1,1:2) = desired_theta(1:2);
            PSD_After_AF_rest{destination,1}{k,7} = y2(1:len_desired(k,1));
            output = mat2cell(y2(1:end),1,len_desired(k,:));
            for m = 1:6
                PSD_After_AF{destination,1}{k,m} = output{1,m+1};
                filename = strcat(path2,'PSD_After_AF','.xlsx');
                data_PSD_rest = PSD_After_AF_rest{destination,1}{k,7};
                data_PSD_tasks = PSD_After_AF{destination,1}{k,m};
                sheet = m;
                xlRange = 'A';
                xlswrite(filename,data_PSD_tasks,sheet,xlRange)
                xlswrite(filename,data_PSD_rest,7,xlRange)
            end
        end
    end
end
