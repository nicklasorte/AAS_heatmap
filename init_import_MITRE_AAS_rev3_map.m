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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Read in the MITRE AAS antenna pattern
% % % % % The domain of each CDF is fixed to be -50 to 50 dB à 101 values per CDF
% % % % % § Discrete step size for azimuth is 1 degree, span of -180 to 180 degrees
% % % % % § Discrete step size for elevation is 0.5 degrees, span of -90 to 90 degrees

tf_rescrap_excel=0
excel_filename='MITRE_3GPP-Urban-Macro_8x2_1_20ms_-6deg_uniform-3D_1000runs.xlsx'  %%%%%%%%%100 MB, so a big import of data.
temp_data_label='MITRE_urban'
[aas_data_mitre_urban]=import_mitre_aas_data_rev2(app,excel_filename,temp_data_label,tf_rescrap_excel);


excel_filename='MITRE_WINNER-Suburban-Macro_2x1_3-2_20ms_0deg_uniform-3D_1000runs.xlsx'  %%%%%%%%%100 MB, so a big import of data.
temp_data_label='MITRE_suburban'
[aas_data_mitre_sub]=import_mitre_aas_data_rev2(app,excel_filename,temp_data_label,tf_rescrap_excel);


excel_filename='MITRE_3GPP-Rural-Macro_2x1_3-3-2_20ms_0deg_uniform-3D_1000runs.xlsx'  %%%%%%%%%100 MB, so a big import of data.
temp_data_label='MITRE_rural'
[aas_data_mitre_rural]=import_mitre_aas_data_rev2(app,excel_filename,temp_data_label,tf_rescrap_excel);


%%%%%%%%Assume 25dB max AAS gain --> Normalize AAS to Max EIPR
%%%%%%%%%%62dBm/1MHz Sub/Urban --> 37dBm (Conducted)
%%%%%%%%%%%65dBm/1MHz Rural  --> 40dBm (Conducted)

%%%%%%%%%%%%%Just
mitre_urban_eirp=aas_data_mitre_urban;
mitre_urban_eirp(:,[3:6])=aas_data_mitre_urban(:,[3:6])+37-1;
mitre_sub_eirp=aas_data_mitre_sub;
mitre_sub_eirp(:,[3:6])=aas_data_mitre_sub(:,[3:6])+37;
mitre_rural_eirp=aas_data_mitre_rural;
mitre_rural_eirp(:,[3:6])=aas_data_mitre_rural(:,[3:6])+40;


max(aas_data_mitre_urban)
max(aas_data_mitre_sub)
max(aas_data_mitre_rural)

max(mitre_urban_eirp)
max(mitre_sub_eirp)
max(mitre_rural_eirp)

save('mitre_urban_eirp62dBm.mat','mitre_urban_eirp')
save('mitre_sub_eirp62dBm.mat','mitre_sub_eirp')
save('mitre_rural_eirp65dBm.mat','mitre_rural_eirp')




%%%%%%%%%%1) Azimuth, 2) Elevation, 3)10th, 4)50th, 5)90th, 6)Max
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Plot the new heatmaps
fig_label='Rural_AAS_Eirp65dBm'
aas_heatmap_plot_rev1(app,fig_label,mitre_rural_eirp)

fig_label='Suburban_AAS_Eirp62dBm'
aas_heatmap_plot_rev1(app,fig_label,mitre_sub_eirp)

fig_label='Urban_AAS_Eirp62dBm'
aas_heatmap_plot_rev1(app,fig_label,mitre_urban_eirp)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Plot the Zero Elevation 2D Plot
zero_ele1_idx=find(mitre_rural_eirp(:,2)==0);
zero_ele2_idx=find(mitre_sub_eirp(:,2)==0);
zero_ele3_idx=find(mitre_urban_eirp(:,2)==0);

zero_rural50=mitre_rural_eirp(zero_ele1_idx,[1,4]);
zero_sub50=mitre_sub_eirp(zero_ele2_idx,[1,4]);
zero_urban50=mitre_urban_eirp(zero_ele3_idx,[1,4]);

65-max(zero_rural50(:,2))
62-max(zero_sub50(:,2))
62-max(zero_urban50(:,2))



figure;
hold on;
plot(zero_rural50(:,1),zero_rural50(:,2),'-b','LineWidth',2,'DisplayName','Rural')
plot(zero_sub50(:,1),zero_sub50(:,2),'-g','LineWidth',2,'DisplayName','Suburban')
plot(zero_urban50(:,1),zero_urban50(:,2),'-r','LineWidth',2,'DisplayName','Urban')
xlabel('Azimuth [Degree]')
ylabel('EIRP [dBm/1MHz]')
title('EIRP: 50th Percentile at the Horizon')
legend;
grid on;
filename1=strcat('Mitre_Zero_Horizon.png');
saveas(gcf,char(filename1))



% %%%%%%%Write a Table
% table1=array2table(mitre_urban_eirp);
% table1.Properties.VariableNames={'Azimuth' 'Elevation' '10th' '50th' '90th' 'Max'};
% tic;
% writetable(table1,strcat('Mitre_Urban_AAS.xlsx'));
% toc;
% 
% table2=array2table(mitre_sub_eirp);
% table2.Properties.VariableNames={'Azimuth' 'Elevation' '10th' '50th' '90th' 'Max'};
% tic;
% writetable(table2,strcat('Mitre_Suburban_AAS.xlsx'));
% toc;
% 
% table3=array2table(mitre_rural_eirp);
% table3.Properties.VariableNames={'Azimuth' 'Elevation' '10th' '50th' '90th' 'Max'};
% tic;
% writetable(table3,strcat('Mitre_Rural_AAS.xlsx'));
% toc;




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

