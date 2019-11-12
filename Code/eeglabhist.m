% EEGLAB history file generated on the 22-Jul-2019
% ------------------------------------------------

EEG.etc.eeglabvers = '2019.0'; % this tracks which version of EEGLAB is being used, you may ignore it
EEG = pop_importdata('dataformat','ascii','nbchan',1,'data','D:\\Mahindra\\EEGDATA\\P1\\Morning\\P1.1\\eeg_data.txt','setname','applicant','srate',512,'pnts',1,'xmin',0);
EEG = eeg_checkset( EEG );
figure; pop_spectopo(EEG, 1, [14000  38000], 'EEG' , 'freqrange',[2 25],'electrodes','off');
