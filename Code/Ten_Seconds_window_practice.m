diff = abs(start_scenario(4,1) - start_scenario(length(start_scenario),1));
N = ceil(diff/10);
time1 = start_scenario(4,1);
time2 = 10+start_scenario(4,1);
clear x y time
for i = 1:N-1
    time{i} = ((i-1)*10)+time1+1:((i-1)*10)+time2;
    pop_spectopo(EEG, 1, [time{1,i}(1,1)*512 time{1,i}(1,length(time{1,i}))*512], 'EEG' , 'freqrange',[2 30],'electrodes','on'); % First slider action to completion of scenario
    h4 = findobj(gca,'Type','line');
    x{i}=get(h4,'Xdata');
    y{i}=get(h4,'Ydata');
%     upper_limit_4 = y_1(1) + 5-rem(y_1(1),5);
%     ylim([0 upper_limit_4]);
%     ylabel({'S({\omega})';'{\mu}V^2/Hz '})
%     xlabel('Frequency')
%     title('PSD(4)')
%     grid on
%     S_theta4 = mean(y_4(5:8)); S_alpha4 = mean(y_4(9:13)); S_beta4 = mean(y_4(14:31));%S_gamma4 = mean(y_4(22:26));
%     print(figure(L),fullfile(path,['PSD_expt_',num2str(k),'_Task_',num2str(m),'_part_all', '.png']),'-dpng','-r800');
    close all
 
end
time{N} = time{1,N-1}(1,length(time{1,N-1}))+1 : start_scenario(length(start_scenario),1);
if length(time{1,N})<2
    limiter = 2;
    time{N} = time{1,N-1}(1,length(time{1,N-1}))+1 : start_scenario(length(start_scenario),1)+limiter;
else
    time{N} = time{1,N-1}(1,length(time{1,N-1}))+1 : start_scenario(length(start_scenario),1);
end
pop_spectopo(EEG, 1, [time{1,N}(1,1)*512 time{1,N}(1,length(time{1,N}))*512], 'EEG' , 'freqrange',[2 30],'electrodes','on'); % First slider action to completion of scenario
    h4 = findobj(gca,'Type','line');
    x{i}=get(h4,'Xdata');
    y{N}=get(h4,'Ydata');
%     upper_limit_4 = y_1(1) + 5-rem(y_1(1),5);
%     ylim([0 upper_limit_4]);
%     ylabel({'S({\omega})';'{\mu}V^2/Hz '})
%     xlabel('Frequency')
%     title('PSD(4)')
%     grid on
%     S_theta4 = mean(y_4(5:8)); S_alpha4 = mean(y_4(9:13)); S_beta4 = mean(y_4(14:31));%S_gamma4 = mean(y_4(22:26));
%     print(figure(L),fullfile(path,['PSD_expt_',num2str(k),'_Task_',num2str(m),'_part_all', '.png']),'-dpng','-r800');
    close all
    
    
    