clear all; clc; 
%% part1: data importing and to sqeeze EEG.data dimentions. 
 subjects = [1:17]; %% subject numbers
 doortype = {'Narrow', 'Mid', 'Wide'};
 allN120ValuesSmooth = [];
 allP164ValuesSmooth = [];
 allN260ValuesSmooth = [];
 
for subject = subjects
    for doorIdx = 1:3  
    setname = strcat(['sub' num2str(subject) '_practice_filtered_' doortype{doorIdx}  '_Lights_ON_bad_epochs_removal.set']); %% filename of set file
    setpath = 'P:\Sheng_Wang\exp1\data\eeglab_practice\epochs_LightsOn\'; %% filepath of set files 
    EEG = pop_loadset('filename',setname,'filepath',setpath); %% load the data
    EEG = eeg_checkset(EEG);
    EEG_avg(subject,:,:) = squeeze(mean(EEG.data,3)); %% EEG_avg dimension: channel*time*trial → subj*channel*time
    
    
    
    %%part2: select the specific channel and calculate group-level ERP at this specific electrode
    electrode = 26; % select the specific channel
    searchN120Post = 120; % define peak latencies.
    searchP164Post = 164;
    searchN260Post = 260;
    
    figure;
    mean_data = squeeze(EEG_avg(subject,electrode,:));  %% select the data according to the above selected electrode and the specific subject number 
    plot(EEG.times, mean_data,'k','linewidth', 1.5); %% plot the waveforms
    axis([-500 1000 -5 5]);  %% define the region to display
    title(['Group-level at the specific electrode' num2str(electrode), ' sub' num2str(subject), doortype{doorIdx}],'fontsize',16); %% specify the figure name
    xlabel('Latency (ms)','fontsize',16); %% name of X axis
    ylabel('Amplitude (uV)','fontsize',16);  %% name of Y axis

    
    
    %%part3: to detect and pick up peaks amplitude within this study dataset
    y = mean_data; % signal and data
    t = EEG.times; % Time Vector
    t_window_N120 = [searchN120Post-50, searchN120Post+50]; %Time window for N120
    t_window_P164 = [searchP164Post-50, searchP164Post+50]; %Time window for P164
    t_window_N260 = [searchN260Post-50, searchN260Post+50]; %Time window for N260
    
    idx_N120 = find((t>= t_window_N120(1)) & (t<=t_window_N120(2))); % Indices Corresponding To Time Window 
    idx_P164 = find((t>= t_window_P164(1)) & (t<=t_window_P164(2))); % Indices Corresponding To Time Window 
    idx_N260 = find((t>= t_window_N260(1)) & (t<=t_window_N260(2))); % Indices Corresponding To Time Window 

    [N120Values, N120locs] = min(y(idx_N120)); % Find PeakValues In Time Window. Because findpeaks function requires idx as the parameter rather than times.
    adjN120locs = N120locs + idx_N120(1)-1; % Adjust 'locs' To Correct For Offset.  
    N120ValuesSmooth = mean(y(adjN120locs-3:adjN120locs+3)); % extract three sampling points before and after the specific peak and then calculate mean of these 7 data points. 
    allN120ValuesSmooth = [allN120ValuesSmooth, N120ValuesSmooth];
    
    [P164Values, P164locs] = max(y(idx_P164)); % Find PeakValues In Time Window. Because findpeaks function requires idx as the parameter rather than times.
    adjP164locs = P164locs + idx_P164(1)-1; % Adjust 'locs' To Correct For Offset.  
    P164ValuesSmooth = mean(y(adjP164locs-3:adjP164locs+3)); % extract three sampling points before and after the specific peak and then calculate mean of these 7 data points. 
    allP164ValuesSmooth = [allP164ValuesSmooth, P164ValuesSmooth];
    
    [N260Values, N260locs] = min(y(idx_N260)); % Find PeakValues In Time Window. Because findpeaks function requires idx as the parameter rather than times.
    adjN260locs = N260locs + idx_N260(1)-1; % Adjust 'locs' To Correct For Offset.  
    N260ValuesSmooth = mean(y(adjN260locs-3:adjN260locs+3)); % extract three sampling points before and after the specific peak and then calculate mean of these 7 data points. 
    allN260ValuesSmooth = [allN260ValuesSmooth, N260ValuesSmooth];
    
    figure
    plot(t,y)
    hold on
    plot(t(adjN120locs), N120Values, 'vb')
    plot(t(adjP164locs), P164Values, '^r')     %plot(t(adjN1locs), N1Values, '^r') 
    plot(t(adjN260locs), N260Values, 'vb')
    title(['On the specific electrode' num2str(electrode) ' N120P164N260 detection ', 'sub' num2str(subject), doortype{doorIdx}],'fontsize',16); %% specify the figure name
    xlabel('Latency (ms)','fontsize',16); %% name of X axis
    ylabel('Amplitude (uV)','fontsize',16);  %% name of Y axis
    hold off
    grid
    
    
    end
end
 

%%part4: reshape one array to a matrix and name its columns and rows. 
matrix_allN120Values_NarrowMidWide_By_subjects = reshape (allN120ValuesSmooth, [3 17])
matrix_allP164Values_NarrowMidWide_By_subjects = reshape (allP164ValuesSmooth, [3 17])
matrix_allN260Values_NarrowMidWide_By_subjects = reshape (allN260ValuesSmooth, [3 17])
matrix_allN120Values_NarrowMidWide_By_subjects_3columns = matrix_allN120Values_NarrowMidWide_By_subjects'
matrix_allP164Values_NarrowMidWide_By_subjects_3columns = matrix_allP164Values_NarrowMidWide_By_subjects'
matrix_allN260Values_NarrowMidWide_By_subjects_3columns = matrix_allN260Values_NarrowMidWide_By_subjects'


labelCondition = {'Narrow'; 'Mid'; 'Wide'};
labelsubjects = {'sub1'; 'sub2'; 'sub3'; 'sub4'; 'sub5'; 'sub6'; 'sub7'; 'sub8'; 'sub9'; 'sub10'; 'sub11'; 'sub12'; 'sub13'; 'sub14'; 'sub15'; 'sub16'; 'sub17'};

table_allN120Values_NarrowMidWide_By_subjects = array2table(matrix_allN120Values_NarrowMidWide_By_subjects_3columns, 'RowNames', labelsubjects, 'VariableNames', labelCondition);
table_allP164Values_NarrowMidWide_By_subjects = array2table(matrix_allP164Values_NarrowMidWide_By_subjects_3columns, 'RowNames', labelsubjects, 'VariableNames', labelCondition);
table_allN260Values_NarrowMidWide_By_subjects = array2table(matrix_allN260Values_NarrowMidWide_By_subjects_3columns, 'RowNames', labelsubjects, 'VariableNames', labelCondition);

writetable (table_allN120Values_NarrowMidWide_By_subjects, ['Electrode' num2str(electrode) ' N120_NarrowMidWide.csv'])
writetable (table_allP164Values_NarrowMidWide_By_subjects, ['Electrode' num2str(electrode) ' P164_NarrowMidWide.csv'])
writetable (table_allN260Values_NarrowMidWide_By_subjects, ['Electrode' num2str(electrode) ' N260_NarrowMidWide.csv'])


save(['Group_level_ERP' num2str(electrode) '.mat'],'EEG_avg');  %% save the data of subjects
    
%%part5: add another code line to save data table into a tsv. file for
%%fitting with SPSS importing. So easy!


