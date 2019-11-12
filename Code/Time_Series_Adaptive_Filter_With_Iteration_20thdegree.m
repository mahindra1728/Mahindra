% Evaluating the Data Quality
order = input('\n Enter the order of polynomial required : ');
clearvars -except l order
for destination = 1:10
    u = destination;
    %         clearvars -except destination
    clc
    warning('off')
    format short g
    Main_Folder = 'D:\Mahindra\Adaptive filter\PSD_Filters\From Rest Period\4_points_to_10seconds_expt_file\4_points_new\4_point\EEGDATA\';
    person = {strcat('P',num2str(destination))};
    participant = char(person);
    
    i = 1;
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
        %                     fold_nms1 = Folder;
        %                     fold_nms2 = char(fold_nms1);
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
        %                     fold_nms1 = Folder;
        %                     fold_nms2 = char(fold_nms1);
    end
    
    %% Importing the Alarm Files
    alarm_file = [];
    alarm_name = [];
    alarm_file1 = [];alarm_name1 = []; mouseclick = [];mouseclick1 = []; txtData = []; txtData1= []; process_raw = [];PSD = [];
    %     percentage = zeros(10,9); mean= zeros(10,9); std_deviation = zeros(10,9);
    load('D:\Mahindra\Codes\Noise_Count_All_Participants.mat');
    destination = u;
    for k=1:length(Folder)
        %         percentage = zeros(destination,length(Folder)); mean=zeros(destination,length(Folder));std_deviation=zeros(destination,length(Folder));
        path=strcat(Parent_Folder,Folder(k).name,'\');
        disp(path)
        counts_noise_new = counts_noise{destination,1}{k};
        %         d = counts_noise_new(3,1);
        raw_data_without_filter_100_100 = ip_signal_raw{destination,1}{k};
        %         filtered_data{destination,1}{k}(1:d-1,1) = raw_data_without_filter_100_100(1:d-1,1);
        for j = 1:length(raw_data_without_filter_100_100)
            if raw_data_without_filter_100_100(j,1) < 100 && raw_data_without_filter_100_100(j,1) > -100
                filtered_data{destination,1}{k}(j,1) = raw_data_without_filter_100_100(j,1);
            elseif ((raw_data_without_filter_100_100(j,1) >100 || raw_data_without_filter_100_100(j,1) < -100) && counts_noise_new((counts_noise_new(:,1) == j),3) >= 2)
                row = find(counts_noise_new(:,1) == j);
                x = counts_noise_new(row,1):counts_noise_new(row,2)-1;
                Actual_Data = ip_signal_raw{destination,1}{k}(x);
                diff = x(end)-x(1);
                x = 0:diff;
                %% Code for generating the model coefficients, can be used for nth degree model
                i=1:1:order;
                A=[ones(length(x),1) x'.^i]; %% Matrix A defined, x is the raw data
                x_star=zeros(order+1,order); % Zeros for x_star,
                u_star = zeros(length(x),order); % U_star is the nearest predicted point to raw data point
                for i=1:order
                    l=length(Actual_Data); %% Just some assumed jugglery
                    A1_OPEN=A(:,1:i+1); % Below formula is from theory of approximation to find the coeffients of nth degree polynomial
                    temp=inv(A1_OPEN'*A1_OPEN)*(A1_OPEN'*Actual_Data); %% formula for finding x_star = inv(A'A)*A'b
                    temp = [temp;zeros(size(x_star,1)-size(temp,1),1)];
                    x_star(:,i)=temp;
                    temp1=A1_OPEN(:,1:(i+1))*x_star(1:(i+1),i);%% Formula for finding u_star : A*x_star = u_star.
                    temp1 = [temp1;zeros(size(u_star,1)-size(temp1,1),1)];
                    u_star(:,i) = temp1;
                end
%                 fprintf(strcat('\n Coeffients upto ','_',num2str(order),'_Degree polynomial is : '));
                %                 disp(x_star)
                i=1:order;
                error= (Actual_Data-u_star(:,i)).^2; % Finding the minimum length between raw data and u_star
                mean_var = abs(mean(error)); % finding the mean of all errors
                [Mopen,Nopen] = min(mean_var); % indexing the minimum error polynomials
                [Ms,Nso] = sort(mean_var);% indexing the minimum error polynomials
                % Some minimum mean degree polynomial indexing.
%                 disp(Nso(1));
                firstLoop = 1;
                counter = 1000;
                nsoCounter = 1;
                
                while((nsoCounter <= order) && counter == 1000)
                    counter = 0;
                    Noise_data = u_star(:,Nso(nsoCounter));
                    while (firstLoop == 1 || (max(y) > 100 || min(y) <-100)) && counter < 1000
                        rls2 = dsp.RLSFilter('Length', 4, 'Method', 'Householder RLS');
                        filt2 = dsp.FIRFilter('Numerator',fir1(5, [.5, .75]));
                        x = Noise_data;                           % Noise
                        d = Actual_Data;     % Noise + Signal
                        [err,y] = rls2(x, d);
                        if j>2
                            y(1) = mean(raw_data_without_filter_100_100(j-2:j,1));
                            if y(1) > 100 || y(1) < -100
                                y(1) = mean(raw_data_without_filter_100_100(j-2-1:j,1));
                            end
                        end
                        if sum(y>100) >= 1
                            [index,~] = find(y>100);
                            y(index) = mean(y);
                        end
                        if sum(y>100) >= 1
                            [index,~] = find(y>100);
                            y(index) = mean(y(1:ceil(diff/2),1));
                        end
                        if sum(y>100) >= 1
                            [index,~] = find(y>100);
                            y(index) = mean(y(ceil(diff/2):end,1));
                        end
                        
                        if sum(y< -100) >= 1
                            [index,~] = find(y<-100);
                            y(index) = mean(y);
                        end
                        if sum(y< -100) >= 1
                            [index,~] = find(y<-100);
                            y(index) = mean(y(1:ceil(diff/2),1));
                        end
                        if sum(y< -100) >= 1
                            [index,~] = find(y<-100);
                            y(index) = mean(y(ceil(diff/2):end,1));
                        end
                        firstLoop = 0;
                        counter = counter + 1;
                    end
                    nsoCounter = nsoCounter + 1;
                end
                
                %                 subplot(3,1,1), plot(d,'b');hold on;plot(x,'r'), title('Noise + Signal');legend('Actual data','Noise Function');
                %                 subplot(3,1,2), plot(y), title('Signal');
                %                 subplot(3,1,3), plot(err), title('Signal');hold on;plot(d,'r')
                
                %                 if sum(y>100) >= 1
                %                     [index,~] = find(y>100);
                %                     y(index) = mean(y);
                %                 end
                %                 if sum(y < -100) >= 1
                %                     [index,~] = find(y < -100);
                %                     y(index) = mean(y);
                %                 end
                %                 if sum(y>100) >= 1
                %                     [index,~] = find(y>100);
                %                     y(index) = mean(y);
                %                 end
                %                 if sum(y < -100) >= 1
                %                     [index,~] = find(y < -100);
                %                     y(index) = mean(y);
                %                 end
                filtered_data{destination,1}{k}(j:counts_noise_new(row,2)-1,1) = ceil(y);
                raw_data_without_filter_100_100(j:counts_noise_new(row,2)-1,1) = ceil(y);
            else
                diff = counts_noise_new((counts_noise_new(:,1) == j),3);
                if j-diff > 0
                    row = find(counts_noise_new(:,1) == j);
                    diff = counts_noise_new((counts_noise_new(:,1) == j),3);
                    filtered_data{destination,1}{k}(j:counts_noise_new(row,2),1) = movmean(raw_data_without_filter_100_100(j-diff:j,1),2);
                    raw_data_without_filter_100_100(j:counts_noise_new(row,2),1) = movmean(filtered_data{destination,1}{k}(j-diff:j,1),2);
                end
            end
            
        end
        eeg_Adaptive_filtered_data = ceil(filtered_data{destination,1}{k});
        fnm =[Parent_Folder strcat(participant,'.',num2str(k)) '\' 'eeg_data_Adaptive_filter.txt'];
        fid = fopen(fnm,'wt');
        fprintf(fid,'%.2f\n',eeg_Adaptive_filtered_data);
        fclose(fid);
        save('eeg_data_Adaptive_filter.txt','eeg_Adaptive_filtered_data','-ascii')
    end
end