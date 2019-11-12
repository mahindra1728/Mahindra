% EEGLAB history file generated on the 22-Jul-2019
% ------------------------------------------------
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_importdata('dataformat','ascii','nbchan',1,'data',strcat(Parent_Folder,'P1.',num2str(k),'\eeg_data.txt','setname','applicant','srate',512,'pnts',1,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off'); 
EEG = eeg_checkset( EEG );
figure; pop_spectopo(EEG, 1, [14000  38000], 'EEG' , 'freqrange',[2 25],'electrodes','off');
eeglab redraw;



EEG.etc.eeglabvers = '2019.0'; % this tracks which version of EEGLAB is being used, you may ignore it
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
EEG = pop_importdata('dataformat','ascii','nbchan',1,'data',strcat(Parent_Folder,'P1.',num2str(k),'\eeg_data.txt'),'setname',participant,sch,'srate',512,'pnts',1,'xmin',0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'gui','off');
EEG = eeg_checkset( EEG );