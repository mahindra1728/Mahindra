%% Importing alarm files
for destination = 2
    clearvars -except destination
    warning('off')
    format short g
    Main_Folder = 'D:\Mahindra\EEGDATA\'
    person = {strcat('P',num2str(destination))}
    participant = char(person)
for i = 1:2
    if i == 1
        Parent_Folder=strcat(Main_Folder,participant,'\Morning\'); % Folder destination
        AllFile=dir(fullfile(Parent_Folder,'*P*')); % Subfolders starting letter
        Folder=AllFile([AllFile.isdir]); 
        fold_nms1 = extractfield(Folder,'name');
        fold_nms2 = char(fold_nms1);
    else
        Parent_Folder=strcat(Main_Folder,participant,'\Night\'); % Folder destination
        AllFile=dir(fullfile(Parent_Folder,'*P*')); % Subfolders starting letter
        Folder=AllFile([AllFile.isdir]); 
        fold_nms1 = extractfield(Folder,'name');
        fold_nms2 = char(fold_nms1);
    end

    
    alarm_file = [];
    for k=1:length(Folder)
        path= strcat(Parent_Folder,Folder(k).name,'\');
        for m=1:6
            read={strcat(path,'Alarm_timing'),strcat('Sheet',num2str(m))};
            alarm_file{k,m}=xlsread(read{1},read{2});
            p = table2array(alarm_file(k,m));
            name = strcat(participant,'_expt_',num2str(k),'_scenario_',num2str(m)); % will save in format alarm_n_scenario_m
            eval(strcat(name,'=',mat2str(p(:,1))))
        end
end

%% Importing the Mouse click files 

AllFile=dir(fullfile(Parent_Folder,'*P*')); % Subfolders in the folder, P is the starting and common letter of all subfolders
Folder=AllFile([AllFile.isdir]);
fold_nms1 = extractfield(Folder,'name');
fold_nms2 = char(fold_nms1);
mouseclick = [];
txt = [];
slider_action={};
for k=1:length(Folder)
    path= strcat(Parent_Folder,Folder(k).name,'\');
  for m=1:6
      read={strcat(path,'Mouse_click'),strcat('Sheet',num2str(m))};
      [mouseclick{k,m},txt{k,m}]=xlsread(read{1},read{2});
      q = table2array(mouseclick(k,m)); % q is a temporary variable to convert table to array
      name1 = strcat(participant,'_expt_',num2str(k),'_mouse_click',num2str(m)); % will save in format alarm_n_scenario_m
      name2 = strcat(participant,'_expt_',num2str(k),'_sliderdata_scenario_',num2str(m)); % Syntax for slider data
      name3 = strcat(participant,'_expt_',num2str(k),'_slideraction_scenario_',num2str(m));
      eval(strcat(name1,'=',mat2str(q(:,1)))); % matrix to string so that it can be used in eval function # scenario timings
      eval(strcat(name2,'=',mat2str(q(:,7)))); % ## slider values
%       eval(strcat(name3,'=',char(slider_action)))
  end
end

%% Importing the eye tracker data
EYE_time = [];
EYE_X = [];
EYE_Y = [];
for k=1:length(Folder)
    path= strcat(Parent_Folder,Folder(k).name,'\');
  for m=1
      read={strcat(path,'EYE_TRACKER.xlsx')};
      EYE_time{k,m}=readtable(read{1},'Range','Z:Z');
      EYE_X{k,m}   =readtable(read{1},'Range','AD:AD');
      EYE_Y{k,m}   =readtable(read{1},'Range','AE:AE');
      eye{k,m} = [table2array(EYE_Y{k,m}),table2array(EYE_X{k,m})];
      name1 = strcat(participant,'_expt_',num2str(k),'_XY_cordinate_',num2str(m)); % will save in format alarm_n_scenario_m
      eval(strcat(name1,'=',mat2str(eye{k,m})));
  end
end

% Noting the start point from eye tracking data " By Coordinates " 
for k=1:7
    s = {}
    p=[];
    jm =1;
    for m = 1
        eye_name = strcat('name_',num2str(k),'_',num2str(m)); % will save in format alarm_n_scenario_m
        eval(strcat(eye_name,'=',mat2str(eval(strcat(participant,'_expt_',num2str(k),'_XY_cordinate_',num2str(m))))));
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
    path= strcat(Parent_Folder,Folder(k).name,'\');
  for m=1
      read={strcat(path,'EEG_timestamp')};
      load(read{1}); % Loading the EEG_Timestamp data
      time_eeg_record{k,m} = EEG_timestamp{1,1}.Hour*3600 + EEG_timestamp{1,1}.Minute*60 + EEG_timestamp{1,1}.Second; % Time in seconds EEG started recording the data
      u = table2array(time_eeg_record(k,m));
      name = strcat(participant,'_expt_',num2str(k),'_eeg_time_',num2str(m)); % will save in format alarm_n_scenario_m
      eval(strcat(name,'=',mat2str(u(:,1))));
  end  
end

%% Importing the raw EEG data
eeg_raw = []
for k=1:length(Folder)
    path= strcat(Parent_Folder,Folder(k).name,'\');
    read={strcat(path,'data.csv')}
    eeg_raw{k,1} = {csvread(read{1})};
    v = eeg_raw{k,1}{1,1}(:,5);
    name = strcat(participant,'_expt_',num2str(k),'_eeg_raw_',num2str(1)); % will save in format alarm_n_scenario_m
    eval(strcat(name,'=',mat2str(v(:,1))));
end

%% Time Sorting and Synchronising the EEG && Eye tracking data

% Experiment
expt_start = [];
Delta_EEG = [];
experiment_start_point = [];
y=[];
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
    y = table2array(EYE_time{k,1}{1,1});% Timestamp when recording of eye tracker started 
    name = strcat('t_expt_start',num2str(k),'_',num2str(1)); % will save in format alarm_n_scenario_m
    eval(strcat(name,'=',mat2str(y))); 
    t_expt_start_ts = datetime(eval(strcat('t_expt_start',num2str(k),'_',num2str(1))),'convertfrom','posixtime', 'Format','HH:mm:ss.SSS'); % Biulding the HH:MM:SS format
    t_eyetracker_start_seconds =padconcatenation(t_eyetracker_start_seconds, t_expt_start_ts.Hour*3600 + t_expt_start_ts.Minute*60 + t_expt_start_ts.Second,1); % Time Eye tracker start recording in seconds
    
    % EEG recording start
    t_eeg_start_seconds =padconcatenation(t_eeg_start_seconds,eval(strcat(participant,'_expt_',num2str(k),'_eeg_time_1')),1); % Time in seconds of eeg when started
    
    %Click next_point
    z = EYE_time{k,1};
    experiment_start_point = eval(strcat('startexpt',num2str(k))); % Experiment 1
    z1 = experiment_start_point(1,1);
    z = table2array(z(z1,1));
    expt_start_pointtime = datetime(z,'convertfrom','posixtime', 'Format','HH:mm:ss.SSSSSS');
    t_expt_next_seconds = padconcatenation(t_expt_next_seconds,expt_start_pointtime.Hour*3600 + expt_start_pointtime.Minute*60 + expt_start_pointtime.Second,1) ;% Experiment start(Clicked) in seconds
    
    % Click_start_point
    mouse_click = eval(strcat(participant,'_expt_',num2str(k),'_mouse_click',num2str(1)))
    t_expt_start_seconds = padconcatenation(t_expt_start_seconds,t_expt_next_seconds+ mouse_click(1,1),1)
  
    % EEG time not important
    Delta_EEG_eye_tracker = padconcatenation(Delta_EEG_eye_tracker, (t_expt_next_seconds(k,1)-t_eeg_start_seconds(k,1)),1); %   EEG time which is not important

    
    % EEG data 
    end_time = eval(strcat(participant,'_expt_',num2str(k),'_','scenario_6'));
    eeg_end = Delta_EEG_eye_tracker(k,1) + end_time(length(end_time),1);
    rawdata = eval(strcat(participant,'_expt_',num2str(k),'_eeg_raw_',num2str(1)));
    eeg_data =rawdata(Delta_EEG_eye_tracker(k,1):eeg_end*512); % Actual Data of EEG
    % Saving the eeg data to desired folder
    fnm =[Parent_Folder strcat(participant,'.',num2str(k)) '\' 'eeg_data.txt'];
    fid = fopen(fnm,'wt');
    fprintf(fid,'%.2f\n',eeg_data);
    fclose(fid);
%     save('eeg_data.txt','eeg_data','-ascii')
   
end

%% EEGLAB 

% Experiment 1

% EEGLAB history file generated on the 14-Jul-2019
% ------------------------------------------------
path = [];
L = 1;
for k=1:length(Folder)
        path= strcat(Parent_Folder,participant,'.',num2str(k),'\');
    for m = 1:6
        % Start to 1st alarm
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        EEG = pop_importdata('dataformat','ascii','nbchan',1,'data',strcat(Parent_Folder,'P1.',num2str(k),'\eeg_data.txt'),'setname',participant,'srate',512,'pnts',1,'xmin',0);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
        EEG = eeg_checkset( EEG );
        start_scenario = eval(strcat(participant,'_expt_',num2str(k),'_mouse_click',num2str(m)));
        start_alarm = eval(strcat(participant,'_expt_',num2str(k),'_scenario_',num2str(m)));
        
        
        
        
        
        
        L = L+1;
        figure(L)
        pop_spectopo(EEG, 1, [start_scenario(1,1)*512  start_alarm(1,1)*512], 'EEG' , 'freqrange',[2 25],'electrodes','on'); % Start to Start of task
        print(figure(L),fullfile(path,['expt_',num2str(k),'_Task_',num2str(m),'_part_', num2str(1) '.png']),'-dpng','-r700');        
        
        
        L = L+1;
        figure(L)
        pop_spectopo(EEG, 1, [start_alarm(1,1)*512  start_scenario(4,1)*512], 'EEG' , 'freqrange',[2 25],'electrodes','on'); % Task to 1st slider action
        print(figure(L),fullfile(path,['expt_',num2str(k),'_Task_',num2str(m),'_part_', num2str(2) '.png']),'-dpng','-r700');
        
        
        L = L+1;
        figure(L)
        pop_spectopo(EEG, 1, [start(4,1)*512  start(length(start),1)*512], 'EEG' , 'freqrange',[2 25],'electrodes','on'); % First slider action to Secnario complete 
        print(figure(L),fullfile(path,['expt_',num2str(k),'_Task_',num2str(m),'_part_', num2str(3) '.png']),'-dpng','-r700');   
        close all
    end
end
end
end


%% Importing the figure data
open('1.fig')
a = get(gca,'Children');
xdata = get(a, 'XData');
ydata = get(a, 'YData');














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

