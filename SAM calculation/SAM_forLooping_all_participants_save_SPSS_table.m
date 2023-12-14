clear all; clc; 

subjects = [1:17]; %%

allParticipants_Narrow_Go_Arousal = [];
allParticipants_Mid_Go_Arousal = [];
allParticipants_Wide_Go_Arousal = [];
allParticipants_Narrow_NoGo_Arousal = [];
allParticipants_Mid_NoGo_Arousal = [];
allParticipants_Wide_NoGo_Arousal = [];
allParticipants_Narrow_Go_Valence = [];
allParticipants_Mid_Go_Valence = [];
allParticipants_Wide_Go_Valence = [];
allParticipants_Narrow_NoGo_Valence = [];
allParticipants_Mid_NoGo_Valence = [];
allParticipants_Wide_NoGo_Valence = [];
allParticipants_Narrow_Go_Dominance = [];
allParticipants_Mid_Go_Dominance = [];
allParticipants_Wide_Go_Dominance = [];
allParticipants_Narrow_NoGo_Dominance = [];
allParticipants_Mid_NoGo_Dominance = [];
allParticipants_Wide_NoGo_Dominance = [];

for subject = subjects
addpath 'P:\Sheng_Wang\exp1\data\behavioral_data\SAM_extraction_conditions_answers';
data = tdfread(['sub-' num2str(subject) '_task-DefaultTask_events.tsv'], '\t' );
%data = tdfread('sub-1_task-DefaultTask_events.tsv', '\t' );
%% extract conditions and questions
condition = {};
arousal = {};
valence = {};
dominance = {};
num = 1;

for i = 1:length(data.onset)
    
    % conditions
    if regexp(data.value(i, :),'trial:start') 
        condition{num, 1} = data.value(i, :);
        
        % rename conditions
        if regexp(data.value(i, :),'doorType:Narrow;imperative:Go') 
            condition{num, 2} = 1;
        elseif regexp(data.value(i, :),'doorType:Mid;imperative:Go') 
            condition{num, 2} = 2;
        elseif regexp(data.value(i, :),'doorType:Wide;imperative:Go') 
            condition{num, 2} = 3;
        elseif regexp(data.value(i, :),'doorType:Narrow;imperative:NoGo') 
            condition{num, 2} = 4;
        elseif regexp(data.value(i, :),'doorType:Mid;imperative:NoGo') 
            condition{num, 2} = 5;
        elseif regexp(data.value(i, :),'doorType:Wide;imperative:NoGo') 
            condition{num, 2} = 6;
        end   
         
        % Arousal
        for j = i:length(data.onset)
             if regexp(data.value(j, :), 'SAM:Arousal')
                 arousal{num, 1} = data.value(j, :);
                 arousal{num, 2}  = str2num(data.value(j, 12));
                 break;
             end
        end
        
        % Valence
        for j = i:length(data.onset)
             if regexp(data.value(j, :), 'SAM:Valence')
                 valence{num, 1} = data.value(j, :);
                 valence{num, 2} = str2num(data.value(j, 12));
                  break;
             end
        end
        
        % Dominance
        for j = i:length(data.onset)
             if regexp(data.value(j, :), 'SAM:Dominance')
                 dominance{num, 1} = data.value(j, :);
                 dominance{num, 2} = str2num(data.value(j, 14));
                 break;
             end
        end       
        num = num+1;
    end
    
end
condition(1:12, :) = [];
arousal(1:12, :) = [];
valence(1:12, :) = [];
dominance(1:12, :) = [];

%% save data
condition = cell2mat(condition(:, 2));
question = [cell2mat(arousal(:, 2)), cell2mat(valence(:, 2)), cell2mat(dominance(:, 2))];
behavioral_raw_data = [condition question];
behavioral_raw_data_sortrows = sortrows(behavioral_raw_data, 1);

% matrix to table
labelCondition = {'conditions'; 'arousal'; 'valence'; 'dominance'};
table_behavioral_raw_data_sortrows = array2table(behavioral_raw_data_sortrows, 'VariableNames', labelCondition);

% creat categorical variables for grouped calculations
group_summary_this_dataset = groupsummary(table_behavioral_raw_data_sortrows, "conditions", "mean");
[Narrow_Go_Arousal]          = group_summary_this_dataset{1,3};
[Mid_Go_Arousal]             = group_summary_this_dataset{2,3};
[Wide_Go_Arousal]            = group_summary_this_dataset{3,3};
[Narrow_NoGo_Arousal]        = group_summary_this_dataset{4,3};
[Mid_NoGo_Arousal]           = group_summary_this_dataset{5,3};
[Wide_NoGo_Arousal]          = group_summary_this_dataset{6,3};
[Narrow_Go_Valence]          = group_summary_this_dataset{1,4};
[Mid_Go_Valence]             = group_summary_this_dataset{2,4};
[Wide_Go_Valence]            = group_summary_this_dataset{3,4};
[Narrow_NoGo_Valence]        = group_summary_this_dataset{4,4};
[Mid_NoGo_Valence]           = group_summary_this_dataset{5,4};
[Wide_NoGo_Valence]          = group_summary_this_dataset{6,4};
[Narrow_Go_Dominance]        = group_summary_this_dataset{1,5};
[Mid_Go_Dominance]           = group_summary_this_dataset{2,5};
[Wide_Go_Dominance]          = group_summary_this_dataset{3,5};
[Narrow_NoGo_Dominance]      = group_summary_this_dataset{4,5};
[Mid_NoGo_Dominance]         = group_summary_this_dataset{5,5};
[Wide_NoGo_Dominance]        = group_summary_this_dataset{6,5};

 
allParticipants_Narrow_Go_Arousal     = [allParticipants_Narrow_Go_Arousal, Narrow_Go_Arousal];
allParticipants_Mid_Go_Arousal        = [allParticipants_Mid_Go_Arousal, Mid_Go_Arousal];
allParticipants_Wide_Go_Arousal       = [allParticipants_Wide_Go_Arousal, Wide_Go_Arousal];
allParticipants_Narrow_NoGo_Arousal   = [allParticipants_Narrow_NoGo_Arousal, Narrow_NoGo_Arousal];
allParticipants_Mid_NoGo_Arousal      = [allParticipants_Mid_NoGo_Arousal, Mid_NoGo_Arousal];
allParticipants_Wide_NoGo_Arousal     = [allParticipants_Wide_NoGo_Arousal, Wide_NoGo_Arousal];
allParticipants_Narrow_Go_Valence     = [allParticipants_Narrow_Go_Valence, Narrow_Go_Valence];
allParticipants_Mid_Go_Valence        = [allParticipants_Mid_Go_Valence, Mid_Go_Valence];
allParticipants_Wide_Go_Valence       = [allParticipants_Wide_Go_Valence, Wide_Go_Valence];
allParticipants_Narrow_NoGo_Valence   = [allParticipants_Narrow_NoGo_Valence, Narrow_NoGo_Valence];
allParticipants_Mid_NoGo_Valence      = [allParticipants_Mid_NoGo_Valence, Mid_NoGo_Valence];
allParticipants_Wide_NoGo_Valence     = [allParticipants_Wide_NoGo_Valence, Wide_NoGo_Valence];
allParticipants_Narrow_Go_Dominance   = [allParticipants_Narrow_Go_Dominance, Narrow_Go_Dominance];
allParticipants_Mid_Go_Dominance      = [allParticipants_Mid_Go_Dominance, Mid_Go_Dominance];
allParticipants_Wide_Go_Dominance     = [allParticipants_Wide_Go_Dominance, Wide_Go_Dominance];
allParticipants_Narrow_NoGo_Dominance = [allParticipants_Narrow_NoGo_Dominance, Narrow_NoGo_Dominance];
allParticipants_Mid_NoGo_Dominance    = [allParticipants_Mid_NoGo_Dominance, Mid_NoGo_Dominance];
allParticipants_Wide_NoGo_Dominance   = [allParticipants_Wide_NoGo_Dominance, Wide_NoGo_Dominance];

end

Arousal_allParticipants = [allParticipants_Narrow_Go_Arousal; allParticipants_Narrow_NoGo_Arousal; allParticipants_Mid_Go_Arousal; allParticipants_Mid_NoGo_Arousal; allParticipants_Wide_Go_Arousal; allParticipants_Wide_NoGo_Arousal]';
labelCondition = {'Narrow_Go'; 'Narrow_NoGo'; 'Mid_Go'; 'Mid_NoGo'; 'Wide_Go'; 'Wide_NoGo'};
labelsubjects = {'sub1'; 'sub2'; 'sub3'; 'sub4'; 'sub5'; 'sub6'; 'sub7'; 'sub8'; 'sub9'; 'sub10'; 'sub11'; 'sub12'; 'sub13'; 'sub14'; 'sub15'; 'sub16'; 'sub17'};
table_Arousal_allParticipants = array2table(Arousal_allParticipants, 'RowNames', labelsubjects, 'VariableNames', labelCondition);
writetable (table_Arousal_allParticipants, 'Arousal_all_participants.csv');

Valence_allParticipants = [allParticipants_Narrow_Go_Valence; allParticipants_Narrow_NoGo_Valence; allParticipants_Mid_Go_Valence; allParticipants_Mid_NoGo_Valence; allParticipants_Wide_Go_Valence; allParticipants_Wide_NoGo_Valence]';
labelCondition = {'Narrow_Go'; 'Narrow_NoGo'; 'Mid_Go'; 'Mid_NoGo'; 'Wide_Go'; 'Wide_NoGo'};
labelsubjects = {'sub1'; 'sub2'; 'sub3'; 'sub4'; 'sub5'; 'sub6'; 'sub7'; 'sub8'; 'sub9'; 'sub10'; 'sub11'; 'sub12'; 'sub13'; 'sub14'; 'sub15'; 'sub16'; 'sub17'};
table_Valence_allParticipants = array2table(Valence_allParticipants, 'RowNames', labelsubjects, 'VariableNames', labelCondition);
writetable (table_Valence_allParticipants, 'Valence_all_participants.csv');

Dominance_allParticipants = [allParticipants_Narrow_Go_Dominance; allParticipants_Narrow_NoGo_Dominance; allParticipants_Mid_Go_Dominance; allParticipants_Mid_NoGo_Dominance; allParticipants_Wide_Go_Dominance; allParticipants_Wide_NoGo_Dominance]';
labelCondition = {'Narrow_Go'; 'Narrow_NoGo'; 'Mid_Go'; 'Mid_NoGo'; 'Wide_Go'; 'Wide_NoGo'};
labelsubjects = {'sub1'; 'sub2'; 'sub3'; 'sub4'; 'sub5'; 'sub6'; 'sub7'; 'sub8'; 'sub9'; 'sub10'; 'sub11'; 'sub12'; 'sub13'; 'sub14'; 'sub15'; 'sub16'; 'sub17'};
table_Dominance_allParticipants = array2table(Dominance_allParticipants, 'RowNames', labelsubjects, 'VariableNames', labelCondition);
writetable (table_Dominance_allParticipants, 'Dominance_all_participants.csv');





%group_summary_this_dataset_cell = table2cell(group_summary_this_dataset)
%group_summary_this_dataset_6columns = group_summary_this_dataset_cell'

% matrix to table
%labelCondition = {'Narrow_Go_sub1'; 'Mid_Go_sub1'; 'Wide_Go_sub1'; 'Narrow_NoGo_sub1'; 'Mid_NoGo_sub1'; 'Wide_NoGo_sub1'};
%label_SAM_dimensions = {'Condition_idx_sub1'; 'groupcount_sub1'; 'Arousal_sub1'; 'Valence_sub1'; 'Dominance_sub1'};
%table_group_summary_this_dataset_6columns = array2table(group_summary_this_dataset_6columns, 'RowNames', label_SAM_dimensions, 'VariableNames', labelCondition);


%[ParticipantsTable] = table_group_summary_this_dataset_6columns;
%allParticipantsTable = [allParticipantsTable, ParticipantsTable];

%end

%writetable (table_allPINVValues_NarrowMidWide_By_subjects, ['Electrode' num2str(electrode) ' PINV_NarrowMidWide.csv'])

%save('sub-1.mat', 'condition', 'question');