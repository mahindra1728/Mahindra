%% Evaluating the Data Quality
order = input('\n Enter the order of polynomial required : ');
% lag = input('Enter the Lag Required');
clearvars -except l order counts_noise_1 counts_noise_new correlation correlation_mean lag filtered_data
for destination = 1:10
    u = destination;
    %     clearvars -except destination
    clc
    warning('off')
    format short g
    Main_Folder = 'D:\Mahindra\Adaptive_Filter_Without_Iteration\EEGDATA\';
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
    alarm_name = [];
    alarm_file1 = [];alarm_name1 = []; mouseclick = [];mouseclick1 = []; txtData = []; txtData1= []; process_raw = [];PSD = [];
    %     percentage = zeros(10,9); mean= zeros(10,9); std_deviation = zeros(10,9);
    load('D:\Mahindra\Codes\Noise_Count_All_Participants.mat');
    destination = u;
    for k=1:length(Folder)
        %         percentage = zeros(destination,length(Folder)); mean=zeros(destination,length(Folder));std_deviation=zeros(destination,length(Folder));
        path=strcat(Parent_Folder,Folder(k).name,'\')
        %         disp(path)
        counts_noise_new = counts_noise{u,1}{k};
        %         d = counts_noise_new(3,1);
        data_to_be_filtered{u,1}{k} = ip_signal_raw{u,1}{k};
        %         filtered_data{destination,1}{k}(1:d-1,1) = raw_data_without_filter_100_100(1:d-1,1);
        for j = 1:length(counts_noise_new(:,1))
            row = j;
            if abs(counts_noise_new(row,1) - counts_noise_new(row,2)-1) >= 10
                row = j;
                x = counts_noise_new(row,1):counts_noise_new(row,2)-1;
                Actual_Data = ip_signal_raw{u,1}{k}(x);
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
                
                Noise_data = u_star(:,Nso(1));
                
                rls2 = dsp.RLSFilter('Length', 5, 'Method', 'Householder RLS');
                filt2 = dsp.FIRFilter('Numerator',fir1(10, [.5, .75]));
                x = Noise_data;                           % Noise
                d = Actual_Data;     % Noise + Signal
                [err,y] = rls2(x, d);
                data_to_be_filtered{u,1}{k}(counts_noise_new(row,1):counts_noise_new(row,2)-1) = ceil(ceil(y));
%             else
%                 if abs(counts_noise_new(row,1) - counts_noise_new(row,2)-1) >= 5
%                     if counts_noise_new(row,1) > 20
%                         data_to_be_filtered{u,1}{k}(counts_noise_new(row,1):counts_noise_new(row,2)) = movmean(data_to_be_filtered{u,1}{k}(counts_noise_new(row,1)-length(counts_noise_new(row,1)+1:counts_noise_new(row,2)):counts_noise_new(row,1)),length(counts_noise_new(row,1):counts_noise_new(row,2)));
%                     end
%                 end
            end
        end
%         while length(find(isnan(data_to_be_filtered{u,1}{k}))) > 0
%             [index,~] = find(isnan(data_to_be_filtered{u,1}{k}));
%             
%             for i = 1:length(index)
%                 if index(i)>2
%                     data_to_be_filtered{u,1}{k}(index(i)) = mean([data_to_be_filtered{u,1}{k}(index(i)-2) data_to_be_filtered{u,1}{k}(index(i)-1)]);
%                 else
%                     data_to_be_filtered{u,1}{k}(index(i)) = mean([data_to_be_filtered{u,1}{k}(index(i)+1) data_to_be_filtered{u,1}{k}(index(i)+2)]);
%                 end  
%             end
%         end
        eeg_Adaptive_filtered_data = ceil(data_to_be_filtered{u,1}{k});
        fnm =[Parent_Folder strcat(participant,'.',num2str(k)) '\' 'eeg_data_AF_WI_3degree_Only_Eye_Blinks.txt'];
        fid = fopen(fnm,'wt');
        fprintf(fid,'%.2f\n',eeg_Adaptive_filtered_data);
        fclose(fid);
        save('eeg_data_AF_WI_3degree_Only_Eye_Blinks.txt','data_to_be_filtered','-ascii')
    end
end