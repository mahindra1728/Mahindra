for destination = 1:10
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
            for j= 1:length(Folder)      % Assigning sorted value in AllFile in order
                AllFile(j).name = Folder{j};
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
            for j= 1:length(Folder)      % Assigning sorted value in AllFile in order
                AllFile(j).name = Folder{j};
            end
            Folder = AllFile;
            %             fold_nms1 = Folder;
            %             fold_nms2 = char(fold_nms1);
        end
        
        
        %% Importing the Power spectral density
%         mean_PSD_theta_filter = zeros(1,length(Folder));
%         std_deviation_PSD_theta_filter = zeros(length(Folder),6);
%         mean_PSD_beta_filter = zeros(length(Folder),6);
%         std_deviation_PSD_beta_filter = zeros(length(Folder),6);
%         mean_PSD_alpha_filter = zeros(length(Folder),6);
%         std_deviation_PSD_alpha_filter = zeros(length(Folder),6);
        for k = 1:length(Folder)
            path=strcat(Parent_Folder,Folder(k).name,'\');
            disp(path)
            for m = 1:6
                    read={strcat(path,'Experiment_new_rest'),strcat('Sheet',num2str(m))};    %% EXPERIMENT+REST SHEET CONTAINING THETA, ALPHA AND BETA
                    PSD_raw_data_BPF      = xlsread(read{1},read{2});
                    PSD_raw_BPF{destination}{k,m}      = PSD_raw_data_BPF;
                mean_PSD_theta_filter{destination}(k)         = mean(mean(PSD_raw_BPF{destination}{k,m}(5:8,:)));
                std_deviation_PSD_theta_filter{destination}(k)   = mean(std(PSD_raw_BPF{destination}{k,m}(5:8,:)));
                mean_PSD_beta_filter{destination}(k)             = mean(mean(PSD_raw_BPF{destination}{k,m}(14:31,:)));
                std_deviation_PSD_beta_filter{destination}(k)    = mean(std(PSD_raw_BPF{destination}{k,m}(14:31,:)));
                mean_PSD_alpha_filter{destination}(k)            = mean(mean(PSD_raw_BPF{destination}{k,m}(9:13,:)));
                std_deviation_PSD_alpha_filter{destination}(k)   = mean(std(PSD_raw_BPF{destination}{k,m}(9:13,:)));
            end
        end
    end
end



for destination = 1:10
    clc
    warning('off')
    format short g
    Main_Folder = 'D:\Mahindra\From Rest Period\4_points_to_10seconds_expt_file\4_points_new\4_point\EEGDATA\';
    person = {strcat('P',num2str(destination))};
    participant = char(person);
    
    for i = 1
        if i == 1
            sch = 'm';
            Parent_Folder=strcat(Main_Folder,participant,'\Morning\'); % Folder destination
            AllFile=dir(fullfile(Parent_Folder,'*P*')); % Subfolders starting letter
            File_link=AllFile([AllFile.isdir]);
            Folder = natsortfiles({File_link.name});
            for j= 1:length(Folder)      % Assigning sorted value in AllFile in order
                AllFile(j).name = Folder{j};
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
            for j= 1:length(Folder)      % Assigning sorted value in AllFile in order
                AllFile(j).name = Folder{j};
            end
            Folder = AllFile;
            %             fold_nms1 = Folder;
            %             fold_nms2 = char(fold_nms1);
        end
        
        
        %% Importing the Power spectral density
%         mean_PSD_theta_No_filter = zeros(length(Folder),6);
%         std_deviation_PSD_theta_No_filter = zeros(length(Folder),6);
%         mean_PSD_beta_No_filter = zeros(length(Folder),6);
%         std_deviation_PSD_beta_No_filter = zeros(length(Folder),6);
%         mean_PSD_alpha_No_filter = zeros(length(Folder),6);
%         std_deviation_PSD_alpha_No_filter = zeros(length(Folder),6);
        for k = 1:length(Folder)
            path=strcat(Parent_Folder,Folder(k).name,'\');
            disp(path)
            for m = 1:6
                    read={strcat(path,'Experiment_new_rest'),strcat('Sheet',num2str(m))};    %% EXPERIMENT+REST SHEET CONTAINING THETA, ALPHA AND BETA
                    PSD_raw_data_BPF      = xlsread(read{1},read{2});
                    PSD_raw_BPF{destination}{k,m}      = PSD_raw_data_BPF;

                mean_PSD_theta_No_filter{destination}(k)            = mean(mean(PSD_raw_BPF{destination}{k,m}(5:8,:)));
                std_deviation_PSD_theta_No_filter{destination}(k)   = mean(std(PSD_raw_BPF{destination}{k,m}(5:8,:)));
                mean_PSD_beta_No_filter{destination}(k)             = mean(mean(PSD_raw_BPF{destination}{k,m}(14:31,:)));
                std_deviation_PSD_beta_No_filter{destination}(k)    = mean(std(PSD_raw_BPF{destination}{k,m}(14:31,:)));
                mean_PSD_alpha_No_filter{destination}(k,1)            = mean(mean(PSD_raw_BPF{destination}{k,m}(9:13,:)));
                std_deviation_PSD_alpha_No_filter{destination}(k)   = mean(std(PSD_raw_BPF{destination}{k,m}(9:13,:)));
            end
        end
    end
end



% for destination = 1:10
%     clc
%     warning('off')
%     format short g
%     Main_Folder = 'D:\Mahindra\PSD_Filters\From Rest Period\4_points_to_10seconds_expt_file\4_points_new\4_point\EEGDATA\';
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
%             for j= 1:length(Folder)      % Assigning sorted value in AllFile in order
%                 AllFile(j).name = Folder{j};
%             end
%             Folder = AllFile;
%             %             fold_nms1 = Folder;
%             %             fold_nms2 = char(fold_nms1);
%         else
%             sch = 'n';
%             Parent_Folder=strcat(Main_Folder,participant,'\Night\'); % Folder destination
%             AllFile=dir(fullfile(Parent_Folder,'*P*')); % Subfolders starting letter
%             File_link=AllFile([AllFile.isdir]);
%             Folder = natsortfiles({File_link.name});
%             for j= 1:length(Folder)      % Assigning sorted value in AllFile in order
%                 AllFile(j).name = Folder{j};
%             end
%             Folder = AllFile;
%             %             fold_nms1 = Folder;
%             %             fold_nms2 = char(fold_nms1);
%         end
%         for k = 1:length(Folder)
%             for m = 1:6
%                 figure(m)
%                 bar([mean_PSD_theta_No_filter{k,m}',mean_PSD_theta_filter{k,m}']);legend(
%                 figure(m+1)
%                 
%                 print(figure(m),fullfile(path,['Mean Comparison with and without filter',wave,'_expt_',num2str(k),'_Task_',num2str(m),'_part_',num2str(range_of_freq), '.png']),'-dpng','-r800');
%                 
%             end










