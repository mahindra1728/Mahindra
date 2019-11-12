

%% Importing alarm files
for destination = 1
    clearvars -except destination
    clc
    warning('off')
    format short g
    Main_Folder = 'G:\EEGDATA\'
    person = {strcat('P',num2str(destination))}
    participant = char(person)
    
    for i = 1:2
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
        for k=1:length(Folder)
            path=strcat(Parent_Folder,Folder(k).name,'\')
            for m=1:6
%                 [~,txtData]  = xlsread('cycling.xlsx','A1:H1')
                 read= {strcat(path,'Alarm_timing'),strcat('Sheet',num2str(m))};
                [alarm_file{k,m},txtData{k,m}]=xlsread(read{1},read{2});
                p = table2array(alarm_file(k,m));
                name = strcat(participant,sch,'_expt_',num2str(k),'_scenario_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name,'=',mat2str(p(:,1))))
            end
        end
        
        %% Importing the Mouse click files
        mouseclick = [];
        for k=1:length(Folder)
            path=strcat(Parent_Folder,Folder(k).name,'\')
            for m=1:6
                read={strcat(path,'Mouse_click'),strcat('Sheet',num2str(m))};
                [mouseclick{k,m},txt{k,m}]=xlsread(read{1},read{2});
                q = table2array(mouseclick(k,m)); % q is a temporary variable to convert table to array
                name1 = strcat(participant,sch,'_expt_',num2str(k),'_mouse_click',num2str(m)); % will save in format alarm_n_scenario_m
                name2 = strcat(participant,sch,'_expt_',num2str(k),'_sliderdata_scenario_',num2str(m)); % Syntax for slider data
                eval(strcat(name1,'=',mat2str(q(:,1)))); % matrix to string so that it can be used in eval function # scenario timings
                eval(strcat(name2,'=',mat2str(q(:,7)))); % ## slider values
            end
        end
        
        %% Importing the eye tracker data
        EYE_time = [];
        EYE_X = [];
        EYE_Y = [];
        for k=1:length(Folder)
            path=strcat(Parent_Folder,Folder(k).name,'\')
            for m=1
                read={strcat(path,'EYE_TRACKER.xlsx')};
                EYE_time{k,m}=readtable(read{1},'Range','Z:Z');
                EYE_X{k,m}   =readtable(read{1},'Range','AD:AD');
                EYE_Y{k,m}   =readtable(read{1},'Range','AE:AE');
                eye{k,m} = [table2array(EYE_Y{k,m}),table2array(EYE_X{k,m})];
                name1 = strcat(participant,sch,'_expt_',num2str(k),'_XY_cordinate_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name1,'=',mat2str(eye{k,m})));
            end
        end
        
        % Noting the start point from eye tracking data " By Coordinates "
        for k=1:length(Folder)
            s = {}
            p=[];
            jm =1;
            for m = 1
                eye_name = strcat('name_',num2str(k),'_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(eye_name,'=',mat2str(eval(strcat(participant,sch,'_expt_',num2str(k),'_XY_cordinate_',num2str(m))))));
                name = eval(strcat('name','_',num2str(k),'_',num2str(m)));
                %         name = ; % will save in format alarm_n_scenario_m
                for i=1:length(name(:,1))  % Index is length of the Eye tracker data
                    if (name(i,2) >= 900 && name(i,2) <= 1023 && name(i,1) >= 638 && name(i,1) <= 694)
                        p(i)=i;
                        jm=jm+1;
                    end
                end
            end
            s = strcat('start','expt',num2str(k));
            eval(strcat(s,'=',mat2str((find(p>0)))));
        end
        
        %% EEG Timestamp
        eeg_timestamp = []
        for k=1:length(Folder)
            path=strcat(Parent_Folder,Folder(k).name,'\');
            for m=1
                read={strcat(path,'EEG_timestamp')};
                load(read{1}); % Loading the EEG_Timestamp data
                time_eeg_record{k,m} = EEG_timestamp{1,1}.Hour*3600 + EEG_timestamp{1,1}.Minute*60 + EEG_timestamp{1,1}.Second; % Time in seconds EEG started recording the data
                u = table2array(time_eeg_record(k,m));
                name = strcat(participant,sch,'_expt_',num2str(k),'_eeg_time_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name,'=',mat2str(u(:,1))));
            end
        end
        
        %% Importing the raw EEG data
        eeg_raw = []
        for k=1:length(Folder)
            path=strcat(Parent_Folder,Folder(k).name,'\');
            read={strcat(path,'data.csv')}
            eeg_raw{k,1} = {csvread(read{1})};
            v = eeg_raw{k,1}{1,1}(:,5);
            name = strcat(participant,sch,'_expt_',num2str(k),'_eeg_raw_',num2str(1)); % will save in format alarm_n_scenario_m
            eval(strcat(name,'=',mat2str(v(:,1))));
        end
        
        
        %% Time Sorting and Synchronising the EEG && Eye tracking data
        
        % Experiment
        expt_start = [];
        Delta_EEG = [];
        experiment_start_point = [];
        y_1=[];
        k =[];
        t_eyetracker_start_seconds = [];
        t_eeg_start_seconds = [];
        t_expt_start_seconds = [];
        t_expt_next_seconds = [];
        eeg_data=[];
        mouse_click = [];
        Delta_EEG_eye_tracker = [];
        for k = 1:length(Folder)
            % Eye tracker Start
            y_1 = table2array(EYE_time{k,1}{1,1});% Timestamp when recording of eye tracker started
            name = strcat('t_expt_start',num2str(k),'_',num2str(1)); % will save in format alarm_n_scenario_m
            eval(strcat(name,'=',mat2str(y_1)));
            t_expt_start_ts = datetime(eval(strcat('t_expt_start',num2str(k),'_',num2str(1))),'convertfrom','posixtime', 'Format','HH:mm:ss.SSS'); % Biulding the HH:MM:SS format
            t_eyetracker_start_seconds =padconcatenation(t_eyetracker_start_seconds, t_expt_start_ts.Hour*3600 + t_expt_start_ts.Minute*60 + t_expt_start_ts.Second,1); % Time Eye tracker start recording in seconds
            
            % EEG recording start
            t_eeg_start_seconds =padconcatenation(t_eeg_start_seconds,eval(strcat(participant,sch,'_expt_',num2str(k),'_eeg_time_1')),1); % Time in seconds of eeg when started
            
            %Click next_point
            z = EYE_time{k,1};
            experiment_start_point = eval(strcat('startexpt',num2str(k))); % Experiment 1
            z1 = experiment_start_point(1,1);
            z = table2array(z(z1,1));
            expt_start_pointtime = datetime(z,'convertfrom','posixtime', 'Format','HH:mm:ss.SSSSSS');
            t_expt_next_seconds = padconcatenation(t_expt_next_seconds,expt_start_pointtime.Hour*3600 + expt_start_pointtime.Minute*60 + expt_start_pointtime.Second,1) ;% Experiment start(Clicked) in seconds
            
            % Click_start_point
            mouse_click = eval(strcat(participant,sch,'_expt_',num2str(k),'_mouse_click',num2str(1)));
            t_expt_start_seconds = padconcatenation(t_expt_start_seconds,(t_expt_next_seconds(k,1)+ mouse_click(1,1)),1);
            
            % EEG time not important
            Delta_EEG_eye_tracker = padconcatenation(Delta_EEG_eye_tracker, (t_expt_next_seconds(k,1)-t_eeg_start_seconds(k,1)),1); %   EEG time which is not important
            
            
            % EEG data
            end_time = eval(strcat(participant,sch,'_expt_',num2str(k),'_','scenario_6'));
            eeg_end = Delta_EEG_eye_tracker(k,1) + end_time(length(end_time),1);
            rawdata = eval(strcat(participant,sch,'_expt_',num2str(k),'_eeg_raw_',num2str(1)));
            eeg_data =rawdata(Delta_EEG_eye_tracker(k,1)*512:eeg_end*512); % Actual Data of EEG
            
            % Saving the eeg data to desired folder
            fnm =[Parent_Folder strcat(participant,'.',num2str(k)) '\' 'eeg_data.txt'];
            fid = fopen(fnm,'wt');
            fprintf(fid,'%.2f\n',eeg_data);
            fclose(fid);
            %     save('eeg_data.txt','eeg_data','-ascii')
            
        end

        %% Importing the Process Data
        
        for k=1:length(Folder)
            path=strcat(Parent_Folder,Folder(k).name,'\');
            for m = 1:6
                read={strcat(path,'Process_data.xlsx'),strcat('Sheet',num2str(m))}; % Reading the process data
                process_raw{k,m} = {xlsread(read{1},read{2})};
                
                time_variable = process_raw{k,m}{1,1}(:,1);
                name = strcat(participant,sch,'_expt_',num2str(k),'_Time_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name,'=',mat2str(time_variable(:,1))));
                
                
                Conc_variable = process_raw{k,m}{1,1}(:,12); %% Concentration of ethene CSTR
                name = strcat(participant,sch,'_expt_',num2str(k),'_C101_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name,'=',mat2str(Conc_variable(:,1))));
                C101_ul = 1555.6; C101_ll = 955.6;
                
                CSTR_temp_variable = process_raw{k,m}{1,1}(:,11); %% CSTR Temperature
                name = strcat(participant,sch,'_expt_',num2str(k),'_F102_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name,'=',mat2str(CSTR_temp_variable(:,1))));
                T103_ul = 33; T103_ll = 29.5;
                
                F101_variable = process_raw{k,m}{1,1}(:,3); %% CSTR Reactant feed flow
                name = strcat(participant,sch,'_expt_',num2str(k),'_F101_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name,'=',mat2str(F101_variable(:,1))));
                F101_ul = 950; F101_ll = 550;
                
                F102_variable = process_raw{k,m}{1,1}(:,4); %% CSTR Coolant feed
                name = strcat(participant,sch,'_expt_',num2str(k),'_F102_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name,'=',mat2str(F102_variable(:,1))));
                F102_ul = 200; F102_ll = 70;
                
                F105_variable = process_raw{k,m}{1,1}(:,7); %% Distillation feed flow
                name = strcat(participant,sch,'_expt_',num2str(k),'_F105_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name,'=',mat2str(F105_variable(:,1))));
                F105_ul = 993.7; F105_ll = 575.3;
                
                T104_variable = process_raw{k,m}{1,1}(:,10); %% Tray 3 of distillation column
                name = strcat(participant,sch,'_expt_',num2str(k),'_T104_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name,'=',mat2str(T104_variable(:,1))));
                T104_ul = 100.5; T104_ll = 98.5;
                
                T105_variable = process_raw{k,m}{1,1}(:,9); %% Tray 5 Feed tray of distillation column
                name = strcat(participant,sch,'_expt_',num2str(k),'_T105_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name,'=',mat2str(T105_variable(:,1))));
                T105_ul = 89.5; T105_ll = 86.5;
                
                T106_variable = process_raw{k,m}{1,1}(:,8); % Tray 8 distillation column
                name = strcat(participant,sch,'_expt_',num2str(k),'_T106_',num2str(m)); % will save in format alarm_n_scenario_m
                eval(strcat(name,'=',mat2str(T106_variable(:,1))));
                T106_ul = 80.4; T106_ll = 78.5;
                
                % Plotting the Process data
                
                
            end
        end
        
        
        %% EEGLAB
        % Experiment
        % EEGLAB history file generated on the 14-Jul-2019
        % ------------------------------------------------
        path = [];
        L = 1;
        for k=1:length(Folder)
            path=strcat(Parent_Folder,Folder(k).name,'\');
            for m = 1:6
                % Start to 1st alarm
                EEG.etc.eeglabvers = '2019.0'; % this tracks which version of EEGLAB is being used, you may ignore it
                [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
                EEG = pop_importdata('dataformat','ascii','nbchan',1,'data',strcat(Parent_Folder,'P1.',num2str(k),'\eeg_data.txt'),'setname','applicant','srate',512,'pnts',1,'xmin',0);
                [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off');
                EEG = eeg_checkset( EEG );
                start_scenario = eval(strcat(participant,sch,'_expt_',num2str(k),'_mouse_click',num2str(m)));
                start_alarm = eval(strcat(participant,sch,'_expt_',num2str(k),'_scenario_',num2str(m)));
                
                % Start to 1st alarm
                L = L+1;
                figure(L)
                subplot(3,2,1)
                pop_spectopo(EEG, 1, [start_scenario(1,1)*512  start_alarm(1,1)*512], 'EEG' , 'freqrange',[2 25],'electrodes','on'); % Start to Start of task
                h1 = findobj(gca,'Type','line');
                x_1=get(h1,'Xdata');
                y_1=get(h1,'Ydata');
                ylabel('PSD')
                %title('Start to 1st alarm')
                xlabel('Frequency')
                S_theta1 = mean(y_1(5:8)); S_alpha1 = mean(y_1(9:13)); S_beta1 = mean(y_1(14:21));S_gamma1 = mean(y_1(22:26));
                %print(figure(L),fullfile(path,['expt_',num2str(k),'_Task_',num2str(m),'_part_', num2str(1) '.png']),'-dpng','-r700');
                
                % 1ST ALARM TO fIRST SLIDER ACTION
                subplot(3,2,2)
                pop_spectopo(EEG, 1, [start_alarm(1,1)*512  start_scenario(4,1)*512], 'EEG' , 'freqrange',[2 25],'electrodes','on'); % Task to 1st slider action
                %print(figure(L),fullfile(path,['expt_',num2str(k),'_Task_',num2str(m),'_part_', num2str(2) '.png']),'-dpng','-r700');
                ylabel('PSD')
                %title('Alarm to 1st Slider Action')
                xlabel('Frequency')
                h2 = findobj(gca,'Type','line');
                x_2=get(h2,'Xdata');
                y_2=get(h2,'Ydata');
                S_theta2 = mean(y_2(5:8)); S_alpha2 = mean(y_2(9:13)); S_beta2 = mean(y_2(14:21));S_gamma2 = mean(y_2(22:26));                
 
                % Slider Action to Plant coming back to normal
                subplot(3,2,3)
                pop_spectopo(EEG, 1, [start_scenario(4,1)*512  start_scenario(length(start_scenario),1)*512], 'EEG' , 'freqrange',[2 25],'electrodes','on'); % First slider action to completion of scenario
                %print(figure(L),fullfile(path,['expt_',num2str(k),'_Task_',num2str(m),'_part_', num2str(3) '.png']),'-dpng','-r700');
                ylabel('PSD')
                %title('1st Slider Action to clearence of alarm : Action Phase')
                xlabel('Frequency')                
                h3 = findobj(gca,'Type','line');
                x_3=get(h3,'Xdata');
                y_3=get(h3,'Ydata');
                S_theta3 = mean(y_3(5:8)); S_alpha3 = mean(y_3(9:13)); S_beta3 = mean(y_3(14:21));S_gamma3 = mean(y_3(22:26));

                % Scenario Complete to Finish of experiment
                subplot(3,2,4)
                pop_spectopo(EEG, 1, [start_alarm(length(start_alarm),1)*512  start_scenario(length(start_scenario),1)*512], 'EEG' , 'freqrange',[2 25],'electrodes','on'); % First slider action to completion of scenario
                h4 = findobj(gca,'Type','line');
                x_4=get(h4,'Xdata');
                y_4=get(h4,'Ydata');
                ylabel('PSD')
                %title('Alarm Clearence to Stabalize the process ')
                xlabel('Frequency')
                S_theta4 = mean(y_4(5:8)); S_alpha4 = mean(y_4(9:13)); S_beta4 = mean(y_4(14:21));S_gamma4 = mean(y_4(22:26));
                
                subplot(3,2,[5,6])
                x = [(start_scenario(1,1)+ start_alarm(1,1))/2,(start_alarm(1,1) + start_scenario(4,1))/2 ,(start_scenario(4,1)+start_alarm(length(start_alarm),1))/2,(start_alarm(length(start_alarm),1)+start_scenario(length(start_scenario),1))/2];
                y = [ S_theta1,S_theta2,S_theta3,S_theta4];
                scatter(x,y,100,'o','k','MarkerFaceColor',[0,0,0])
                xlim = [start_scenario:start_scenario(length(start_scenario),1)];
                range = strcat('Expt_',num2str(k),'_scenario_',num2str(m),'1_4');
                xlabel('Time in Seconds')
                ylabel('PSD')
                %title(strcat('Spectral Power Change in theta',range));
                print(figure(L),fullfile(path,['expt_',num2str(k),'_Task_',num2str(m),'_part_all', '.png']),'-dpng','-r700');
                close all     
                
%% Saving the data in excel sheet
                filename = strcat(path,'Experiment',num2str(k),'.xlsx');
                data_PSD = [y_1' y_2' y_3' y_4'];
                sheet = m;
                xlRange = 'A'
                xlswrite(filename,data_PSD,sheet,xlRange)
                
            end
        end
    end
end






% % Saving the Spectral data to csv file
%                 R=max([length(x_1) length(S_1) length(S_theta1) length(S_alpha1) length(S_beta1) length(S_gamma1)...
%                     length(x_2) length(S_2) length(S_theta2) length(S_alpha2) length(S_beta2) length(S_gamma2)...
%                     length(x_3) length(S_3) length(S_theta3) length(S_alpha3) length(S_beta3) length(S_gamma3)...
%                     length(x_3) length(S_3) length(S_theta3) length(S_alpha3) length(S_beta3) length(S_gamma3)...]);                 D=[[A;nan(R-a,2)] [B;nan(R-b,2)] [C;nan(R-c,2)]];  % build total array
%                 D=cellstr(num2str([[A;nan(R-a,2)] [B;nan(R-b,2)] [C;nan(R-c,2)]]));                             % turn to cell string for
%                 D=char(strrep(D,'NaN','   '));                     % replacement/back to char
%                 fid=fopen('out.txt','w');                          % ready to write to file
%                 for i=1:R                                          % by record
%                     fnm =[Parent_Folder strcat(participant,'.',num2str(k)) '\' 'eeg_data.txt'];
%                     fid = fopen(fnm,'wt');
%                     fprintf(fid,'%s\n',D(i,:));                       
%                     fclose(fid);                                           % string follow by \n
%                 end
%                 fid=fclose(fid);
%                 
%                 fnm =[Parent_Folder strcat(participant,'.',num2str(k)) '\' 'eeg_data.txt'];
%                 fid = fopen(fnm,'wt');
%                 fprintf(fid,'%.2f\n',eeg_data);
%                 fclose(fid);
%                 

% %% PROCESS DATA
%
% %% 1. REACTOR PLOT
%
% %% CSTR FEED FLOW RATE F101 and SLIDER Action
% time = Process(:,1);
% F101 = Process(:,3);
% figure(19)
% subplot(3,1,1)
% plot(time,F101)
% hold on
% F101=950;
% plot(time,F101*ones(size(time)),'r--')
% hold on
% F101 = 550;
% plot(time,F101*ones(size(time)),'r--')
% hold off
% xlabel('Process Time');
% ylabel('F101')
% title('CSTR FEED FLOW RATE(F101)')
%
% % SLIDER V102 Action
% S_V102 = Process(:,14);
% subplot(3,1,2)
% plot(time,S_V102);
% xlabel('TIME');
% ylabel('SLIDER V102')
% title('SLIDER(V102 - CSTR FEEDLINE VALVE) MOVEMENT ')
% ylim([0 2])
%
% % SLIDER V201
% S_V201 = Process(:,16);
% subplot(3,1,3)
% plot(time,S_V201)
% xlabel('TIME')
% ylabel('SLIDER V201')
% title('SLIDER (V201 - CSTR PRODUCT LINE VALVE/DISTILLATION INPUT)')
% ylim([0 2])
%
% %% CSTR COOLANT FLOW RATE :F102 and Slider Action
% F102 = Process(:,4);
% figure(20)
% subplot(2,1,1)
% plot(time,F102)
% hold on
% F102=200;
% plot(time,F102*ones(size(time)),'r--')
% hold on
% F102 =70;
% plot(time,F102*ones(size(time)),'r--')
% hold off
% xlabel('Process Time');
% ylabel('F102')
% title('CSTR COOLANT FLOW RATE(F102)')
%
% % SLIDER V301(COOLANT LINE VALVE) MOVEMENT
% S_V301 = Process(:,15);
% subplot(2,1,2)
% plot(time,S_V301)
% xlabel('TIME')
% ylabel('SLIDER V301')
% title('SLIDER (V301-COOLANT FLOW VALVE) ACTION')
% ylim([0 2])
%
% %% DISTILLATION FEED FLOW RATE:F105
% F105 = Process(:,7);
% figure(21)
% subplot(3,1,1)
% plot(time,F105)
% hold on
% F105=993.7;
% plot(time,F105*ones(size(time)),'r--')
% hold on
% F105 = 575.3;
% plot(time,F105*ones(size(time)),'r--')
% hold off
% xlabel('Process Time');
% ylabel('F105')
% title('DISTILLATION FEED FLOW RATE(F105)')
%
% % V201 SLIDER ACTION VALVE
% subplot(3,1,2)
% plot(time,S_V201)
% xlabel('TIME')
% ylabel('SLIDER V201')
% title('SLIDER (V201 - CSTR PRODUCT LINE VALVE/DISTILLATION INPUT)')
% ylim([0 2])
%
%
% % SLIDER V401 ACTION
% S_V401 = Process(:,17);
% subplot(3,1,3)
% plot(time,S_V401)
% xlabel('TIME')
% ylabel('SLIDER V401')
% title('SLIDER V401 -CONDENSOR FLOW')
% ylim([0 2])
%
%
% %% CSTR CONCENTRATION C101
% C101 = Process(:,12);
% figure(22)
% subplot(4,1,1)
% plot(time,C101)
% hold on
% C101=1555.6;
% plot(time,C101*ones(size(time)),'r--')
% hold on
% C101 = 955.6;
% plot(time,C101*ones(size(time)),'r--')
% hold off
% xlabel('Process Time');
% ylabel('C101')
% title('CSTR CONCENTRATION(C101)')
%
% subplot(4,1,2)
% plot(time,S_V102);
% xlabel('TIME');
% ylabel('SLIDER V102')
% title('SLIDER(V102 - CSTR FEEDLINE VALVE) MOVEMENT ')
% ylim([0 2])
%
% subplot(4,1,3)
% plot(time,S_V301)
% xlabel('TIME')
% ylabel('SLIDER V301')
% title('SLIDER (V301-COOLANT FLOW VALVE) ACTION')
% ylim([0 2])
%
% subplot(4,1,4)
% plot(time,S_V201)
% xlabel('TIME')
% ylabel('SLIDER V201')
% title('SLIDER (V201 - CSTR PRODUCT LINE VALVE/DISTILLATION INPUT)')
% ylim([0 2])
%
%
% %% TEMPERATURE REACTOR T103
% T103 = Process(:,11);
% figure(23)
% subplot(3,1,1)
% plot(time,T103)
% hold on
% T103=33;
% plot(time,T103*ones(size(time)),'r--')
% hold on
% T103 = 29.5;
% plot(time,T103*ones(size(time)),'r--')
% hold off
% xlabel('Process Time');
% ylabel('T103')
% title('REACTOR TEMPERATURE(T103)')
%
% subplot(3,1,2)
% plot(time,S_V301)
% xlabel('TIME')
% ylabel('SLIDER V301')
% title('SLIDER (V301-COOLANT FLOW VALVE) ACTION')
% ylim([0 2])
%
% subplot(3,1,3)
% plot(time,S_V102)
% xlabel('TIME');
% ylabel('SLIDER V102')
% title('SLIDER(V102 - CSTR FEEDLINE VALVE) MOVEMENT ')
% ylim([0 2])
%
%
% %% DISTILLATION PLOT
%
% % DISTILLATION FEED FLOW RATE:F105
% % F105 = Process(:,7);
% % figure(24)
% % plot(time,F105)
% % hold on
% % F105=993.7;
% % plot(time,F105*ones(size(time)),'r--')
% % hold on
% % F105 = 575.3;
% % plot(time,F105*ones(size(time)),'r--')
% % hold off
% % xlabel('Process Time');
% % ylabel('F105')
%
% % TEMPERATURE TRAY 3 DISTILLATION COLUMN
% T104 = Process(:,10);
% figure(25)
% subplot(3,1,1)
% plot(time,T104)
% hold on
% T104=100.5;
% plot(time,T104*ones(size(time)),'r--')
% hold on
% T104 = 98.5;
% plot(time,T104*ones(size(time)),'r--')
% hold off
% xlabel('Process Time');
% ylabel('T104')
% title('TEMPERATURE(T104) TRAY 3 DISTILLATION COLUMN')
%
%
% subplot(3,1,2)
% plot(time,S_V201)
% xlabel('TIME')
% ylabel('SLIDER V201')
% title('SLIDER (V201 - CSTR PRODUCT LINE VALVE/DISTILLATION INPUT)')
% ylim([0 2])
%
% subplot(3,1,3)
% plot(time,S_V401)
% xlabel('TIME')
% ylabel('SLIDER V401')
% title('SLIDER V401 -CONDENSOR FLOW')
% ylim([0 2])
%
%
% %% TEMPERATURE TRAY 5 DISTILLATION COLUMN
% T105 = Process(:,9);
% figure(26)
% subplot(3,1,1)
% plot(time,T105)
% hold on
% T105=89.5;
% plot(time,T105*ones(size(time)),'r--')
% hold on
% T105 =86.5;
% plot(time,T105*ones(size(time)),'r--')
% hold off
% xlabel('Process Time');
% ylabel('T105')
% title('TEMPERATURE(T105) TRAY 5 DISTILLATION COLUMN')
%
% subplot(3,1,2)
% plot(time,S_V201)
% xlabel('TIME')
% ylabel('SLIDER V201')
% title('SLIDER (V201 - CSTR PRODUCT LINE VALVE/DISTILLATION INPUT)')
% ylim([0 2])
%
% subplot(3,1,3)
% plot(time,S_V401)
% xlabel('TIME')
% ylabel('SLIDER V401')
% title('SLIDER V401 -CONDENSOR FLOW')
% ylim([0 2])
%
% % TEMPERATURE TRAY 8 DISTILLATION COLUMN
% T106 = Process(:,8);
% figure(27)
% subplot(3,1,1)
% plot(time,T106)
% hold on
% T106=80.4;
% plot(time,T106*ones(size(time)),'r--')
% hold on
% T106 =78.5;
% plot(time,T106*ones(size(time)),'r--')
% hold off
% xlabel('Process Time');
% ylabel('T106')
% title('TEMPERATURE(T106) TRAY 8 DISTILLATION COLUMN')
%
% subplot(3,1,2)
% plot(time,S_V201)
% xlabel('TIME')
% ylabel('SLIDER V201')
% title('SLIDER (V201 - CSTR PRODUCT LINE VALVE/DISTILLATION INPUT)')
% ylim([0 2])
%
% subplot(3,1,3)
% plot(time,S_V401)
% xlabel('TIME')
% ylabel('SLIDER V401')
% title('SLIDER V401 -CONDENSOR FLOW')
% ylim([0 2])













% EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
% EEG = pop_importdata('dataformat','ascii','nbchan',1,'data','G:\EEGDATA\Altesham\Morning\P1.1','setname','P1.1','srate',512,'pnts',[0 512] ,'xmin',0);
% EEG = eeg_checkset( EEG );
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_loadset('filename','EEGLAB_P1.1.set','filepath','G:\EEGDATA\Altesham\Morning\P1.1');
% [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% EEG = eeg_checkset( EEG );
%pop_prop( EEG, 1, 1, NaN, {'freqrange' [2 10] });
% EEG = eeg_checkset( EEG );
% %pop_eegplot( EEG, 1, 1, 1);
% EEG = eeg_checkset( EEG );
% % pop_saveh( EEG.history, 'new.m', 'H:\Thesis\Matlab Code for Mahindra-Aatif Experiment\DATASET\simulation exp 30 may onwards\EEG DATA\Morning\ahtesham\');
% eeglab redraw;
%
% % Experiment 2
% EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
% EEG = pop_importdata('dataformat','ascii','nbchan',1,'data','G:\EEGDATA\Altesham\Morning\P1.2','setname','P1.2','srate',512,'pnts',[0 512] ,'xmin',0);
% EEG = eeg_checkset( EEG );
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_loadset('filename','EEGLAB_P1.2.set','filepath','G:\EEGDATA\Altesham\Morning\P1.2');
% [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% EEG = eeg_checkset( EEG );
% %pop_prop( EEG, 1, 1, NaN, {'freqrange' [2 10] });
% EEG = eeg_checkset( EEG );
% %pop_eegplot( EEG, 1, 1, 1);
% EEG = eeg_checkset( EEG );
% % pop_saveh( EEG.history, 'new.m', 'H:\Thesis\Matlab Code for Mahindra-Aatif Experiment\DATASET\simulation exp 30 may onwards\EEG DATA\Morning\ahtesham\');
% eeglab redraw;
%
% % Experiment 3
% EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
% EEG = pop_importdata('dataformat','ascii','nbchan',1,'data','G:\EEGDATA\Altesham\Morning\P1.3','setname','P1.3','srate',512,'pnts',[0 512] ,'xmin',0);
% EEG = eeg_checkset( EEG );
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_loadset('filename','EEGLAB_P1.3.set','filepath','G:\EEGDATA\Altesham\Morning\P1.3');
% [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% EEG = eeg_checkset( EEG );
% %pop_prop( EEG, 1, 1, NaN, {'freqrange' [2 10] });
% EEG = eeg_checkset( EEG );
% %pop_eegplot( EEG, 1, 1, 1);
% EEG = eeg_checkset( EEG );
% % pop_saveh( EEG.history, 'new.m', 'H:\Thesis\Matlab Code for Mahindra-Aatif Experiment\DATASET\simulation exp 30 may onwards\EEG DATA\Morning\ahtesham\');
% eeglab redraw;
%
% % Experiment 4
% EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
% EEG = pop_importdata('dataformat','ascii','nbchan',1,'data','G:\EEGDATA\Altesham\Morning\P1.4','setname','P1.4','srate',512,'pnts',[0 512] ,'xmin',0);
% EEG = eeg_checkset( EEG );
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_loadset('filename','EEGLAB_P1.4.set','filepath','G:\EEGDATA\Altesham\Morning\P1.4');
% [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% EEG = eeg_checkset( EEG );
% %pop_prop( EEG, 1, 1, NaN, {'freqrange' [2 10] });
% EEG = eeg_checkset( EEG );
% %pop_eegplot( EEG, 1, 1, 1);
% EEG = eeg_checkset( EEG );
% % pop_saveh( EEG.history, 'new.m', 'H:\Thesis\Matlab Code for Mahindra-Aatif Experiment\DATASET\simulation exp 30 may onwards\EEG DATA\Morning\ahtesham\');
% eeglab redraw;
%
% % Experiment 5
% EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
% EEG = pop_importdata('dataformat','ascii','nbchan',1,'data','G:\EEGDATA\Altesham\Morning\P1.5','setname','P1.5','srate',512,'pnts',[0 512] ,'xmin',0);
% EEG = eeg_checkset( EEG );
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_loadset('filename','EEGLAB_P1.5.set','filepath','G:\EEGDATA\Altesham\Morning\P1.5');
% [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% EEG = eeg_checkset( EEG );
% %pop_prop( EEG, 1, 1, NaN, {'freqrange' [2 10] });
% EEG = eeg_checkset( EEG );
% %pop_eegplot( EEG, 1, 1, 1);
% EEG = eeg_checkset( EEG );
% % pop_saveh( EEG.history, 'new.m', 'H:\Thesis\Matlab Code for Mahindra-Aatif Experiment\DATASET\simulation exp 30 may onwards\EEG DATA\Morning\ahtesham\');
% eeglab redraw;
%
% % Experiment 6
% EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
% EEG = pop_importdata('dataformat','ascii','nbchan',1,'data','G:\EEGDATA\Altesham\Morning\P1.6','setname','P1.6','srate',512,'pnts',[0 512] ,'xmin',0);
% EEG = eeg_checkset( EEG );
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_loadset('filename','EEGLAB_P1.6.set','filepath','G:\EEGDATA\Altesham\Morning\P1.6');
% [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% EEG = eeg_checkset( EEG );
% %pop_prop( EEG, 1, 1, NaN, {'freqrange' [2 10] });
% EEG = eeg_checkset( EEG );
% %pop_eegplot( EEG, 1, 1, 1);
% EEG = eeg_checkset( EEG );
% % pop_saveh( EEG.history, 'new.m', 'H:\Thesis\Matlab Code for Mahindra-Aatif Experiment\DATASET\simulation exp 30 may onwards\EEG DATA\Morning\ahtesham\');
% eeglab redraw;
%
% % Experiment 7
% EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
% EEG = pop_importdata('dataformat','ascii','nbchan',1,'data','G:\EEGDATA\Altesham\Morning\P1.7','setname','P1.7','srate',512,'pnts',[0 512] ,'xmin',0);
% EEG = eeg_checkset( EEG );
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% EEG = pop_loadset('filename','EEGLAB_P1.7.set','filepath','G:\EEGDATA\Altesham\Morning\P1.7');
% [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
% EEG = eeg_checkset( EEG );
% %pop_prop( EEG, 1, 1, NaN, {'freqrange' [2 10] });
% EEG = eeg_checkset( EEG );
% %pop_eegplot( EEG, 1, 1, 1);
% EEG = eeg_checkset( EEG );
% % pop_saveh( EEG.history, 'new.m', 'H:\Thesis\Matlab Code for Mahindra-Aatif Experiment\DATASET\simulation exp 30 may onwards\EEG DATA\Morning\ahtesham\');
% eeglab redraw;
%
%
% %% For loop
% % task =[]
% % for i = 1:7
% %     for j =1:6
% %           task1 = cell2mat(mouseclick(i,j));
% %           task{i,j} = {task , task1}
% %     end
% % end
% %         task_2_1 = cell2mat(mouseclick(2,1));
% %         task_3_1 = cell2mat(mouseclick(3,1));
% %         task_4_1 = cell2mat(mouseclick(4,1));
% %         task_5_1 = cell2mat(mouseclick(5,1));
% %         task_6_1 = cell2mat(mouseclick(6,1));
% %         task_7_1 = cell2mat(mouseclick(7,1));
%
% % alarm_i_j = cell2mat(alarm_file(1,1));
% % alarm_2_1 = cell2mat(alarm_file(2,1));
% % alarm_3_1 = cell2mat(alarm_file(3,1));
% % alarm_4_1 = cell2mat(alarm_file(4,1));
% % alarm_5_1 = cell2mat(alarm_file(5,1));
% % alarm_6_1 = cell2mat(alarm_file(6,1));
% % alarm_7_1 = cell2mat(alarm_file(7,1));
%
%
% %% DELTA FREQUENCY Scenario 1-6
% for i = 1:6
%     genvarname('task', num2str(i));
%     eval(['task', num2str(i) '=task' num2str(i)])
% end
%     EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
%     EEG = pop_importdata('dataformat','ascii','nbchan',1,'data','H:\\Thesis\\Matlab Code for Mahindra-Aatif Experiment\\DATASET\\simulation exp 30 may onwards\\EEG DATA\\Morning\\ahtesham\\eeg_data.txt','setname','Ahtesham','srate',512,'pnts',[0 512] ,'xmin',0);
%     EEG = eeg_checkset( EEG );
%     figure(1)
%     pop_spectopo(EEG, 1, [task1(1,1)*512  task1(length(task1),1)*512], 'EEG' , 'freqrange',[1 3],'electrodes','on');
%     title('Delta Frequency _ TASK 1')
%     figure(2)
%     pop_spectopo(EEG, 1, [task2(1,1)*512  task2(length(task2),1)*512], 'EEG' , 'freqrange',[1 3],'electrodes','on');
%     title('Delta Frequency _ TASK 2')
%     figure(3)
%     pop_spectopo(EEG, 1, [task3(1,1)*512  task3(length(task3),1)*512], 'EEG' , 'freqrange',[1 3],'electrodes','on');
%     title('Delta Frequency _ TASK 3')
%     figure(4)
%     pop_spectopo(EEG, 1, [task4(1,1)*512  task4(length(task4),1)*512], 'EEG' , 'freqrange',[1 3],'electrodes','on');
%     title('Delta Frequency _ TASK 4')
%     figure(5)
%     pop_spectopo(EEG, 1, [task5(1,1)*512  task5(length(task5),1)*512], 'EEG' , 'freqrange',[1 3],'electrodes','on');
%     title('Delta Frequency _ TASK 5')
%     figure(6)
%     pop_spectopo(EEG, 1, [task6(1,1)*512  task6(length(task6),1)*512], 'EEG' , 'freqrange',[1 3],'electrodes','on');
%     title('Delta Frequency _ TASK 6')

% %% THETA FREQUENCY TASK 1-6
%     EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
%     EEG = pop_importdata('dataformat','ascii','nbchan',1,'data','H:\\Thesis\\Matlab Code for Mahindra-Aatif Experiment\\DATASET\\simulation exp 30 may onwards\\EEG DATA\\Morning\\ahtesham\\eeg_data.txt','setname','Ahtesham','srate',512,'pnts',[0 512] ,'xmin',0);
%     EEG = eeg_checkset( EEG );
%     figure(7)
%     pop_spectopo(EEG, 1, [task1(1,1)*512  task1(length(task1),1)*512], 'EEG' , 'freqrange',[2 30],'electrodes','on');
%     title('THETA FREQUENCY _ TASK 1')
%     figure(8)
%     pop_spectopo(EEG, 1, [task2(1,1)*512  task2(length(task2),1)*512], 'EEG' , 'freqrange',[2 30],'electrodes','on');
%     title('THETA FREQUENCY _ TASK 2')
%     figure(9)
%     pop_spectopo(EEG, 1, [task3(1,1)*512  task3(length(task3),1)*512], 'EEG' , 'freqrange',[2 30],'electrodes','on');
%     title('THETA FREQUENCY _ TASK 3')
%     figure(10)
%     pop_spectopo(EEG, 1, [task4(1,1)*512  task4(length(task4),1)*512], 'EEG' , 'freqrange',[2 30],'electrodes','on');
%     title('THETA FREQUENCY _ TASK 4')
%     figure(11)
%     pop_spectopo(EEG, 1, [task5(1,1)*512  task5(length(task5),1)*512], 'EEG' , 'freqrange',[2 30],'electrodes','on');
%     title('THETA FREQUENCY _ TASK 5')
%     figure(12)
%     pop_spectopo(EEG, 1, [task6(1,1)*512  task6(length(task6),1)*512], 'EEG' , 'freqrange',[2 30],'electrodes','on');
%     title('THETA FREQUENCY _ TASK 6')
%
% %% Theta task 1 subtasks
% EEG.etc.eeglabvers = '14.1.2'; % this tracks which version of EEGLAB is being used, you may ignore it
%     EEG = pop_importdata('dataformat','ascii','nbchan',1,'data','H:\\Thesis\\Matlab Code for Mahindra-Aatif Experiment\\DATASET\\simulation exp 30 may onwards\\EEG DATA\\Morning\\ahtesham\\eeg_data.txt','setname','Ahtesham','srate',512,'pnts',[0 512] ,'xmin',0);
%     EEG = eeg_checkset( EEG );
%     figure(31)
%     pop_spectopo(EEG, 1, [task_1_1(1,1)*512  alarm_1_1(1,1)*512], 'EEG' , 'freqrange',[2 30],'electrodes','on');
%     title('THETA FREQUENCY _ TASK 1_ Start to 1st alarm')
%     figure(32)
%     pop_spectopo(EEG, 1, [alarm_1_1(1,1)*512  task_1_1(4,1)*512], 'EEG' , 'freqrange',[2 30],'electrodes','on');
%     title('THETA FREQUENCY _ TASK 1_ Alarm to 1st slider action')
%     figure(33)
%     pop_spectopo(EEG, 1, [task1(4,1)*512  alarm_1_1(length(alarm1),1)*512], 'EEG' , 'freqrange',[2 30],'electrodes','on');
%     title('THETA FREQUENCY _ TASK 1_ Action Phase')

%% Code for saving data in various variables
% t = 6;
% no_of_tasks = 6;
% no_of_experiments = length(alarm_file(:,1));
% e = no_of_experiments;
%
% for k=1:e
%     for m = 1:t
%         p = table2array(alarm_file(k,m));
%         name = strcat('P1_expt_',num2str(k),'_scenario_',num2str(m)); % will save in format alarm_n_scenario_m
%         eval(strcat(name,'=',mat2str(p(:,1))));
%     end
% end

% N = 10;          % number of variables
% %method 1
% for k=1:N
%     temp_var = strcat( 'variable_',num2str(k) );
%     eval(sprintf('%s = %g',temp_var,k*2));
% end
% % method 2, more advisable
% for k=1:N
%     my_field = strcat('v',num2str(k));
%     variable.(my_field) = k*2;
% end

%% To avoid aval answers
% temp1 = strcat('name_1_',num2str(1))
% eval('ab1 = temp1')
% eval('ab1 = eval(temp1)')
% eval('ab1 = eval(temp1);')

%%


% t_eye_start = eye_tracker_timestamp1(1,1)% Timestamp when eye tracking started the recording
% t_eye_start_ts = datetime(t_eye_start,'InputFormat','HH:mm:ss.SSS');
% t_eye_start_seconds = t_eye_start_ts.Hour*3600 + t_eye_start_ts.Minutes*60 + t_eye_start_ts.Seconds % Time of eye tracker start in seconds

% t_expt_start = eye_tracker_timestamp1(s(1,1),1)% Timestamp when experiment started
% t_expt_start_ts = datetime(t_expt_start,'InputFormat','HH:mm:ss:SSS') % Biulding the HH:MM:SS format
% t_expt_start_seconds = t_expt_start_ts.Hour*3600 + t_expt_start_ts.Minutes*60 + t_expt_start_ts.Seconds

%t = table2array(eye_tracker_timestamp1(s(1),1)); % Time stamp of eye tracking data
%t_eeg_start=time_eeg_record(1,1); % Local time when eeg started in seconds
%timestamp_eyetrack_FTE = datetime(t_exp_start,'InputFormat','HH:mm:ss.SSS'); % Local time when eye tracking task started
%time_start_experiment = timestamp_eyetrack_FTE.Hour*3600 + timestamp_eyetrack_FTE.Minute*60 + timestamp_eyetrack_FTE.Second; % Time in seconds Eye tracker spotted experiment start

% Deltat_EEG = abs(t_eye_start_seconds-t_eeg_start); %   EEG time which is not important

%eeg_start_exp = 512*Deltat_EEG;  %  Point till which EEG data is not important EEG experiment start
% end_time = scenario_end + Deltat_EEG; % Total experiment time
% eeg_data = raw_data(eeg_start_exp:end_time*512,5); % Actual Data of EEG
% save('eeg_data.txt','eeg_data','-ascii')
% filtered = medfilt1(eeg_data);
% p=plot([eeg_data filtered]);
% title('EEG Signal')
% fs = 512;
% b = eeg_data;
% save('eeg_data.txt','b','-ascii');
% type('eeg_data.txt');

