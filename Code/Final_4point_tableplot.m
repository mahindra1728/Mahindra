clc
% ASSIGNING THE FOLDER PATH AND SOURCE
for destination = 2:10
    clearvars -except destination
    clc
    warning('off')
    format short g
    Main_Folder = 'G:\EEG Results\4_points_new\4_point\EEGDATA\';
    person = {strcat('P',num2str(destination))};
    participant = char(person);
    
    for i = 1
        if i == 1
            sch = 'm';
            Parent_Folder_normal=strcat(Main_Folder,participant,'\Morning\'); % Folder destination
            AllFile_normal=dir(fullfile(Parent_Folder_normal,'*P*')); % Subfolders starting letter
            File_link_normal=AllFile_normal([AllFile_normal.isdir]);
            Folder_normal = natsortfiles({File_link_normal.name});
            for i= 1:length(Folder_normal)      % Assigning sorted value in AllFile in order
                AllFile_normal(i).name = Folder_normal{i};
            end
            Folder_normal = AllFile_normal;
        end
        
        %% Importing the alarm files for random type alarms
        index = [];
        txtData = [];
        Parent_Folder_random=strcat(Main_Folder,participant,'\Night\');% Folder destination
        AllFile_random=dir(fullfile(Parent_Folder_random,'*P*')); % Subfolders starting letter
        File_link_random=AllFile_random([AllFile_random.isdir]);
        Folder_random = natsortfiles({File_link_random.name});
        for i= 1:length(Folder_random )      % Assigning sorted value in AllFile in order
            AllFile_random(i).name = Folder_random {i};
        end
        Folder_random = AllFile_random;
        for k=1:length(Folder_random)
            path_random=strcat(Parent_Folder_random,Folder_random(k).name,'\');
            for m=1:6
                read= {strcat(path_random,'Alarm_timing1'),strcat('Sheet',num2str(m))};
                [~,txtData{k,m}] = xlsread(read{1},read{2});
                
                read= {strcat(path_random,'Experiment'),strcat('Sheet',num2str(m))};
                PSD_random{k,m} = xlsread(read{1},read{2});
                
                if     strcmpi(table2array(txtData{k,m}(1,1)),'F102_low')
                    index{k,m} = 1;
                elseif strcmpi(table2array(txtData{k,m}(1,1)),'F101_high')
                    index{k,m} = 2;
                elseif strcmpi(table2array(txtData{k,m}(1,1)),'T105_low')
                    if m==1
                        index{k,m} = 3;
                    else
                        if any(cell2mat(index(k,:))==3)
                            index{k,m} = 6;
                        else
                            index{k,m} = 3;
                        end
                    end
                elseif strcmpi(table2array(txtData{k,m}(1,1)),'F102_high')
                    index{k,m} = 4;
                elseif strcmpi(table2array(txtData{k,m}(1,1)),'F101_low')
                    index{k,m} = 5;
                    
                end
                
            end
        end
        
        %% Calling the random files PSD
        for k = 1:length(Folder_random)
            for m = 1:6
                
                mean_random_start2alarm_theta{k,m}  = mean(PSD_random{k,index{1,m}}(5:8,1)); % random array for start to alarm theta
                mean_random_alarm2slider_theta{k,m} = mean(PSD_random{k,index{1,m}}(5:8,2)); % random array for alarm to slideraction theta
                mean_random_slider2SC_theta{k,m}    = mean(PSD_random{k,index{1,m}}(5:8,3)); % random array for slideraction to clearence of alarm theta
                mean_random_SC2finish_theta{k,m}    = mean(PSD_random{k,index{1,m}}(5:8,4)); % random array for clkearence to finish theta
                
                mean_random_start2alarm_alpha{k,m}  = mean(PSD_random{k,index{1,m}}(9:13,1));% random array for start to alarm alpha
                mean_random_alarm2slider_alpha{k,m} = mean(PSD_random{k,index{1,m}}(9:13,2));% random array for alarm to slideraction alpha
                mean_random_slider2SC_alpha{k,m}    = mean(PSD_random{k,index{1,m}}(9:13,3));% random array for slideraction to clearence of alarm alpha
                mean_random_SC2finish_alpha{k,m}    = mean(PSD_random{k,index{1,m}}(9:13,4));% random array for clkearence to finish alpha
                
                mean_random_start2alarm_beta{k,m}   = mean(PSD_random{k,index{1,m}}(14:31,1));% random array for start to alarm beta
                mean_random_alarm2slider_beta{k,m}  = mean(PSD_random{k,index{1,m}}(14:31,2));% random array for alarm to slideraction beta
                mean_random_slider2SC_beta{k,m}     = mean(PSD_random{k,index{1,m}}(14:31,3));% random array for slideraction to clearence of alarm beta
                mean_random_SC2finish_beta{k,m}     = mean(PSD_random{k,index{1,m}}(14:31,4));% random array for clkearence to finish beta
            end
        end
        
        mean_random_start2alarm_theta  = cell2mat(mean_random_start2alarm_theta);
        mean_random_alarm2slider_theta = cell2mat(mean_random_alarm2slider_theta);
        mean_random_slider2SC_theta    = cell2mat(mean_random_slider2SC_theta);
        mean_random_SC2finish_theta    = cell2mat(mean_random_SC2finish_theta);
        
        mean_random_start2alarm_alpha  = cell2mat(mean_random_start2alarm_alpha);
        mean_random_alarm2slider_alpha = cell2mat(mean_random_alarm2slider_alpha);
        mean_random_slider2SC_alpha    = cell2mat(mean_random_slider2SC_alpha);
        mean_random_SC2finish_alpha    = cell2mat(mean_random_SC2finish_alpha);
        
        mean_random_start2alarm_beta   = cell2mat(mean_random_start2alarm_beta);
        mean_random_alarm2slider_beta  = cell2mat(mean_random_alarm2slider_beta);
        mean_random_slider2SC_beta     = cell2mat(mean_random_slider2SC_beta);
        mean_random_SC2finish_beta     = cell2mat(mean_random_SC2finish_beta);
        
        
        %% Importing the parent sheet
        PSD_normal = [];
        p=[];
        for k=1:length(Folder_normal)
            path=strcat(Parent_Folder_normal,Folder_normal(k).name,'\');
            for m=1:6
                read= {strcat(path,'Experiment'),strcat('Sheet',num2str(m))};
                PSD_normal{k,m} = xlsread(read{1},read{2});
                
                mean_start2alarm_theta{k,m}  = mean(PSD_normal{k,m}(5:8,1)); % Structurearray for start to alarm theta
                mean_alarm2slider_theta{k,m} = mean(PSD_normal{k,m}(5:8,2)); % Structurearray for alarm to slideraction theta
                mean_slider2SC_theta{k,m}    = mean(PSD_normal{k,m}(5:8,3)); % Structurearray for slideraction to clearence of alarm theta
                mean_SC2finish_theta{k,m}    = mean(PSD_normal{k,m}(5:8,4)); % Structurearray for clkearence to finish theta
                
                mean_start2alarm_alpha{k,m}  = mean(PSD_normal{k,m}(9:13,1));% Structurearray for start to alarm alpha
                mean_alarm2slider_alpha{k,m} = mean(PSD_normal{k,m}(9:13,2));% Structurearray for alarm to slideraction alpha
                mean_slider2SC_alpha{k,m}    = mean(PSD_normal{k,m}(9:13,3));% Structurearray for slideraction to clearence of alarm alpha
                mean_SC2finish_alpha{k,m}    = mean(PSD_normal{k,m}(9:13,4));% Structurearray for clkearence to finish alpha
                
                mean_start2alarm_beta{k,m}   = mean(PSD_normal{k,m}(14:31,1));% Structurearray for start to alarm beta
                mean_alarm2slider_beta{k,m}  = mean(PSD_normal{k,m}(14:31,2));% Structurearray for alarm to slideraction beta
                mean_slider2SC_beta{k,m}     = mean(PSD_normal{k,m}(14:31,3));% Structurearray for slideraction to clearence of alarm beta
                mean_SC2finish_beta{k,m}     = mean(PSD_normal{k,m}(14:31,4));% Structurearray for clkearence to finish beta
                
                
                %                 name = strcat(participant,sch,'_expt_',num2str(k),'_scenario_',num2str(m)); % will save in format alarm_n_scenario_m
                %                 eval(strcat(name,'=',mat2str(p(:,1))))
            end
        end
        
        mean_start2alarm_theta  = cell2mat(mean_start2alarm_theta);
        mean_alarm2slider_theta = cell2mat(mean_alarm2slider_theta);
        mean_slider2SC_theta    = cell2mat(mean_slider2SC_theta);
        mean_SC2finish_theta    = cell2mat(mean_SC2finish_theta);
        
        mean_start2alarm_alpha  = cell2mat(mean_start2alarm_alpha);
        mean_alarm2slider_alpha = cell2mat(mean_alarm2slider_alpha);
        mean_slider2SC_alpha    = cell2mat(mean_slider2SC_alpha);
        mean_SC2finish_alpha    = cell2mat(mean_SC2finish_alpha);
        
        mean_start2alarm_beta   = cell2mat(mean_start2alarm_beta);
        mean_alarm2slider_beta  = cell2mat(mean_alarm2slider_beta);
        mean_slider2SC_beta     = cell2mat(mean_slider2SC_beta);
        mean_SC2finish_beta     = cell2mat(mean_SC2finish_beta);
        
        
        %         sheet = xlsread(srtcat(Parent_Folder,'Experiment',destination))
        
        % Plotting the bar graphs
        length_index =  1:length([mean_start2alarm_alpha(:,1);mean_random_start2alarm_alpha(:,1)]);
        
        %% Alpha variation in 4 parts by repitition column 1 is normal column2 is random
        y_alpha_1_1 = [mean_start2alarm_alpha(:,1);mean_random_start2alarm_alpha(:,1)] ;% Part1 Scenario1 alpha variation with repition
        y_alpha_1_2 = [mean_start2alarm_alpha(:,2);mean_random_start2alarm_alpha(:,2)] ;% Part1 Scenario2 alpha variation with repition
        y_alpha_1_3 = [mean_start2alarm_alpha(:,3);mean_random_start2alarm_alpha(:,3)] ;% Part1 Scenario3 alpha variation with repition
        y_alpha_1_4 = [mean_start2alarm_alpha(:,4);mean_random_start2alarm_alpha(:,4)] ;% Part1 Scenario4 alpha variation with repition
        y_alpha_1_5 = [mean_start2alarm_alpha(:,5);mean_random_start2alarm_alpha(:,5)] ;% Part1 Scenario5 alpha variation with repition
        y_alpha_1_6 = [mean_start2alarm_alpha(:,6);mean_random_start2alarm_alpha(:,6)] ;% Part1 Scenario6 alpha variation with repition
        
        y_alpha_2_1 = [mean_alarm2slider_alpha(:,1);mean_random_alarm2slider_alpha(:,1)];     % Part2 Scenario1 alpha variation with repition
        y_alpha_2_2 = [mean_alarm2slider_alpha(:,2);mean_random_alarm2slider_alpha(:,2)];% Part2 Scenario2 alpha variation with repition
        y_alpha_2_3 = [mean_alarm2slider_alpha(:,3);mean_random_alarm2slider_alpha(:,3)];% Part2 Scenario3 alpha variation with repition
        y_alpha_2_4 = [mean_alarm2slider_alpha(:,4);mean_random_alarm2slider_alpha(:,4)];% Part2 Scenario4 alpha variation with repition
        y_alpha_2_5 = [mean_alarm2slider_alpha(:,5);mean_random_alarm2slider_alpha(:,5)];% Part2 Scenario5 alpha variation with repition
        y_alpha_2_6 = [mean_alarm2slider_alpha(:,6);mean_random_alarm2slider_alpha(:,6)];% Part2 Scenario6 alpha variation with repition
        
        y_alpha_3_1 = [mean_slider2SC_alpha(:,1);mean_random_slider2SC_alpha(:,1)];% Part3 Scenario1 alpha variation with repition
        y_alpha_3_2 = [mean_slider2SC_alpha(:,2);mean_random_slider2SC_alpha(:,2)];% Part3 Scenario2 alpha variation with repition
        y_alpha_3_3 = [mean_slider2SC_alpha(:,3);mean_random_slider2SC_alpha(:,3)];% Part3 Scenario3 alpha variation with repition
        y_alpha_3_4 = [mean_slider2SC_alpha(:,4);mean_random_slider2SC_alpha(:,4)];% Part3 Scenario4 alpha variation with repition
        y_alpha_3_5 = [mean_slider2SC_alpha(:,5);mean_random_slider2SC_alpha(:,5)];% Part3 Scenario5 alpha variation with repition
        y_alpha_3_6 = [mean_slider2SC_alpha(:,6);mean_random_slider2SC_alpha(:,6)];% Part3 Scenario6 alpha variation with repition
        
        y_alpha_4_1 = [mean_SC2finish_alpha(:,1);mean_random_SC2finish_alpha(:,1)];% Part4 Scenario1 alpha variation with repition
        y_alpha_4_2 = [mean_SC2finish_alpha(:,2);mean_random_SC2finish_alpha(:,2)];% Part4 Scenario2 alpha variation with repition
        y_alpha_4_3 = [mean_SC2finish_alpha(:,3);mean_random_SC2finish_alpha(:,3)];% Part4 Scenario3 alpha variation with repition
        y_alpha_4_4 = [mean_SC2finish_alpha(:,4);mean_random_SC2finish_alpha(:,4)];% Part4 Scenario4 alpha variation with repition
        y_alpha_4_5 = [mean_SC2finish_alpha(:,5);mean_random_SC2finish_alpha(:,5)];% Part4 Scenario5 alpha variation with repition
        y_alpha_4_6 = [mean_SC2finish_alpha(:,6);mean_random_SC2finish_alpha(:,6)];% Part4 Scenario6 alpha variation with repition
        
        %% Beta variation in 4 parts by repitition column 1 is normal column2 is random
        y_beta_1_1 = [mean_start2alarm_beta(:,1);mean_random_start2alarm_beta(:,1)] ;% Part1 Scenario1 beta variation with repition
        y_beta_1_2 = [mean_start2alarm_beta(:,2);mean_random_start2alarm_beta(:,2)] ;% Part1 Scenario2 beta variation with repition
        y_beta_1_3 = [mean_start2alarm_beta(:,3);mean_random_start2alarm_beta(:,3)] ;% Part1 Scenario3 beta variation with repition
        y_beta_1_4 = [mean_start2alarm_beta(:,4);mean_random_start2alarm_beta(:,4)] ;% Part1 Scenario4 beta variation with repition
        y_beta_1_5 = [mean_start2alarm_beta(:,5);mean_random_start2alarm_beta(:,5)] ;% Part1 Scenario5 beta variation with repition
        y_beta_1_6 = [mean_start2alarm_beta(:,6);mean_random_start2alarm_beta(:,6)] ;% Part1 Scenario6 beta variation with repition
        
        y_beta_2_1 = [mean_alarm2slider_beta(:,1);mean_random_alarm2slider_beta(:,1)];     % Part2 Scenario1 beta variation with repition
        y_beta_2_2 = [mean_alarm2slider_beta(:,2);mean_random_alarm2slider_beta(:,2)];% Part2 Scenario2 beta variation with repition
        y_beta_2_3 = [mean_alarm2slider_beta(:,3);mean_random_alarm2slider_beta(:,3)];% Part2 Scenario3 beta variation with repition
        y_beta_2_4 = [mean_alarm2slider_beta(:,4);mean_random_alarm2slider_beta(:,4)];% Part2 Scenario4 beta variation with repition
        y_beta_2_5 = [mean_alarm2slider_beta(:,5);mean_random_alarm2slider_beta(:,5)];% Part2 Scenario5 beta variation with repition
        y_beta_2_6 = [mean_alarm2slider_beta(:,6);mean_random_alarm2slider_beta(:,6)];% Part2 Scenario6 beta variation with repition
        
        y_beta_3_1 = [mean_slider2SC_beta(:,1);mean_random_slider2SC_beta(:,1)];% Part3 Scenario1 beta variation with repition
        y_beta_3_2 = [mean_slider2SC_beta(:,2);mean_random_slider2SC_beta(:,2)];% Part3 Scenario2 beta variation with repition
        y_beta_3_3 = [mean_slider2SC_beta(:,3);mean_random_slider2SC_beta(:,3)];% Part3 Scenario3 beta variation with repition
        y_beta_3_4 = [mean_slider2SC_beta(:,4);mean_random_slider2SC_beta(:,4)];% Part3 Scenario4 beta variation with repition
        y_beta_3_5 = [mean_slider2SC_beta(:,5);mean_random_slider2SC_beta(:,5)];% Part3 Scenario5 beta variation with repition
        y_beta_3_6 = [mean_slider2SC_beta(:,6);mean_random_slider2SC_beta(:,6)];% Part3 Scenario6 beta variation with repition
        
        y_beta_4_1 = [mean_SC2finish_beta(:,1);mean_random_SC2finish_beta(:,1)];% Part4 Scenario1 beta variation with repition
        y_beta_4_2 = [mean_SC2finish_beta(:,2);mean_random_SC2finish_beta(:,2)];% Part4 Scenario2 beta variation with repition
        y_beta_4_3 = [mean_SC2finish_beta(:,3);mean_random_SC2finish_beta(:,3)];% Part4 Scenario3 beta variation with repition
        y_beta_4_4 = [mean_SC2finish_beta(:,4);mean_random_SC2finish_beta(:,4)];% Part4 Scenario4 beta variation with repition
        y_beta_4_5 = [mean_SC2finish_beta(:,5);mean_random_SC2finish_beta(:,5)];% Part4 Scenario5 beta variation with repition
        y_beta_4_6 = [mean_SC2finish_beta(:,6);mean_random_SC2finish_beta(:,6)];% Part4 Scenario6 beta variation with repition
        
        %% Theta variation in 4 parts by repitition column 1 is normal column2 is random
        y_theta_1_1 = [mean_start2alarm_theta(:,1);mean_random_start2alarm_theta(:,1)] ;% Part1 Scenario1 theta variation with repition
        y_theta_1_2 = [mean_start2alarm_theta(:,2);mean_random_start2alarm_theta(:,2)] ;% Part1 Scenario2 theta variation with repition
        y_theta_1_3 = [mean_start2alarm_theta(:,3);mean_random_start2alarm_theta(:,3)] ;% Part1 Scenario3 theta variation with repition
        y_theta_1_4 = [mean_start2alarm_theta(:,4);mean_random_start2alarm_theta(:,4)] ;% Part1 Scenario4 theta variation with repition
        y_theta_1_5 = [mean_start2alarm_theta(:,5);mean_random_start2alarm_theta(:,5)] ;% Part1 Scenario5 theta variation with repition
        y_theta_1_6 = [mean_start2alarm_theta(:,6);mean_random_start2alarm_theta(:,6)] ;% Part1 Scenario6 theta variation with repition
        
        y_theta_2_1 = [mean_alarm2slider_theta(:,1);mean_random_alarm2slider_theta(:,1)];     % Part2 Scenario1 theta variation with repition
        y_theta_2_2 = [mean_alarm2slider_theta(:,2);mean_random_alarm2slider_theta(:,2)];% Part2 Scenario2 theta variation with repition
        y_theta_2_3 = [mean_alarm2slider_theta(:,3);mean_random_alarm2slider_theta(:,3)];% Part2 Scenario3 theta variation with repition
        y_theta_2_4 = [mean_alarm2slider_theta(:,4);mean_random_alarm2slider_theta(:,4)];% Part2 Scenario4 theta variation with repition
        y_theta_2_5 = [mean_alarm2slider_theta(:,5);mean_random_alarm2slider_theta(:,5)];% Part2 Scenario5 theta variation with repition
        y_theta_2_6 = [mean_alarm2slider_theta(:,6);mean_random_alarm2slider_theta(:,6)];% Part2 Scenario6 theta variation with repition
        
        y_theta_3_1 = [mean_slider2SC_theta(:,1);mean_random_slider2SC_theta(:,1)];% Part3 Scenario1 theta variation with repition
        y_theta_3_2 = [mean_slider2SC_theta(:,2);mean_random_slider2SC_theta(:,2)];% Part3 Scenario2 theta variation with repition
        y_theta_3_3 = [mean_slider2SC_theta(:,3);mean_random_slider2SC_theta(:,3)];% Part3 Scenario3 theta variation with repition
        y_theta_3_4 = [mean_slider2SC_theta(:,4);mean_random_slider2SC_theta(:,4)];% Part3 Scenario4 theta variation with repition
        y_theta_3_5 = [mean_slider2SC_theta(:,5);mean_random_slider2SC_theta(:,5)];% Part3 Scenario5 theta variation with repition
        y_theta_3_6 = [mean_slider2SC_theta(:,6);mean_random_slider2SC_theta(:,6)];% Part3 Scenario6 theta variation with repition
        
        y_theta_4_1 = [mean_SC2finish_theta(:,1);mean_random_SC2finish_theta(:,1)];% Part4 Scenario1 theta variation with repition
        y_theta_4_2 = [mean_SC2finish_theta(:,2);mean_random_SC2finish_theta(:,2)];% Part4 Scenario2 theta variation with repition
        y_theta_4_3 = [mean_SC2finish_theta(:,3);mean_random_SC2finish_theta(:,3)];% Part4 Scenario3 theta variation with repition
        y_theta_4_4 = [mean_SC2finish_theta(:,4);mean_random_SC2finish_theta(:,4)];% Part4 Scenario4 theta variation with repition
        y_theta_4_5 = [mean_SC2finish_theta(:,5);mean_random_SC2finish_theta(:,5)];% Part4 Scenario5 theta variation with repition
        y_theta_4_6 = [mean_SC2finish_theta(:,6);mean_random_SC2finish_theta(:,6)];% Part4 Scenario6 theta variation with repition
        
        %% Plotting bar graph for variation in alpha with repititions in part1 - part4
        
        waves = {'alpha', 'beta','theta'}
        for wave = 1:3
            for  f = 1:4
                figure('units','normalized','outerposition',[0 0 1 1])
                for m = 1
                    if strcmpi(cell2mat(waves(wave)),'alpha')
                        lim = 35;
                    elseif strcmpi(cell2mat(waves(wave)),'beta')
                        lim = 30;
                    else
                        lim = 40;
                    end
                    subplot(2,3,m)
                    bar(length_index,eval(strcat('y_',cell2mat(waves(wave)),'_',num2str(f),'_',num2str(m))),1);
                    ylabel('PSD Scenario 1')
                    xlabel('Repetition')
                    ylim([0 30])
                    xlim([0 length(length_index)+1])
                    
                    subplot(2,3,m+1)
                    bar(length_index,eval(strcat('y_',cell2mat(waves(wave)),'_',num2str(f),'_',num2str(m+1))),1);
                    ylabel('PSD Scenario 2')
                    xlabel('Repetition')
                    ylim([0 30])
                    xlim([0 length(length_index)+1])
                    axes('Units', 'normalized', 'Position', [0 0 1 1])
                    
                    subplot(2,3,m+2)
                    bar(length_index,eval(strcat('y_',cell2mat(waves(wave)),'_',num2str(f),'_',num2str(m+2))),1);
                    ylabel('PSD Scenario 3')
                    ylim([0 30])
                    xlim([0 length(length_index)+1])
                    
                    subplot(2,3,m+3)
                    bar(length_index,eval(strcat('y_',cell2mat(waves(wave)),'_',num2str(f),'_',num2str(m+3))),1);
                    ylabel('PSD Scenario 4')
                    xlabel('Repetition')
                    ylim([0 30])
                    xlim([0 length(length_index)+1])

                    subplot(2,3,m+4)
                    bar(length_index,eval(strcat('y_',cell2mat(waves(wave)),'_',num2str(f),'_',num2str(m+4))),1);
                    ylabel('PSD Scenario 5')
                    xlabel('Repetition')
                    ylim([0 30])
                    xlim([0 length(length_index)+1])

                    subplot(2,3,m+5)
                    bar(length_index,eval(strcat('y_',cell2mat(waves(wave)),'_',num2str(f),'_',num2str(m+5))),1);
                    ylabel('PSD Scenario 6')
                    xlabel('Repetition')
                    ylim([0 30])
                    xlim([0 length(length_index)+1])
                    
                    a = axes;
                    t1 = title({strcat('PSD -', upper(cell2mat(waves(wave))) ,' - VARIATION IN TASK ','-',num2str(f));''});
                    a.Visible = 'off'; % set(a,'Visible','off');
                    t1.Visible = 'on'; % set(t1,'Visible','on');
                    print(figure(1),fullfile(strcat(Main_Folder,participant),['PSD_',cell2mat(waves(wave)),'_Part',num2str(f),'_Scenario_all', '.png']),'-dpng','-r1000');
                    close all
                end
            end
        end
    end
end

%
%
%         for  f = 1:4
%             for m = 1
%                 figure(f)
%                 title(strcat('PSD VARIATION IN SCENARIO ','-',num2str(f)))
%                 subplot(2,3,m)
%                 bar(length_index,eval(strcat('y_beta_',num2str(f),'_',num2str(m))),1);
%                 ylabel('PSD Scenario 1')
%                 xlabel('Repetition')
%                 ylim([0 30])
%                 xlim([0 length(length_index)+1])
%
%                 subplot(2,3,m+1)
%                 bar(length_index,eval(strcat('y_beta_',num2str(f),'_',num2str(m+1))),1);
%                 ylabel('PSD Scenario 2')
%                 xlabel('Repetition')
%                 ylim([0 30])
%                 xlim([0 length(length_index)+1])
%
%                 subplot(2,3,m+2)
%                 bar(length_index,eval(strcat('y_beta_',num2str(f),'_',num2str(m+2))),1);
%                 ylabel('PSD Scenario 3')
%                 ylim([0 30])
%                 xlim([0 length(length_index)+1])
%
%                 subplot(2,3,m+3)
%                 bar(length_index,eval(strcat('y_beta_',num2str(f),'_',num2str(m+3))),1);
%                 ylabel('PSD Scenario 4')
%                 xlabel('Repetition')
%                 ylim([0 30])
%                 xlim([0 length(length_index)+1])
%
%                 subplot(2,3,m+4)
%                 bar(length_index,eval(strcat('y_beta_',num2str(f),'_',num2str(m+4))),1);
%                 ylabel('PSD Scenario 5')
%                 xlabel('Repetition')
%                 ylim([0 30])
%                 xlim([0 length(length_index)+1])
%
%                 subplot(2,3,m+5)
%                 bar(length_index,eval(strcat('y_beta_',num2str(f),'_',num2str(m+5))),1);
%                 ylabel('PSD Scenario 6')
%                 xlabel('Repetition')
%                 ylim([0 30])
%                 xlim([0 length(length_index)+1])
%
%                 a = axes;
%                 t1 = title({strcat('PSD BETA VARIATION IN TASK ','-',num2str(f));''});
%                 a.Visible = 'off'; % set(a,'Visible','off');
%                 t1.Visible = 'on'; % set(t1,'Visible','on');
%                 print(figure(f),fullfile(strcat(Main_Folder,participant),['PSD_beta_Part',num2str(f),'_Scenario_all', '.png']),'-dpng','-r800');
%
%             end
%         end
%
%
%
%
%
%         %% Plotting the theta variation, scenario ;experiment and task wise
%         for  f = 1:4
%             for m = 1
%                 figure(f)
%
%                 subplot(2,3,m)
%                 bar(length_index,eval(strcat('y_theta_',num2str(f),'_',num2str(m))),1);
%                 ylabel('PSD Scenario 1')
%                 xlabel('Repetition')
%                 ylim([0 40])
%                 xlim([0 length(length_index)+1])
%
%                 subplot(2,3,m+1)
%                 bar(length_index,eval(strcat('y_theta_',num2str(f),'_',num2str(m+1))),1);
%                 ylabel('PSD Scenario 2')
%                 xlabel('Repetition')
%                 ylim([0 40])
%                 xlim([0 length(length_index)+1])
%
%                 subplot(2,3,m+2)
%                 bar(length_index,eval(strcat('y_theta_',num2str(f),'_',num2str(m+2))),1);
%                 ylabel('PSD Scenario 3')
%                 ylim([0 40])
%                 xlim([0 length(length_index)+1])
%
%                 subplot(2,3,m+3)
%                 bar(length_index,eval(strcat('y_theta_',num2str(f),'_',num2str(m+3))),1);
%                 ylabel('PSD Scenario 4')
%                 xlabel('Repetition')
%                 ylim([0 40])
%                 xlim([0 length(length_index)+1])
%
%                 subplot(2,3,m+4)
%                 bar(length_index,eval(strcat('y_theta_',num2str(f),'_',num2str(m+4))),1);
%                 ylabel('PSD Scenario 5')
%                 xlabel('Repetition')
%                 ylim([0 40])
%                 xlim([0 length(length_index)+1])
%
%                 subplot(2,3,m+5)
%                 bar(length_index,eval(strcat('y_theta_',num2str(f),'_',num2str(m+5))),1);
%                 ylabel('PSD Scenario 6')
%                 xlabel('Repetition')
%                 ylim([0 40])
%                 xlim([0 length(length_index)+1])
%
%                 a = axes;
%                 t1 = title({strcat('PSD THETA VARIATION IN TASK ','-',num2str(f));''});
%                 a.Visible = 'off'; % set(a,'Visible','off');
%                 t1.Visible = 'on'; % set(t1,'Visible','on');
%                 print(figure(f),fullfile(strcat(Main_Folder,participant),['PSD_theta_Part',num2str(f),'_Scenario_all', '.png']),'-dpng','-r800');
%
%             end
%         end
%     end
% end




