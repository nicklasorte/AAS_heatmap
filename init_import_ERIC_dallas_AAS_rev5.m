clear;
clc;
close all;
app=NaN(1);  %%%%%%%%%This is to allow for Matlab Application integration.
format shortG
top_start_clock=clock;
folder1='C:\Local Matlab Data\3.1GHz AAS'; %%%%%Folder where all the matlab code is placed.
cd(folder1)
addpath(folder1)
pause(0.1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

excel_filename='Ericsson Aggregated EIRP Distr _Example Dallas_.xlsx'
temp_data_label='Ericsson_Dallas2'
tf_rescrap_excel=0%1%0
[ericsson_eirp,table_eric]=load_aas_data_format_rev2(app,temp_data_label,excel_filename,tf_rescrap_excel);

header=table_eric.Properties.VariableNames
idx_50=find(contains(header,'50th'))  %%%%%%%%%%%Plotting the 50th.
array_azi=ericsson_eirp(:,1);
array_ele=ericsson_eirp(:,2);
array_eirp=ericsson_eirp(:,idx_50);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Plot the new heatmaps
fig_label='Ericsson_AAS_Dallas'
aas_heatmap_plot_rev2(app,fig_label,array_azi,array_ele,array_eirp)






end_clock=clock;
total_clock=end_clock-top_start_clock;
total_seconds=total_clock(6)+total_clock(5)*60+total_clock(4)*3600+total_clock(3)*86400;
total_mins=total_seconds/60;
total_hours=total_mins/60;
if total_hours>1
    strcat('Total Hours:',num2str(total_hours))
elseif total_mins>1
    strcat('Total Minutes:',num2str(total_mins))
else
    strcat('Total Seconds:',num2str(total_seconds))
end

