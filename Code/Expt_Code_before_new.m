
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
        %EEG.etc.eeglabvers = '2019.0'; % this tracks which version of EEGLAB is being used, you may ignore it
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        EEG = pop_importdata('dataformat','ascii','nbchan',1,'data',strcat(Parent_Folder,'P1.',num2str(k),'\eeg_data.txt'),'setname','applicant','srate',512,'pnts',1,'xmin',0);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off');
        EEG = eeg_checkset( EEG );
        start_scenario = eval(strcat(participant,sch,'_expt_',num2str(k),'_mouse_click',num2str(m)));
        start_alarm = eval(strcat(participant,sch,'_expt_',num2str(k),'_scenario_',num2str(m)));
        
        % Start to 1st alarm
        L = L+1;
        figure(L)
        subplot(2,2,1)
        pop_spectopo(EEG, 1, [start_scenario(1,1)*512  start_alarm(1,1)*512], 'EEG' , 'freqrange',[2 25],'electrodes','on'); % Start to Start of task
        h1 = findobj(gca,'Type','line');
        x_1=get(h1,'Xdata');
        y_1=get(h1,'Ydata');
        upper_limit_1 = max(y_1(3,:)) + (5-rem(max(y_1(3,:)),5));
        ylim([0 upper_limit_1]);
        xlabel('Frequency')
        title('Power Spectral Density(1)')
        ylabel({'S^{\omega})';'{\mu}V^2/Hz '})
        S_theta1 = mean(y_1(5:8)); S_alpha1 = mean(y_1(9:13)); S_beta1 = mean(y_1(14:21));S_gamma1 = mean(y_1(22:26));
        
        % 1ST ALARM TO fIRST SLIDER ACTION
        subplot(2,2,2)
        pop_spectopo(EEG, 1, [start_alarm(1,1)*512  start_scenario(4,1)*512], 'EEG' , 'freqrange',[2 25],'electrodes','on'); % Task to 1st slider action
        h2 = findobj(gca,'Type','line');
        x_2=get(h2,'Xdata');
        y_2=get(h2,'Ydata');
        upper_limit_2 = max(y_2(3,:)) + (5-rem(max(y_2(3,:)),5));
        ylim([0 upper_limit_2]);
        ylabel({'S^{\omega})';'{\mu}V^2/Hz '})
        xlabel('Frequency')
        title('Power Spectral Density(2)')
        S_theta2 = mean(y_2(5:8)); S_alpha2 = mean(y_2(9:13)); S_beta2 = mean(y_2(14:21));S_gamma2 = mean(y_2(22:26));
        
        
        % Slider Action to Plant coming back to normal
        subplot(2,2,3)
        pop_spectopo(EEG, 1, [start_scenario(4,1)*512  start_scenario(length(start_scenario),1)*512], 'EEG' , 'freqrange',[2 25],'electrodes','on'); % First slider action to completion of scenario
        h3 = findobj(gca,'Type','line');
        x_3=get(h3,'Xdata');
        y_3=get(h3,'Ydata');
        upper_limit_3 = max(y_3(3,:)) + (5-rem(max(y_3(3,:)),5));
        ylim([0 upper_limit_3]);
        ylabel({'S^{\omega})';'{\mu}V^2/Hz '})
        xlabel('Frequency')
        title('Power Spectral Density(3)')
        S_theta3 = mean(y_3(5:8)); S_alpha3 = mean(y_3(9:13)); S_beta3 = mean(y_3(14:21));S_gamma3 = mean(y_3(22:26));
        
        % Scenario Complete to Finish of experiment
        subplot(2,2,4)
        pop_spectopo(EEG, 1, [start_alarm(length(start_alarm),1)*512 start_scenario(length(start_scenario),1)*512], 'EEG' , 'freqrange',[2 25],'electrodes','on'); % First slider action to completion of scenario
        h4 = findobj(gca,'Type','line');
        x_4=get(h4,'Xdata');
        y_4=get(h4,'Ydata');
        upper_limit_4 = max(y_4(3,:)) + (5-rem(max(y_4(3,:)),5));
        ylim([0 upper_limit_4]);
        ylabel({'S^{\omega})';'{\mu}V^2/Hz '})
        xlabel('Frequency')
        title('Power Spectral Density(4)')
        S_theta4 = mean(y_4(5:8)); S_alpha4 = mean(y_4(9:13)); S_beta4 = mean(y_4(14:21));S_gamma4 = mean(y_4(22:26));
        print(figure(L),fullfile(path,['expt_',num2str(k),'_Task_',num2str(m),'_part_all', '.png']),'-dpng','-r700');
        
        
        
        %% Saving the data in excel sheet
        filename = strcat(path,'Experiment',num2str(k),'.xlsx');
        data_PSD = [y_1' y_2' y_3' y_4'];
        sheet = m;
        xlRange = 'A';
        xlswrite(filename,data_PSD,sheet,xlRange)
        
        %% PLOTTING THE PROCESS DATA EXPERIMENT AND SCENARIO WISE
        read={strcat(path,'Process_data.xlsx'),strcat('Sheet',num2str(m))}; % Reading the process data
        process_raw{k,m} = {xlsread(read{1},read{2})};
        
        % Process Variables : ul = Upperlimit, ll = Lower limit
        time = process_raw{k,m}{1,1}(:,1);
        C101_ul = 1555.6; C101_ll = 955.6; T103_ul = 33; T103_ll = 29.5;F101_ul = 950; F101_ll = 550;
        F102_ul = 200; F102_ll = 70;F105_ul = 993.7; F105_ll = 575.3;T104_ul = 100.5; T104_ll = 98.5;
        T105_ul = 89.5; T105_ll = 86.5;T106_ul = 80.4; T106_ll = 78.5;
        
        a = 'F102_low'; b = 'F101_high';c = 'T105_low'; f = 'F102_high';g = 'F101_low';
        N_alarms = 7;
        % Plot
        if sum(strcmpi(txtData{k,m},'Automatic_Shutdown'))==1 || sum(strcmpi(txtData{k,m},'Emergency_Shutdown'))==1
            color = 'r';
        else
            color = 'b';
        end
        
        for range_of_freq = 1:4
            if range_of_freq ==1
                PSD = [S_theta1,S_theta2,S_theta3,S_theta4];
                wave = 'theta';
            elseif range_of_freq ==2
                PSD = [S_alpha1,S_alpha2,S_alpha3,S_alpha4];
                wave = 'alpha';
            elseif
                PSD = [S_beta1,S_beta2,S_beta3,S_beta4];
                wave = 'beta';
            else
                PSD = [S_gamma1,S_gamma2,S_gamma3,S_gamma4];
                wave = 'gamma';
            end
            
            if strcmpi(table2array(alarm_name{k,m}(1,1)),'F102_low') || strcmpi(table2array(alarm_name{k,m}(1,1)),'F102_high')
                figure(o)
                subplot(2,2,[1,2])
                plot(time,process_raw{k,m}{1,1}(:,4),'b','LineWidth',3)
                ylim([F102_ll-10 F102_ul+30])
                xlim([time(1,1)-10 time(length(time),1)+10])
                hold on
                plot(time,F102_ul*ones(size(time)),'r--')
                hold on
                plot(time,F102_ll*ones(size(time)),'r--')
                title('F102 v/s time')
                xlabel('Time in Seconds')
                ylabel('F102')
                
                subplot(2,2,[3,4])
                x = [(start_scenario(1,1)+ start_alarm(1,1))/2,(start_alarm(1,1) + start_scenario(4,1))/2 ,(start_scenario(4,1)+start_alarm(length(start_alarm),1))/2,(start_alarm(length(start_alarm),1)+start_scenario(length(start_scenario),1))/2];
                y = PSD;
                scatter(x,y,100,'o',color,'MarkerFaceColor',[0,0,0])
                xlim([start_scenario(1,1) start_scenario(length(start_scenario),1)]);
                xlabel('Time in Seconds')
                ylabel({'S^{\alpha} ({\omega})';'{\mu}V^2/Hz '})
                close all
                
                
            elseif strcmpi(table2array(alarm_name{k,m}(1,1)), 'F101_high') || strcmpi(table2array(alarm_name{k,m}(1,1)),'F101_low')
                figure(o)
                subplot(4,2,[1,2])
                plot(time,process_raw{k,m}{1,1}(:,3),'b','LineWidth',3)
                ylim([F101_ll-150 F101_ul+150])
                xlim([time(1,1)-10 time(length(time),1)+10])
                hold on
                plot(time,F101_ul*ones(size(time)),'r--')
                hold on
                plot(time,F101_ll*ones(size(time)),'r--')
                title('F101 v/s time')
                xlabel('Time in Seconds')
                ylabel('F101')
                
                subplot(4,2,[3,4])
                plot(time,process_raw{k,m}{1,1}(:,7),'b','LineWidth',3)
                ylim([F105_ll-150 F105_ul+150])
                xlim([time(1,1)-10 time(length(time),1)+10])
                hold on
                plot(time,F105_ul*ones(size(time)),'r--')
                hold on
                plot(time,F105_ll*ones(size(time)),'r--')
                title('F105 v/s time')
                xlabel('Time in Seconds')
                ylabel('F105')
                
                subplot(4,2,[5,6])
                plot(time,process_raw{k,m}{1,1}(:,12),'b','LineWidth',3)
                ylim([C101_ll-150 C101_ul+150])
                xlim([time(1,1)-10 time(length(time),1)+10])
                hold on
                plot(time,C101_ul*ones(size(time)),'r--')
                hold on
                plot(time,C101_ll*ones(size(time)),'r--')
                title('C101 v/s time')
                xlabel('Time in Seconds')
                ylabel('C101')
                
                subplot(4,2,[7,8])
                x = [(start_scenario(1,1)+ start_alarm(1,1))/2,(start_alarm(1,1) + start_scenario(4,1))/2 ,(start_scenario(4,1)+start_alarm(length(start_alarm),1))/2,(start_alarm(length(start_alarm),1)+start_scenario(length(start_scenario),1))/2];
                y = PSD;
                scatter(x,y,100,'o',color,'MarkerFaceColor',[0,0,0])
                xlim([start_scenario(1,1) start_scenario(length(start_scenario),1)]);
                xlabel('Time in Seconds')
                ylabel({'S^{\alpha} ({\omega})';'{\mu}V^2/Hz '})
                
                
            else
                figure(o)
                subplot(4,2,[1,2])
                plot(time,process_raw{k,m}{1,1}(:,9),'b','LineWidth',3)
                ylim([T105_ll-11.5 T105_ul+10.5])
                xlim([time(1,1)-10 time(length(time),1)+10])
                hold on
                plot(time,T105_ul*ones(size(time)),'r--')
                hold on
                plot(time,T105_ll*ones(size(time)),'r--')
                title('T105 v/s time')
                xlabel('Time in Seconds')
                ylabel('T105')
                
                subplot(4,2,[3,4])
                plot(time,process_raw{k,m}{1,1}(:,8),'b','LineWidth',3)
                ylim([T106_ll-5 T106_ul+5])
                xlim([time(1,1)-10 time(length(time),1)+10])
                hold on
                plot(time,T106_ul*ones(size(time)),'r--')
                hold on
                plot(time,T106_ll*ones(size(time)),'r--')
                title('T106 v/s time')
                xlabel('Time in Seconds')
                ylabel('T106')
                
                subplot(4,2,[5,6])
                plot(time,process_raw{k,m}{1,1}(:,10),'b','LineWidth',3)
                ylim([T104_ll-20 T104_ul+5])
                xlim([time(1,1)-10 time(length(time),1)+10])
                hold on
                plot(time,T104_ul*ones(size(time)),'r--')
                hold on
                plot(time,T104_ll*ones(size(time)),'r--')
                title('T104 v/s time')
                xlabel('Time in Seconds')
                ylabel('T104')
                
                subplot(4,2,[7,8])
                x = [(start_scenario(1,1)+ start_alarm(1,1))/2,(start_alarm(1,1) + start_scenario(4,1))/2 ,(start_scenario(4,1)+start_alarm(length(start_alarm),1))/2,(start_alarm(length(start_alarm),1)+start_scenario(length(start_scenario),1))/2];
                y = PSD;
                scatter(x,y,100,'o',color,'MarkerFaceColor',[0,0,0])
                xlim([start_scenario(1,1) start_scenario(length(start_scenario),1)]);
                xlabel('Time in Seconds')
                ylabel({'S^{\alpha} ({\omega})';'{\mu}V^2/Hz '})
                
            end
            print(figure(o),fullfile(path,['Process_',wave,'_expt_',num2str(k),'_Task_',num2str(m),'_part_all', '.png']),'-dpng','-r700');
            close all
        end