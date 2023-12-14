clear all; clc; 
%% part1: data importing and to sqeeze EEG.data dimentions. 
 subjects = [1:17]; %% subject numbers
 doortype = {'Narrow', 'Mid', 'Wide'};
 showImperative = {'Go', 'NoGo'};
 allPINVValues = [];

 
for subject = subjects
    for doorIdx = 1:3  
        for showImperativeIdx = 1:2
    setname = strcat(['sub' num2str(subject) '_practice_filtered_' doortype{doorIdx} '_' showImperative{showImperativeIdx} '_bad_epochs_removal.set']); %% filename of set file
    setpath = 'P:\Sheng_Wang\exp1\data\eeglab_practice\epochs_ShowImperative\'; %% filepath of set files 
    EEG = pop_loadset('filename',setname, 'filepath',setpath); %% load the data
    EEG = eeg_checkset(EEG);
    EEG_avg(subject,:,:) = squeeze(mean(EEG.data,3)); %%EEG_avg dimension: channel*time*trial → subj*channel*time
    
    
    
    
    %%part2: select the specific channel and calculate group-level ERP at this specific electrode
    electrode = 42;
    
    figure;
    mean_data = squeeze(EEG_avg(subject,electrode,:));  %% select the data according to the above selected electrode and the specific subject number 
    plot(EEG.times, mean_data,'k','linewidth', 1.5); %% plot the waveforms
    axis([-500 1000 -5 5]);  %% define the region to display
    title(['Group-level at the specific electrode' num2str(electrode), ' sub' num2str(subject), doortype{doorIdx}, showImperative{showImperativeIdx}],'fontsize',16); %% specify the figure name
    xlabel('Latency (ms)','fontsize',16); %% name of X axis
    ylabel('Amplitude (uV)','fontsize',16);  %% name of Y axis

    
    
    %%part3: to detect and pick up peaks amplitude within this study dataset
    y = mean_data; % signal and data
    t = EEG.times; % Time Vector
    t_window_PINV = [600, 800]; %Time window
  
    idx_PINV = find((t>= t_window_PINV(1)) & (t<=t_window_PINV(2))); % Indices Corresponding To Time Window 
    
    [PINVValues] = mean(y(idx_PINV)); %%PINV calculation.
    allPINVValues = [allPINVValues, PINVValues];
   
    
    figure
    x_time_window = [600 800 800 600];
    y_time_window = [-12 -12 8 8];
    fill(x_time_window,y_time_window, 'y')
    hold on
    
    %plot(t_window_PINV, PINVValues, '^r', "LineWidth", 1.5)     %plot(t(adjN1locs), N1Values, '^r') 
    %hold on
    
    plot(t,y)
    hold on

    
    yline(PINVValues)
    
    title(['On the specific electrode' num2str(electrode) ' PINV calculation ', 'sub' num2str(subject), doortype{doorIdx}, showImperative{showImperativeIdx}],'fontsize',16); %% specify the figure name
    xlabel('Latency (ms)','fontsize',16); %% name of X axis
    ylabel('Amplitude (uV)','fontsize',16);  %% name of Y axis
    hold off
    grid
    
        end
    end
end
 

%%part4: reshape one array to a matrix and name its columns and rows. 
matrix_allPINVValues_NarrowMidWide_By_subjects = reshape (allPINVValues, [6 17])
matrix_allPINVValues_NarrowMidWide_By_subjects_3columns = matrix_allPINVValues_NarrowMidWide_By_subjects'



labelCondition = {'Narrow_Go'; 'Narrow_NoGo'; 'Mid_Go'; 'Mid_NoGo'; 'Wide_Go'; 'Wide_NoGo'};
labelsubjects = {'sub1'; 'sub2'; 'sub3'; 'sub4'; 'sub5'; 'sub6'; 'sub7'; 'sub8'; 'sub9'; 'sub10'; 'sub11'; 'sub12'; 'sub13'; 'sub14'; 'sub15'; 'sub16'; 'sub17'};

table_allPINVValues_NarrowMidWide_By_subjects = array2table(matrix_allPINVValues_NarrowMidWide_By_subjects_3columns, 'RowNames', labelsubjects, 'VariableNames', labelCondition);


writetable (table_allPINVValues_NarrowMidWide_By_subjects, ['Electrode' num2str(electrode) ' PINV_NarrowMidWide.csv'])


save(['Group_level_ERP' num2str(electrode) '.mat'],'EEG_avg');  %% save the data of subjects
    
%%part5: add another code line to save data table into a csv. file for
%%fitting with SPSS importing. So easy!


