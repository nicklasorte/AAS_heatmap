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


%%%Since the macro antennas make use of AAS, they have been modeled as three sectors with peak 25 dBi gain while



excel_filename='ERICSSON_Aggregated EIRP Distribution_EIRPMap.xlsx'
temp_data_label='Ericsson_ver1'
tf_rescrap_excel=0
[ericsson_eirp]=load_aas_data_format_rev1(app,temp_data_label,excel_filename,tf_rescrap_excel);

min(ericsson_eirp)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Plot the new heatmaps
fig_label='Ericsson_AAS_Eirp62dBm'
%%%%%aas_heatmap_plot_rev1(app,fig_label,ericsson_eirp)


azi_ele_eirp_array=ericsson_eirp;
array_eirp=azi_ele_eirp_array(:,4);
array_azi=azi_ele_eirp_array(:,1);
array_ele=azi_ele_eirp_array(:,2);
uni_azi=unique(array_azi);
uni_el=unique(array_ele);
mat_size=[numel(uni_azi),numel(uni_el)]; % or swap, depending on what order you want.
z_eirp=reshape(array_eirp,mat_size);
 max(max(array_eirp))
 min(min(array_eirp))
dbm2_range=max(max(array_eirp))-min(min(array_eirp));
color_set=plasma(dbm2_range); %%%%%%%%%%%%Colormap
tic;
f1=figure;
AxesH = axes;
hold on;
[X,Y] = meshgrid(uni_azi,uni_el);
Z=z_eirp;
size(X)
size(Y)
size(Z)
surf(X,Y,Z','EdgeColor','none')
xticks(min(uni_azi):3:max(uni_azi))
yticks(min(uni_el):1:max(uni_el))
xlabel('Azimuth [Degrees]')
ylabel('Elevation [Degrees]')
h = colorbar;
ylabel(h, 'EIRP [dBm]')
grid on;
colormap(f1,color_set)
toc;
filename1=strcat(fig_label,'.png');
saveas(gcf,char(filename1))
toc;
pause(0.1)
close(f1)


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






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Find the delta between Ericsson and Mitre
azi_ele_eirp_array1=ericsson_eirp;
array_eirp1=azi_ele_eirp_array1(:,4);
array_azi1=azi_ele_eirp_array1(:,1);
array_ele1=azi_ele_eirp_array1(:,2);
uni_azi1=unique(array_azi1);
uni_el1=unique(array_ele1);


azi_ele_eirp_array2=mitre_urban_eirp;
array_eirp2=azi_ele_eirp_array2(:,4);
array_azi2=azi_ele_eirp_array2(:,1);
array_ele2=azi_ele_eirp_array2(:,2);
uni_azi2=unique(array_azi2);
uni_el2=unique(array_ele2);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Put each in the meshgrid and then interp2
mat_size1=[numel(uni_azi1),numel(uni_el1)]; 
z_eirp1=reshape(array_eirp1,mat_size1);
[X1,Y1]=meshgrid(uni_azi1,uni_el1);

mat_size1=[numel(uni_azi2),numel(uni_el2)]; 
z_eirp2=reshape(array_eirp2,mat_size1);
[X2,Y2] = meshgrid(uni_azi2,uni_el2);


%%%%%%%%%%%%%%Need to define a meshgrid to interp2 both data sets.
min_azi_step=min(horzcat(min(diff(uni_azi1)),min(diff(uni_azi2))));
min_ele_step=min(horzcat(min(diff(uni_el1)),min(diff(uni_el2))));

%%%%%%%%%Cover the minimum range of both;
azi_intersect=intersect(uni_azi1,uni_azi2);
ele_intersect=intersect(uni_el1,uni_el2);

int_mesh_azi=min(azi_intersect):min_azi_step:max(azi_intersect);
int_mesh_ele=min(ele_intersect):min_ele_step:max(ele_intersect);


[Xq,Yq] = meshgrid(int_mesh_azi,int_mesh_ele);
Z1_Vq = interp2(X1,Y1,z_eirp1',Xq,Yq);
Z2_Vq = interp2(X2,Y2,z_eirp2,Xq,Yq);

size(Z1_Vq)
size(Z2_Vq)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'Plot both to check'

dbm1_range=max(max(Z1_Vq))-min(min(Z1_Vq));
color_set1=plasma(dbm1_range); %%%%%%%%%%%%Colormap
tic;
f1=figure;
AxesH = axes;
hold on;
surf(Xq,Yq,Z1_Vq,'EdgeColor','none')
%xticks(min(uni_azi):45:max(uni_azi))
%yticks(min(uni_el):45:max(uni_el))
xlabel('Azimuth [Degrees]')
ylabel('Elevation [Degrees]')
h = colorbar;
ylabel(h, 'EIRP [dBm]')
grid on;
colormap(f1,color_set1)
toc;
filename1=strcat('Interp_Ericsson.png');
saveas(gcf,char(filename1))
toc;
pause(0.1)


dbm2_range=max(max(Z2_Vq))-min(min(Z2_Vq));
color_set2=plasma(dbm2_range); %%%%%%%%%%%%Colormap
tic;
f1=figure;
AxesH = axes;
hold on;
surf(Xq,Yq,Z2_Vq,'EdgeColor','none')
%xticks(min(uni_azi):45:max(uni_azi))
%yticks(min(uni_el):45:max(uni_el))
xlabel('Azimuth [Degrees]')
ylabel('Elevation [Degrees]')
h = colorbar;
ylabel(h, 'EIRP [dBm]')
grid on;
colormap(f1,color_set2)
toc;
filename1=strcat('Interp_Mitre_Urban.png');
saveas(gcf,char(filename1))
toc;
pause(0.1)


delta_eirp=Z1_Vq-Z2_Vq;
size(delta_eirp)
min(min(delta_eirp))
max(max(delta_eirp))

max(max(Z1_Vq))
max(max(Z2_Vq))


dbm3_range=max(max(Z2_Vq))-min(min(Z2_Vq));
color_set3=plasma(dbm3_range); %%%%%%%%%%%%Colormap
tic;
f1=figure;
AxesH = axes;
hold on;
surf(Xq,Yq,delta_eirp,'EdgeColor','none')
xticks(min(min(Xq)):3:max(max(Xq)))
yticks(min(min(Yq)):1:max(max(Yq)))
xlabel('Azimuth [Degrees]')
ylabel('Elevation [Degrees]')
h = colorbar;
ylabel(h, 'Delta EIRP [dB]')
grid on;
colormap(f1,color_set3)
toc;
filename1=strcat('Delta_Eric_Mitre_Urban.png');
saveas(gcf,char(filename1))
toc;
pause(0.1)





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
'Done'



