% 
% clc
% ASSIGNING THE FOLDER PATH AND SOURCE
% hThis code contains data from the rest period to finish of the experiment
for destination = 1:10
    clearvars -except destination Delta_EEG_eye_tracker
    clc
    warning('off')
    format short g
    Main_Folder = 'D:\Mahindra\Adaptive filter\PSD_Filters\From Rest Period\4_points_to_10seconds_expt_file\4_points_new\4_point\EEGDATA\';
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
%                         fold_nms1 = Folder;
%                         fold_nms2 = char(fold_nms1);
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
%                         fold_nms1 = Folder;
%                         fold_nms2 = char(fold_nms1);
        end
%         load(strcat('Participant',num2str(destination),'_0.5_100Hz.mat'))

%         %% Importing the Alarm Files
%         alarm_file = [];
%         alarm_name = [];
%         for k=1:length(Folder)
%             path=strcat(Parent_Folder,Folder(k).name,'\');
%             for m=1:6
%                 read= {strcat(path,'Alarm_timing'),strcat('Sheet',num2str(m))};
%                 [alarm_file{k,m},alarm_name{k,m}] = xlsread(read{1},read{2});
%                 p = table2array(alarm_file(k,m));
%                 name = strcat(participant,sch,'_expt_',num2str(k),'_scenario_',num2str(m)); % will save in format alarm_n_scenario_m
%                 eval(strcat(name,'=',mat2str(p(:,1))))
%             end
%         end
%         
%         %% Importing the Alarm files for Slider Positioning
%         alarm_file1 = [];
%         alarm_name1 = [];
%         for k=1:length(Folder)
%             path=strcat(Parent_Folder,Folder(k).name,'\');
%             for m=1:6
%                 read= {strcat(path,'Alarm_timing1'),strcat('Sheet',num2str(m))};
%                 [alarm_file1{k,m},alarm_name1{k,m}] = xlsread(read{1},read{2});
%             end
%         end
%         
%         %% Importing the Mouse click files
%         mouseclick = [];
%         for k=1:length(Folder)
%             path=strcat(Parent_Folder,Folder(k).name,'\');
%             for m=1:6
%                 read={strcat(path,'Mouse_click'),strcat('Sheet',num2str(m))};
%                 [mouseclick{k,m},txtData{k,m}]=xlsread(read{1},read{2});
%                 q = table2array(mouseclick(k,m)); % q is a temporary variable to convert table to array
%                 name1 = strcat(participant,sch,'_expt_',num2str(k),'_mouse_click',num2str(m)); % will save in format alarm_n_scenario_m
%                 name2 = strcat(participant,sch,'_expt_',num2str(k),'_sliderdata_scenario_',num2str(m)); % Syntax for slider data
%                 eval(strcat(name1,'=',mat2str(q(:,1)))); % matrix to string so that it can be used in eval function # scenario timings
%                 eval(strcat(name2,'=',mat2str(q(:,7)))); % ## slider values
%             end
%         end
%         %% Mouse Click files for Slider positioning
%         mouseclick1 = [];
%         for k=1:length(Folder)
%             path=strcat(Parent_Folder,Folder(k).name,'\');
%             for m=1:6
%                 read={strcat(path,'Mouse_click1'),strcat('Sheet',num2str(m))};
%                 [mouseclick1{k,m},txtData1{k,m}]=xlsread(read{1},read{2});
%             end
%         end
%         
%         % Importing the eye tracker data
%         EYE_ti1e = [];
%         EYE_X = [];
%         EYE_Y = [];
%         for k=1:length(Folder)
%             path=strcat(Parent_Folder,Folder(k).name,'\');
%             for m=1
%                 read={strcat(path,'EYE_TRACKER.xlsx')};
%                 EYE_time{k,1}=readtable(read{1},'Range','Z:Z');
%                 EYE_X{k,1}   =readtable(read{1},'Range','AD:AD');
%                 EYE_Y{k,1}   =readtable(read{1},'Range','AE:AE');
%                 eye{k,1} = [table2array(EYE_Y{k,1}),table2array(EYE_X{k,1})];
%                 name1 = strcat(participant,sch,'_expt_',num2str(k),'_XY_cordinate_',num2str(1)); % will save in format alarm_n_scenario_m
%                 eval(strcat(name1,'=',mat2str(eye{k,1})));
%                 
%                 %Noting the start point fro1 eye tracking data " By Coordinates "
%                 s = {};
%                 p=[];
%                 jm =1;
%                 eye_name = strcat('name_',num2str(k),'_',num2str(1)); % will save in format alarm_n_scenario_m
%                 eval(strcat(eye_name,'=',mat2str(eval(strcat(participant,sch,'_expt_',num2str(k),'_XY_cordinate_',num2str(1))))));
%                 name = eval(strcat('name','_',num2str(k),'_',num2str(1))); % will save in format alarm_n_scenario_m
%                 
%                 for i=1:length(name(:,1))  % Index is length of the Eye tracker data
%                     if (name(i,2) >= 900 && name(i,2) <= 1023 && name(i,1) >= 638 && name(i,1) <= 694)
%                         p(i)=i;
%                         jm=jm+1;
%                     end
%                 end
%                 s = strcat('start','expt',num2str(k));
%                 eval(strcat(s,'=',mat2str((find(p>0)))));
%             end
%         end
%         %% EEG Timestamp
%         eeg_timestamp = [];
%         for k=1:length(Folder)
%             path=strcat(Parent_Folder,Folder(k).name,'\');
%             for m=1
%                 read={strcat(path,'EEG_timestamp')};
%                 load(read{1}); % Loading the EEG_Ti1esta1p data
%                 time_eeg_record{k,1} = EEG_timestamp{1,1}.Hour*3600 + EEG_timestamp{1,1}.Minute*60 + EEG_timestamp{1,1}.Second; % Ti1e in seconds EEG started recording the data
%                 u = table2array(time_eeg_record(k,1));
%                 name = strcat(participant,sch,'_expt_',num2str(k),'_eeg_time_',num2str(1)); % will save in for1at alar1_n_scenario_1
%                 eval(strcat(name,'=',mat2str(u(:,1))));
%             end
%         end
%         %% Importing the raw EEG data
%         eeg_raw = [];
%         for k=1:length(Folder)
%             path=strcat(Parent_Folder,Folder(k).name,'\');
%             for m=1
%                 read={strcat(path,'data.csv')};
%                 eeg_raw{k,1} = {csvread(read{1})};
%                 v = eeg_raw{k,1}{1,1}(:,5);
%                 name = strcat(participant,sch,'_expt_',num2str(k),'_eeg_raw_',num2str(1)); % will save in format alarm_n_scenario_m
%                 eval(strcat(name,'=',mat2str(v(:,1))));
%             end
%         end
%         
%         %% Time Sorting and Synchronising the EEG && Eye tracking data
%         expt_start = [];
%         Delta_EEG = [];
%         experiment_start_point = [];
%         y_1=[];
%         k =[];
%         t_eyetracker_start_seconds = [];
%         t_eeg_start_seconds = [];
%         t_expt_start_seconds = [];
%         t_expt_next_seconds = [];
%         eeg_data=[];
%         mouse_click = [];
%         % Experiment
%         for k=1:length(Folder)
%             path=strcat(Parent_Folder,Folder(k).name,'\');
%             % Eye tracker Start
%             y_1 = table2array(EYE_time{k,1}{1,1});% Timestamp when recording of eye tracker started
%             name = strcat('t_expt_start',num2str(k),'_',num2str(1)); % will save in format alarm_n_scenario_m
%             eval(strcat(name,'=',mat2str(y_1)));
%             t_expt_start_ts = datetime(eval(strcat('t_expt_start',num2str(k),'_',num2str(1))),'convertfrom','posixtime', 'Format','HH:mm:ss.SSS'); % Biulding the HH:MM:SS format
%             t_eyetracker_start_seconds =padconcatenation(t_eyetracker_start_seconds, t_expt_start_ts.Hour*3600 + t_expt_start_ts.Minute*60 + t_expt_start_ts.Second,1); % Time Eye tracker start recording in seconds
%             
%             %EEG recording start
%             t_eeg_start_seconds =padconcatenation(t_eeg_start_seconds,eval(strcat(participant,sch,'_expt_',num2str(k),'_eeg_time_1')),1); % Time in seconds of eeg when started
%             
%             %Click next_point
%             z = EYE_time{k,1};
%             experiment_start_point = eval(strcat('startexpt',num2str(k))); % Experiment 1
%             z1 = experiment_start_point(1,1);
%             z = table2array(z(z1,1));
%             expt_start_pointtime = datetime(z,'convertfrom','posixtime', 'Format','HH:mm:ss.SSSSSS');
%             t_expt_next_seconds = padconcatenation(t_expt_next_seconds,expt_start_pointtime.Hour*3600 + expt_start_pointtime.Minute*60 + expt_start_pointtime.Second,1) ;% Experiment start(Clicked) in seconds
%             
%             %Click_start_point
%             mouse_click = eval(strcat(participant,sch,'_expt_',num2str(k),'_mouse_click',num2str(1)));
%             t_expt_start_seconds = padconcatenation(t_expt_start_seconds,(t_expt_next_seconds(k,1)+ mouse_click(1,1)),1);
%             
%             % EEG time not important
%             Delta_EEG_eye_tracker{destination,1}(k,1) = (t_expt_next_seconds(k,1)-t_eeg_start_seconds(k,1)); %   EEG time which is not important
%             
% 
% 
%             %EEG data
%             end_time = eval(strcat(participant,sch,'_expt_',num2str(k),'_mouse_click6'));
%             eeg_end = Delta_EEG_eye_tracker{destination,1}(k,1) + end_time(length(end_time),1);
%             rawdata = eval(strcat(participant,sch,'_expt_',num2str(k),'_eeg_raw_',num2str(1)));
%             if Delta_EEG_eye_tracker{destination,1}(k,1) > 120
%                 eeg_data =rawdata((Delta_EEG_eye_tracker{destination,1}(k,1)-120)*512:eeg_end*512); % Actual Data of EEG
%             else
%                 eeg_data =rawdata(1:eeg_end*512); % Actual Data of EEG
%             end
            %Saving the eeg data to desired folder
%             fnm =[Parent_Folder strcat(participant,'.',num2str(k)) '\' 'eeg_data.txt'];
%             fid = fopen(fnm,'wt');
%             fprintf(fid,'%.2f\n',eeg_data);
%             fclose(fid);
%             save('eeg_data.txt','eeg_data','-ascii')

%             % Saving Bandpass filtered data
%             ip_sig = load(strcat(path,'eeg_data.txt'));
%             sampleRate = 512; % Hz
%             lowEnd  = 0.5; % Hz
%             highEnd = 100; % Hz
% %             filterOrder = 10; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
% %             [b, a] = butter(filterOrder, [lowEnd highEnd]/(sampleRate/2)); % Generate filter coefficients
% %             filteredData_data = filtfilt(b, a, ip_sig); % Apply filter to data using zero-phase filtering
%             
%             filteredData_data = bandpass(ip_sig,[lowEnd highEnd],512);
%             fnm =[Parent_Folder strcat(participant,'.',num2str(k)) '\' 'eeg_data_filtered.txt'];
%             fid = fopen(fnm,'wt');
%             fprintf(fid,'%.2f\n',filteredData_data);
%             fclose(fid);
%             save('eeg_data_BP_0_100.txt','filteredData_data','-ascii')
%         end
%     save(strcat('Participant',num2str(destination),'_For_Adaptive filter_PSD.mat'));
    load(strcat('Participant',num2str(destination),'_For_Adaptive filter_PSD.mat'));
    
    
        %% EEGLAB
        % Experiment
        % EEGLAB history file generated on the 14-Jul-2019
        % ------------------------------------------------
        % Forming Good PSD Data
        % Saving good data PSD in Experiment_new_rest_for_AF excel sheet
        path = [];
        L = 1;
        o = 1;
        warning('off')
        clear time1 time2 time3 time4
        clear x_1 x_2 x_3 x_4 y_1 y_2 y_3 y_4
        for k=1:length(Folder) 
            path=strcat(Parent_Folder,Folder(k).name,'\');
            disp(path)
            for m =1:6
                
                % Start to 1st alarm
                %EEG.etc.eeglabvers = '2019.0'; % this tracks which version of EEGLAB is being used, you may ignore it
                [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
                EEG = pop_importdata('dataformat','ascii','nbchan',1,'data',strcat(Parent_Folder,participant,'.',num2str(k),'\eeg_data_Median_filter_0.5sec.txt'),'setname','applicant','srate',512,'pnts',1,'xmin',0);
                [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off');
                EEG = eeg_checkset( EEG );
                start_scenario = eval(strcat(participant,sch,'_expt_',num2str(k),'_mouse_click',num2str(m)));
                start_alarm = eval(strcat(participant,sch,'_expt_',num2str(k),'_scenario_',num2str(m)));
                
                % Rest Period of the Participant
                L = 1;
                figure(L)
                if Delta_EEG_eye_tracker{destination,1}(k,1) <= 120
                    diff_rest = abs(Delta_EEG_eye_tracker{destination,1}(k,1));
                else
                    diff_rest = abs(120);
                end
                N = ceil(diff_rest/10);
                time_step = 10;
                clear x_1 y_1 time_rest S_theta_rest S_alpha_rest S_beta_rest mean_time_rest time_mean_rest time_mean_plotting  time1
                clear x y time S_theta S_alpha S_beta mean_time time_action_mean time_mean time_action time time_rest time2 time3 time4
                for i = 1:N-1
                    time_rest{i} = ((i-1)*10)+1:((i-1)*10)+time_step;                  
                    time1 = time_rest{i}(1,1)*512- sum(isnan(ip_signal_100_100{destination,1}{k}(1:time_rest{i}(1,1)*512,1)));
                    time2 = time1 + time_rest{i}(1,length(time_rest{i}))*512-time_rest{i}(1,1)*512 - sum(isnan(ip_signal_100_100{destination,1}{k}(time_rest{i}(1,1)*512:time_rest{i}(1,length(time_rest{i}))*512,1)));
                    %                     pop_spectopo(EEG, 1, [time_rest{i}*512 time{1,i}(1,length(time{1,i}))*512], 'EEG' , 'freqrange',[2 30],'electrodes','on'); % First slider action to completion of scenario
                    pop_spectopo(EEG, 1, [time1 time2], 'EEG' , 'freqrange',[2 30],'electrodes','on');
                    h4 = findobj(gca,'Type','line');
                    x_1{i}=get(h4,'Xdata');
                    y_1{i}=get(h4,'Ydata'); 
                    close all
                    S_theta_rest{i} = mean(y_1{1,i}(1,5:8));
                    S_alpha_rest{i} = mean(y_1{1,i}(1,9:13));
                    if length(y_1{1,i}) <31
                        append = mean(y_1{1,i}(1,14:length(y_1{1,i})));
                        diff = 31-length(y_1{1,i});
                        insert = append + zeros(diff,1);
                        y_1{i} = [y_1{i}';insert]';
                    end
                    S_beta_rest{i}  = mean(y_1{1,i}(1,14:31));
                    time_mean_rest{i} = floor(mean(time_rest{i}));
                end
                
                time_rest{N} = time_rest{1,N-1}(1,length(time_rest{1,N-1}))+1 : diff_rest;
                if length(time_rest{1,N})<3
                    
                    time_rest{N} = time_rest{1,N-1}(1,length(time_rest{1,N-1}))-3 : diff_rest;
                else
                    time_rest{N} = time_rest{1,N-1}(1,length(time_rest{1,N-1}))+1 : diff_rest;
                end
                
                time3 = time_rest{1,N}(1,1)*512- sum(isnan(ip_signal_100_100{destination,1}{k}(1:time_rest{1,N}(1,1)*512,1)));
                time4 = time3 + time_rest{1,N}(1,length(time_rest{1,N}))*512 - time_rest{1,N}(1,1)*512 - sum(isnan(ip_signal_100_100{destination,1}{k}(time_rest{1,N}(1,1)*512:time_rest{1,N}(1,length(time_rest{1,N}))*512,1)));
                pop_spectopo(EEG, 1, [time3 time4], 'EEG' , 'freqrange',[2 30],'electrodes','on'); % First slider action to completion of scenario
                h4 = findobj(gca,'Type','line');
                x_1{N}=get(h4,'Xdata');
                y_1{N}=get(h4,'Ydata');
                time_mean_rest{N} = floor(mean(time_rest{N}));
                close all
                S_theta_rest{N} = mean(y_1{1,N}(1,5:8));
                S_alpha_rest{N} = mean(y_1{1,N}(1,9:13));
                S_beta_rest{N}  = mean(y_1{1,N}(1,14:31));
                if length(y_1{1,N}) <31
                    append = mean(S_beta_rest{N});
                    diff = 31-length(y_1{1,N});
                    insert = append + zeros(diff,1);
                    y_1{N} = [y_1{N}';insert]';
                end
                y_3_10seconds_rest = reshape(cell2mat(y_1(1:N)),[31,N]); % Data from First slider action to finish of experiment oin 10 seconds interval
                S_theta_rest=   cell2mat(S_theta_rest);
                S_alpha_rest = cell2mat(S_alpha_rest);
                S_beta_rest = cell2mat(S_beta_rest);
                mean_time_rest = cell2mat(time_mean_rest);
                close all
                
                % Start to 1st alarm
                clear time1 time2 time3 time4
                figure(L)
                time1 = (diff_rest + start_scenario(1,1))*512- sum(isnan(ip_signal_100_100{destination,1}{k}(1:(diff_rest + start_scenario(1,1))*512,1)));
                time2 = time1 + (diff_rest+ start_alarm(1,1))*512 - (diff_rest + start_scenario(1,1))*512 - sum(isnan(ip_signal_100_100{destination,1}{k}((diff_rest + start_scenario(1,1))*512:(diff_rest+ start_alarm(1,1))*512,1)));
                pop_spectopo(EEG, 1, [time1  time2], 'EEG' , 'freqrange',[2 30],'electrodes','on'); % Start to Start of task           
                h1 = findobj(gca,'Type','line');
                x_2=get(h1,'Xdata');
                y_2=get(h1,'Ydata');
                if length(y_2) <31
                    append = mean(y_2(14:length(y_3)));
                    diff = 31-length(y_2);
                    insert = append + zeros(diff,1);
                    y_2 = [y_2';insert]';
                end
                upper_limit_1 = max(y_2) + 5-rem(max(y_2),5);
                ylim([0 upper_limit_1])
                xlabel('Frequency')
                title('PSD(1)')
                grid on
                ylabel({'S({\omega})';'{\mu}V^2/Hz'})
                S_theta1 = mean(y_2(5:8)); S_alpha1 = mean(y_2(9:13)); S_beta1 = mean(y_2(14:14:length(y_2)));%S_gamma1 = mean(y_1(22:26));
                close all
                
                % 1ST ALARM TO fIRST SLIDER ACTION
                clear time1 time2 time3 time4
                if start_scenario(4,1) - start_alarm(1,1) == 1 || start_scenario(4,1) - start_alarm(1,1) == 0
                    timet = start_scenario(4,1) + 2;
                else
                    timet = start_scenario(4,1);
                end
                time1 = (diff_rest+ start_alarm(1,1))*512- sum(isnan(ip_signal_100_100{destination,1}{k}(1:(diff_rest+ start_alarm(1,1))*512,1)));
                time2= time1 + (diff_rest + timet)*512 - (diff_rest+ start_alarm(1,1))*512 - sum(isnan(ip_signal_100_100{destination,1}{k}((diff_rest+ start_alarm(1,1))*512:(diff_rest + timet)*512,1)));
                pop_spectopo(EEG, 1, [time1 time2], 'EEG' , 'freqrange',[2 30],'electrodes','on'); % Task to 1st slider action
                h2 = findobj(gca,'Type','line');
                x_3=get(h2,'Xdata');
                y_3=get(h2,'Ydata');
                if length(y_3) <31
                    append = mean(y_3(14:length(y_3)));
                    diff = 31-length(y_3);
                    insert = append + zeros(diff,1);
                    y_3 = [y_3';insert]';
                end
                upper_limit_2 = max(y_3) + 5-rem(max(y_3),5);
                ylim([0 upper_limit_2]);
                ylabel({'S({\omega})';'{\mu}V^2/Hz '})
                xlabel('Frequency')
                title('PSD(2)')
                grid on
                S_theta2 = mean(y_3(5:8)); S_alpha2 = mean(y_3(9:13)); S_beta2 = mean(y_3(14:length(y_3)));%S_gamma2 = mean(y_3(22:26));
                close all
                %
                %                 % Slider Action to Plant coming back to normal
                %                 subplot(2,2,3)
                %                 pop_spectopo(EEG, 1, [start_scenario(4,1)*512  start_scenario(length(start_scenario),1)*512], 'EEG' , 'freqrange',[2 30],'electrodes','on'); % First slider action to completion of scenario
                %                 h3 = findobj(gca,'Type','line');
                %                 x_3=get(h3,'Xdata');
                %                 y_3=get(h3,'Ydata');
                %                 upper_limit_3 = max(y_3) + 5-rem(max(y_3),5);
                %                 ylim([0 upper_limit_3]);
                %                 ylabel({'S({\omega})';'{\mu}V^2/Hz '})
                %                 xlabel('Frequency')
                %                 title('PSD(3)')
                %                 grid on
                %                 S_theta3 = mean(y_3(5:8)); S_alpha3 = mean(y_3(9:13)); S_beta3 = mean(y_3(14:length(y_3)));%S_gamma3 = mean(y_3(22:26));
                %
                %                 % Scenario Complete to Finish of experiment
                %                 subplot(2,2,4)
                %                 pop_spectopo(EEG, 1, [start_alarm(length(start_alarm),1)*512 start_scenario(length(start_scenario),1)*512], 'EEG' , 'freqrange',[2 30],'electrodes','on'); % First slider action to completion of scenario
                %                 h4 = findobj(gca,'Type','line');
                %                 x_4=get(h4,'Xdata');
                %                 y_4=get(h4,'Ydata');
                %                 upper_limit_4 = max(y_4) + 5-rem(max(y_4),5);
                %                 ylim([0 upper_limit_4]);
                %                 ylabel({'S({\omega})';'{\mu}V^2/Hz '})
                %                 xlabel('Frequency')
                %                 title('PSD(4)')
                %                 grid on
                %                 S_theta4 = mean(y_4(5:8)); S_alpha4 = mean(y_4(9:13)); S_beta4 = mean(y_4(14:length(y_4)));%S_gamma4 = mean(y_4(22:26));
                % %                 print(figure(L),fullfile(path,['PSD_expt_',num2str(k),'_Task_',num2str(m),'_part_all', '.png']),'-dpng','-r800');
                close all
                
                %% PSD 10 seconds windows
                clear time1 time2 time3 time4
                diff = abs(start_scenario(4,1) - start_scenario(length(start_scenario),1));
                N = ceil(diff/10);
                time_a1 = diff_rest + start_scenario(4,1);
                time_a2 = diff_rest + 10+start_scenario(4,1);
                for i = 1:N-1
                    time_action{i} = ((i-1)*10)+time_a1+1:((i-1)*10)+time_a2;
                    time1 = time_action{1,i}(1,1)*512- sum(isnan(ip_signal_100_100{destination,1}{k}(1:time_action{1,i}(1,1)*512,1)));
                    time2 = time1 + time_action{1,i}(1,length(time_action{1,i}))*512 - time_action{1,i}(1,1)*512 - sum(isnan(ip_signal_100_100{destination,1}{k}(time_action{1,i}(1,1)*512:time_action{1,i}(1,length(time_action{1,i}))*512,1)));
                    pop_spectopo(EEG, 1, [time1 time2], 'EEG' , 'freqrange',[2 30],'electrodes','on'); % First slider action to completion of scenario
                    h4 = findobj(gca,'Type','line');
                    x{i}=get(h4,'Xdata');
                    y{i}=get(h4,'Ydata');
                    close all
                    S_theta{i} = mean(y{1,i}(1,5:8));
                    S_alpha{i} = mean(y{1,i}(1,9:13));
                    S_beta{i}  = mean(y{1,i}(1,14:31));
                    time_action_mean{i} = floor(mean(cell2mat(time_action(i))));
                end
                time_action{N} = time_action{1,N-1}(1,length(time_action{1,N-1}))+1 : (diff_rest + start_scenario(length(start_scenario),1));
                if length(time_action{1,N})<3
                    
                    time_action{N} = time_action{1,N-1}(1,length(time_action{1,N-1}))-3 : diff_rest+start_scenario(length(start_scenario),1);
                else
                    time_action{N} = time_action{1,N-1}(1,length(time_action{1,N-1}))+1 : (diff_rest + start_scenario(length(start_scenario),1));
                end
                time3 = time_action{1,N}(1,1)*512- sum(isnan(ip_signal_100_100{destination,1}{k}(1:time_action{1,N}(1,1)*512,1)));
                if m<6
                    time4 = time1 + time_action{1,N}(1,length(time_action{1,N}))*512 - time_action{1,N}(1,1)*512 - sum(isnan(ip_signal_100_100{destination,1}{k}((time_action{1,N}(1,1)*512:time_action{1,N}(1,length(time_action{1,N}))*512),1)));
                else
                    time4 = time1 + time_action{1,N}(1,length(time_action{1,N}))*512 - time_action{1,N}(1,1)*512 - sum(isnan(ip_signal_100_100{destination,1}{k}((time_action{1,N}(1,1)*512:end),1)));
                end
                pop_spectopo(EEG, 1, [time1 time2], 'EEG' , 'freqrange',[2 30],'electrodes','on'); % Task to 1st slider action
%                 pop_spectopo(EEG, 1, [(time_action{1,N}(1,1))*512 time_action{1,N}(1,length(time_action{1,N}))*512], 'EEG' , 'freqrange',[2 30],'electrodes','on'); % First slider action to completion of scenario
                h4 = findobj(gca,'Type','line');
                x{N}=get(h4,'Xdata');
                y{N}=get(h4,'Ydata');
                time_action_mean{N} = floor(mean(time_action{N}));
                close all
                S_theta{N} = mean(y{1,N}(1,5:8));
                S_alpha{N} = mean(y{1,N}(1,9:13));
                S_beta{N}  = mean(y{1,N}(1,14:31));
                if length(y{1,N}) <31
                    append = mean(S_beta{N});
                    diff = 31-length(y{1,N});
                    insert = append + zeros(diff,1);
                    y{N} = [y{N}';insert]';
                end
                y_3_10seconds = reshape(cell2mat(y(1:N)),[31,N]); % Data from First slider action to finish of experiment oin 10 seconds interval
                S_theta=   cell2mat(S_theta);
                S_alpha = cell2mat(S_alpha);
                S_beta = cell2mat(S_beta);
                mean_time = cell2mat(time_action_mean);
                close all
                
                %% PSD 10 seconds windows
                diff = abs(start_scenario(4,1) - start_scenario(length(start_scenario),1));
                N = ceil(diff/10);
                time1 = start_scenario(4,1);
                time2 = 10+start_scenario(4,1);
                for i = 1:N-1
                    time{i} = ((i-1)*10)+time1+1:((i-1)*10)+time2;
                    time_mean_plotting{i} = floor(mean(cell2mat(time(i))));
                end
                time{N} = time{1,N-1}(1,length(time{1,N-1}))+1 : (start_scenario(length(start_scenario),1));
                if length(time{1,N})<3
                    
                    time{N} = time{1,N-1}(1,length(time{1,N-1}))-3 : start_scenario(length(start_scenario),1);
                else
                    time{N} = time{1,N-1}(1,length(time{1,N-1}))+1 : (start_scenario(length(start_scenario),1));
                end
                time_mean_plotting{N} = floor(mean(time{N}));
                mean_time_plotting = cell2mat(time_mean_plotting);
                
                
                %% Saving the data in excel sheet
                filename = strcat(path,'Median_Filter_0.5sec','.xlsx');
                data_PSD_rest = [y_3_10seconds_rest];
                data_PSD_tasks = [y_2' y_3' y_3_10seconds];
                sheet = m;
                xlRange = 'A';
                xlswrite(filename,data_PSD_tasks,sheet,xlRange)
                xlswrite(filename,data_PSD_rest,7,xlRange)
            end
        end
    end
end   
                
%                 %% PLOTTING THE PROCESS DATA EXPERIMENT AND SCENARIO WISE
%                 read={strcat(path,'Process_data.xlsx'),strcat('Sheet',num2str(m))}; % Reading the process data
%                 process_raw{k,m} = {xlsread(read{1},read{2})};
%                 time_process = process_raw{k,m}{1,1}(:,1);
%                 
%                 % Process Variables : ul = Upperlimit, ll = Lower limit
%                 C101_ul = 1555.6; C101_ll = 955.6; T103_ul = 33; T103_ll = 29.5;F101_ul = 950; F101_ll = 550;
%                 F102_ul = 200; F102_ll = 70;F105_ul = 993.7; F105_ll = 575.3;T104_ul = 100.5; T104_ll = 98.5;
%                 T105_ul = 89.5; T105_ll = 86.5;T106_ul = 80.4; T106_ll = 78.5;
%                 
%                 a = 'F102_low'; b = 'F101_high';c = 'T105_low'; f = 'F102_high';g = 'F101_low';
%                 N_alarms = 7;
%                 % Plot
%                 o = o+2;
%                 
%                 
%                 if sum(strcmpi(txtData1{k,m},'Automatic_Shutdown'))==1 || sum(strcmpi(txtData1{k,m},'Emergency_Shutdown'))==1
%                     color = 'r';
%                     intensity = [1,0,0];
%                 else
%                     color = 'b';
%                     intensity = [0,0,0];
%                 end
%                 
%                 %% Plotting for different frequency ranges :
%                 for range_of_freq = 1:3
%                     if range_of_freq == 1
%                         PSD = [S_theta1,S_theta2,S_theta];
%                         label = {'S^{\theta} ({\omega})';'{\mu}V^2/Hz '};
%                         wave = 'theta';
%                     elseif range_of_freq == 2
%                         PSD = [S_alpha1,S_alpha2,S_alpha];
%                         label = {'S^{\alpha} ({\omega})';'{\mu}V^2/Hz '};
%                         wave = 'alpha';
%                     else
%                         PSD = [S_beta1,S_beta2,S_beta];
%                         label = {'S^{\beta} ({\omega})';'{\mu}V^2/Hz '};
%                         wave = 'beta';
%                         %else
%                         %PSD = [S_gamma1,S_gamma2,S_gamma3,S_gamma4];
%                         %label = {'S^{\gamma} ({\omega})';'{\mu}V^2/Hz '};
%                         %wave = 'gamma';
%                         
%                     end
%                     
%                     if strcmpi(table2array(alarm_name{k,m}(1,1)),'F102_low') || strcmpi(table2array(alarm_name{k,m}(1,1)),'F102_high')
%                         
%                         % Plotting the Process parameters
%                         figure(o)
%                         subplot(3,2,[1,2])
%                         plot(time_process,process_raw{k,m}{1,1}(:,4),'b','LineWidth',1)
%                         hold on
%                         plot(time_process,F102_ul*ones(size(time_process)),'r--')
%                         hold on
%                         plot(time_process,F102_ll*ones(size(time_process)),'r--')
%                         %title('F102 v/s time')
%                         %                         xlabel('Time in Seconds')
%                         ylabel('F102')
%                         ylim([F102_ll-65 F102_ul+80])
%                         xlim([mouseclick1{k,m}(1,1)-10 time_process(length(time_process),1)+10])
%                         grid on
%                         
%                         % Plotting the PSD data
%                       subplot(3,2,[5,6])
%                         x = [(start_scenario(1,1)+ start_alarm(1,1))/2,(start_alarm(1,1) + start_scenario(4,1))/2,mean_time_plotting] ;
%                         y = PSD;
%                         scatter(x,y,30,'*',color,'MarkerFaceColor',intensity)
%                         xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                         xlabel('Time in Seconds')
%                         ylabel(label)
%                         grid on
%                         ylim([floor(min(y)-2) ceil(max(y)+2)]);
%                         
%                         %% Slider trend Plotting Coolant flow alarms
%                         subplot(3,2,[3,4])
%                         
%                         % Plotting the Slider values
%                         % SLIDER PLOT WITH PROPER MARKINGS FOR WRONG AND
%                         % RIGHT SLIDER
%                         Color = [];
%                         Markercolor = [];
%                         for i = 1:length(mouseclick1{k,m}(:,1))
%                             if strcmpi(table2array(alarm_name{k,m}(1,1)),'F102_low') && strcmpi(table2array(txtData1{k,m}(i,1)),'Slider_coolant_control')...
%                                     || strcmpi(table2array(alarm_name{k,m}(1,1)),'F102_high') && strcmpi(table2array(txtData1{k,m}(i,1)),'Slider_coolant_control')
%                                 Color{i} = 'b';
%                                 Markercolor{i} = 'blue';
%                             else
%                                 Color{i} = 'r';
%                                 Markercolor{i} = 'red';
%                             end
%                             Color = cellstr(Color(1,:));
%                             Markercolor = cellstr(Markercolor(1,:));
%                             stem(mouseclick1{k,m}(i,1),mouseclick1{k,m}(i,7),'MarkerFaceColor',cell2mat(Markercolor(1,i)),'Color','k')
%                             hold on
%                             xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                             ylim([0 1]);
%                         end
%                         hold on
%                         
%                         % Highlighting the tags pressed in the scenario and Start Point
%                         Index_time1 = find(contains(txtData1{k,m}(:,1),'F'));
%                         Index_time2 = find(contains(txtData1{k,m}(:,1),'C101'));
%                         Index_time3 = find(contains(txtData1{k,m}(:,1),'T'));
%                         Index_time = [Index_time1;Index_time2;Index_time3];
%                         time_alarm_file1 = alarm_file1{k,m}(:,1);
%                         time_mouse_click = mouseclick1{k,m}(:,1);
%                         time_tags_flow = time_mouse_click(Index_time);
%                         alarms_flow = txtData1{k,m}(Index_time,1);
%                         y = zeros(length(Index_time),1)+0.08;
%                         text(time_tags_flow,y,char(alarms_flow),'Rotation',90,'FontSize',5)
%                         hold on
%                         text(mouseclick1{k,m}(1,1),0.08,'Start','Rotation',90,'FontSize',6,'Color','g') % Noting the start location in the time range
%                         
%                         % Highlighting the alarm points by triangular symbol
%                         Index_alarm = find(contains(alarm_name1{k,m}(:,1),'F'));
%                         for i = 1:length(Index_alarm(:,1))
%                             if sum(strcmpi(alarm_name1{k,m}(i,1),'F102_low'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'F102_low'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1)+0.5;
%                                 plot(time_Tlow,y,'v','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'F102','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'F102_cleared'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'F102_cleared'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1);
%                                 plot(time_Tlow,y,'s','MarkerFaceColor','green','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'F102','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'F102_high'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'F102_high'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1) +0.50;
%                                 plot(time_Tlow,y,'^','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.05,'F102','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.05,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                             end
%                         end
%                         hold on
%                         index4 = find(strcmpi(txtData1{k,m}(:,1),'Scenario_Completed'));
%                         index5 = find(strcmpi(txtData1{k,m}(:,1),'Automatic_Shutdown'));
%                         index6 = find(strcmpi(txtData1{k,m}(:,1),'Emergency_Shutdown'));
%                         if sum(index4)>=1
%                             plot(time_mouse_click(index4),0,'s','MarkerFaceColor','green','MarkerSize',8)
%                             text(time_mouse_click(index4),0.08,'SC','Rotation',90,'FontSize',6,'Color','b')
%                         elseif sum(index5)>=1
%                             plot(time_mouse_click(index5),0,'s','MarkerFaceColor','red','MarkerSize',8)
%                             text(time_mouse_click(index5),0.08,'ASD','Rotation',90,'FontSize',6,'Color','r')
%                         else
%                             plot(time_mouse_click(index6),0,'s','MarkerFaceColor','red','MarkerSize',8)
%                             text(time_mouse_click(index6),0.08,'ESD','Rotation',90,'FontSize',6,'Color','r')
%                         end
%                         ylabel({'Slider';'Position'})
%                         hold off
%                         
%                         
%                         %% PLOTTING FOR REACTOR PARAMETER ALARMS
%                         
%                     elseif strcmpi(table2array(alarm_name{k,m}(1,1)), 'F101_high') || strcmpi(table2array(alarm_name{k,m}(1,1)),'F101_low')
%                         
%                         figure(o)
%                         subplot(5,2,[1,2])
%                         plot(time_process,process_raw{k,m}{1,1}(:,3),'b','LineWidth',1)
%                         hold on
%                         plot(time_process,F101_ul*ones(size(time_process)),'r--')
%                         hold on
%                         plot(time_process,F101_ll*ones(size(time_process)),'r--')
%                         %title('F101 v/s time')
%                         %                         xlabel('Time in Seconds')
%                         ylabel('F101')
%                         ylim([F101_ll-450 F101_ul+450])
%                         xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                         
%                         subplot(5,2,[3,4])
%                         plot(time_process,process_raw{k,m}{1,1}(:,7),'b','LineWidth',1)
%                         ylim([F105_ll-450 F105_ul+450])
%                         xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                         hold on
%                         plot(time_process,F105_ul*ones(size(time_process)),'r--')
%                         hold on
%                         plot(time_process,F105_ll*ones(size(time_process)),'r--')
%                         % title('F105 v/s time')
%                         %                         xlabel('Time in Seconds')
%                         ylabel('F105')
%                         
%                         subplot(5,2,[5,6])
%                         plot(time_process,process_raw{k,m}{1,1}(:,12),'b','LineWidth',1)
%                         ylim([C101_ll-300 C101_ul+300])
%                         xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                         hold on
%                         plot(time_process,C101_ul*ones(size(time_process)),'r--')
%                         hold on
%                         plot(time_process,C101_ll*ones(size(time_process)),'r--')
%                         % title('C101 v/s time')
%                         %                         xlabel('Time in Seconds')
%                         ylabel('C101')
%                         
%                         subplot(5,2,[9,10])
%                         x = [(start_scenario(1,1)+ start_alarm(1,1))/2,(start_alarm(1,1) + start_scenario(4,1))/2,mean_time_plotting] ;
%                         y = PSD;
%                         scatter(x,y,30,'*',color,'MarkerFaceColor',intensity)
%                         xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                         xlabel('Time in Seconds')
%                         ylabel(label)
%                         ylim([floor(min(y)-4) ceil(max(y)+4)]);
%                         
%                         %% Slider Trend Reactor and Flow line Parameters
%                         subplot(5,2,[7,8]) 
%                         % Plotting the Slider values
%                         % SLIDER PLOT WITH PROPER MARKINGS FOR WRONG AND
%                         % RIGHT SLIDER
%                         Color = [];
%                         Markercolor = [];
%                         for i = 1:length(mouseclick1{k,m}(:,1))
%                             if strcmpi(table2array(alarm_name{k,m}(1,1)),'F101_low') && strcmpi(table2array(txtData1{k,m}(i,1)),'Slider_feed_control')...
%                                     || strcmpi(table2array(alarm_name{k,m}(1,1)),'F101_high') && strcmpi(table2array(txtData1{k,m}(i,1)),'Slider_feed_control')
%                                 Color{i} = 'b';
%                                 Markercolor{i} = 'blue';
%                             else
%                                 Color{i} = 'r';
%                                 Markercolor{i} = 'red';
%                             end
%                             Color = cellstr(Color(1,:));
%                             Markercolor = cellstr(Markercolor(1,:));
%                             stem(mouseclick1{k,m}(i,1),mouseclick1{k,m}(i,7),'MarkerFaceColor',cell2mat(Markercolor(1,i)),'Color','k')
%                             hold on
%                             xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                             ylim([0 1]);
%                         end
%                         hold on
%                         
%                         % Highlighting the tags pressed in the scenario and Start Point
%                         Index_time1 = find(contains(txtData1{k,m}(:,1),'F'));
%                         Index_time2 = find(contains(txtData1{k,m}(:,1),'C101'));
%                         Index_time3 = find(contains(txtData1{k,m}(:,1),'T'));
%                         Index_time = [Index_time1;Index_time2;Index_time3];
%                         time_alarm_file1 = alarm_file1{k,m}(:,1);
%                         time_mouse_click = mouseclick1{k,m}(:,1);
%                         time_tags_reactor = time_mouse_click(Index_time);
%                         alarms_flow_reactor = txtData1{k,m}(Index_time,1);
%                         y = zeros(length(Index_time),1)+0.08;
%                         text(time_tags_reactor,y,char(alarms_flow_reactor),'Rotation',90,'FontSize',5);
%                         hold on
%                         text(mouseclick{k,m}(1,1),0.08,'Start','Rotation',90,'FontSize',6,'Color','g'); % Noting the start location in the time range
%                         
%                         % Highlighting the alarm points by triangular symbol
%                         Index_alarm1 = find(contains(alarm_name1{k,m}(:,1),'F'));
%                         Index_alarm2 = find(contains(alarm_name1{k,m}(:,1),'C'));
%                         Index_alarm = [Index_alarm1;Index_alarm2];
%                         for i = 1:length(Index_alarm(:,1))
%                             if sum(strcmpi(alarm_name1{k,m}(i,1),'F101_low'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'F101_low'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1)+0.5;
%                                 plot(time_Tlow,y,'v','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'F101','Rotation',90,'FontSize',5);
%                                 else
%                                     text(time_Tlow,y+0.05,alarm_Tlow,'Rotation',90,'FontSize',5);
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'F105_low'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'F105_low'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1);
%                                 plot(time_Tlow,y+0.5,'v','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,0.08,'F105','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'C101_low'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'C101_low'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1)+0.5;
%                                 plot(time_Tlow,y,'v','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'C101','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'F101_cleared'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'F101_cleared'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1);
%                                 plot(time_Tlow,y,'s','MarkerFaceColor','green','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'F101','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'F105_cleared'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'F105_cleared'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1);
%                                 plot(time_Tlow,y,'s','MarkerFaceColor','green','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'F105','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'C101_cleared'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'C101_cleared'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1);
%                                 plot(time_Tlow,y,'s','MarkerFaceColor','green','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'C101','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'F101_high'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'F101_high'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1) + 0.50;
%                                 plot(time_Tlow,y,'^','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'F101','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'F105_high'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'F105_high'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1);
%                                 plot(time_Tlow,y+0.5,'^','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,0.08,'F105','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             else
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'C101_high'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1)+0.5;
%                                 plot(time_Tlow,y,'^','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'C101','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             end
%                         end
%                         hold on
%                         index4 = find(strcmpi(txtData1{k,m}(:,1),'Scenario_Completed'));
%                         index5 = find(strcmpi(txtData1{k,m}(:,1),'Automatic_Shutdown'));
%                         index6 = find(strcmpi(txtData1{k,m}(:,1),'Emergency_Shutdown'));
%                         if sum(index4)>=1
%                             plot(time_mouse_click(index4),0,'s','MarkerFaceColor','green','MarkerSize',8)
%                             text(time_mouse_click(index4),0.08,'SC','Rotation',90,'FontSize',6)
%                         elseif sum(index5)>=1
%                             plot(time_mouse_click(index5),0,'s','MarkerFaceColor','red','MarkerSize',8)
%                             text(time_mouse_click(index5),0.08,'ASD','Rotation',90,'FontSize',6)
%                         else
%                             plot(time_mouse_click(index6),0,'s','MarkerFaceColor','red','MarkerSize',8)
%                             text(time_mouse_click(index6),0.08,'ESD','Rotation',90,'FontSize',6)
%                         end
%                         ylabel({'Slider';'Position'})
%                         hold off
%                         
%                         %% PLOTTING FOR DISTILLATION TEMPERATURE ALARMS
%                     else
%                         
%                         figure(o)
%                         subplot(5,2,[1,2])
%                         plot(time_process,process_raw{k,m}{1,1}(:,9),'b','LineWidth',1)
%                         ylim([T105_ll-11.5 T105_ul+11.5])
%                         xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                         hold on
%                         plot(time_process,T105_ul*ones(size(time_process)),'r--')
%                         hold on
%                         plot(time_process,T105_ll*ones(size(time_process)),'r--')
%                         %title('T105 v/s time')
%                         %                         xlabel('Time in Seconds')
%                         ylabel('T105')
%                         
%                         subplot(5,2,[3,4])
%                         plot(time_process,process_raw{k,m}{1,1}(:,8),'b','LineWidth',1)
%                         ylim([T106_ll-7.5 T106_ul+9.6])
%                         xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                         hold on
%                         plot(time_process,T106_ul*ones(size(time_process)),'r--')
%                         hold on
%                         plot(time_process,T106_ll*ones(size(time_process)),'r--')
%                         %title('T106 v/s time')
%                         %                         xlabel('Time in Seconds')
%                         ylabel('T106')
%                         
%                         subplot(5,2,[5,6])
%                         plot(time_process,process_raw{k,m}{1,1}(:,10),'b','LineWidth',1)
%                         ylim([T104_ll-19.5 T104_ul+6.5])
%                         xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                         hold on
%                         plot(time_process,T104_ul*ones(size(time_process)),'r--')
%                         hold on
%                         plot(time_process,T104_ll*ones(size(time_process)),'r--')
%                         %title('T104 v/s time')
%                         %                         xlabel('Time in Seconds')
%                         ylabel('T104')
%                         
%                         subplot(5,2,[9,10])
%                         x = [(start_scenario(1,1)+ start_alarm(1,1))/2,(start_alarm(1,1) + start_scenario(4,1))/2,mean_time_plotting] ;
%                         y = PSD;
%                         scatter(x,y,30,'*',color,'MarkerFaceColor',intensity)
%                         xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                         ylim([floor(min(y)-4) ceil(max(y)+4)]);
%                         xlabel('Time in Seconds')
%                         ylabel(label)
%                         
%                         
%                         
%                         %% SLIDER PLOTTING FOR DISTILLATION TEMPERATURES
%                         
%                         subplot(5,2,[7,8])
%                         % SLIDER PLOT WITH PROPER MARKINGS FOR WRONG AND
%                         % RIGHT SLIDER
%                         Color = [];
%                         Markercolor = [];
%                         for i = 1:length(mouseclick1{k,m}(:,1))
%                             if strcmpi(table2array(alarm_name{k,m}(1,1)),'T105_low') && strcmpi(table2array(txtData1{k,m}(i,1)),'Slider_reflux_control')...
%                                     || strcmpi(table2array(alarm_name{k,m}(1,1)),'T104_low') && strcmpi(table2array(txtData1{k,m}(i,1)),'Slider_reflux_control')
%                                 Color{i} = 'b';
%                                 Markercolor{i} = 'blue';
%                             else
%                                 Color{i} = 'r';
%                                 Markercolor{i} = 'red';
%                             end
%                             Color = cellstr(Color(1,:));
%                             Markercolor = cellstr(Markercolor(1,:));
%                             stem(mouseclick1{k,m}(i,1),mouseclick1{k,m}(i,7),'MarkerFaceColor',cell2mat(Markercolor(1,i)),'Color','k')
%                             hold on
%                             xlim([mouseclick1{k,m}(1,1)-10 mouseclick{k,m}(end,1)+10])
%                             ylim([0 1]);
%                         end
%                         hold on
%                         
%                         % Highlighting the tags pressed in the scenario and Start Point
%                         Index_time1 = find(contains(txtData1{k,m}(:,1),'F'));
%                         Index_time2 = find(contains(txtData1{k,m}(:,1),'C101'));
%                         Index_time3 = find(contains(txtData1{k,m}(:,1),'T'));
%                         Index_time = [Index_time1;Index_time2;Index_time3];
%                         time_alarm_file1 = alarm_file1{k,m}(:,1);
%                         time_mouse_click = mouseclick1{k,m}(:,1);
%                         time_tags_distillation = time_mouse_click(Index_time);
%                         alarms_flow_distillation = txtData1{k,m}(Index_time,1);
%                         y = zeros(length(Index_time),1)+0.08;
%                         text(time_tags_distillation,y,char(alarms_flow_distillation),'Rotation',90,'FontSize',5)
%                         hold on
%                         text(mouseclick1{k,m}(1,1),0.08,'Start','Rotation',90,'FontSize',6,'Color','g') % Noting the start location in the time range
%                         
%                         % Highlighting the alarm points by triangular symbol
%                         Index_alarm = find(contains(alarm_name1{k,m}(:,1),'T'));
%                         for i = 1:length(Index_alarm(:,1))
%                             if sum(strcmpi(alarm_name1{k,m}(i,1),'T104_low'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'T104_low'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1);
%                                 plot(time_Tlow,y+0.5,'v','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,0.08,'T104','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'T105_low'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'T105_low'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1)+0.5;
%                                 plot(time_Tlow,y,'v','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'T105','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'T106_low'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'T106_low'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1)+0.5;
%                                 plot(time_Tlow,y,'v','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'T106','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'T104_cleared'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'T104_cleared'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1);
%                                 plot(time_Tlow,y,'s','MarkerFaceColor','green','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'T104','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'T105_cleared'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'T105_cleared'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1);
%                                 plot(time_Tlow,y,'s','MarkerFaceColor','green','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'T105','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'T106_cleared'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'T106_cleared'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1);
%                                 plot(time_Tlow,y,'s','MarkerFaceColor','green','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'T106','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'T104_high'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'T104_high'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1);
%                                 plot(time_Tlow,y,'^','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'T104','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             elseif sum(strcmpi(alarm_name1{k,m}(i,1),'T105_high'))>=1
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'T105_high'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1)+0.5;
%                                 plot(time_Tlow,y,'^','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'T105','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             else
%                                 index = find(strcmpi(alarm_name1{k,m}(:,1),'T106_high'));
%                                 time_Tlow = time_alarm_file1(index);
%                                 alarm = alarm_name1{k,m};
%                                 alarm_T= split(alarm(index),"_");
%                                 alarm_Tlow = char(alarm_T(:,1));
%                                 y = zeros(length(index),1)+0.5;
%                                 plot(time_Tlow,y,'^','MarkerFaceColor','red','MarkerSize',7)
%                                 if length(index)==1
%                                     text(time_Tlow,y+0.08,'T106','Rotation',90,'FontSize',5)
%                                 else
%                                     text(time_Tlow,y+0.08,alarm_Tlow,'Rotation',90,'FontSize',5)
%                                 end
%                                 
%                             end
%                         end
%                         
%                         hold on
%                         index4 = find(strcmpi(txtData1{k,m}(:,1),'Scenario_Completed'));
%                         index5 = find(strcmpi(txtData1{k,m}(:,1),'Automatic_Shutdown'));
%                         index6 = find(strcmpi(txtData1{k,m}(:,1),'Emergency_Shutdown'));
%                         if sum(index4)>=1
%                             plot(time_mouse_click(index4),0,'s','MarkerFaceColor','green','MarkerSize',8)
%                             text(time_mouse_click(index4),0.08,'SC','Rotation',90,'FontSize',6,'Color','b')
%                         elseif sum(index5)>=1
%                             plot(time_mouse_click(index5),0,'s','MarkerFaceColor','red','MarkerSize',8)
%                             text(time_mouse_click(index5),0.08,'ASD','Rotation',90,'FontSize',6,'Color','r')
%                         else
%                             plot(time_mouse_click(index6),0,'s','MarkerFaceColor','red','MarkerSize',8)
%                             text(time_mouse_click(index6),0.08,'ESD','Rotation',90,'FontSize',6,'Color','r')
%                         end
%                         ylabel({'Slider';'Position'})
%                         hold off
%                     end
%                     print(figure(o),fullfile(path,['Process_',wave,'_expt_',num2str(k),'_Task_',num2str(m),'_part_',num2str(range_of_freq), '.png']),'-dpng','-r800');
%                     close all
%                 end
%             end
%         end
%     end
% end


