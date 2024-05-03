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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
excel_filename='percentiles-Nokia.xlsx'
temp_data_label='Nokia1'
tic;
cell_table=readtable(excel_filename);
toc; 

cell_data=table2cell(cell_table)
[num_rows,~]=size(cell_data)

for i=1:1:num_rows
    temp_seg_str=cell_data{i,1};
    temp_split=strsplit(temp_seg_str,'SEGMENT');
    cell_data{i,1}=str2num(temp_split{2});
end
array_data=cell2mat(cell_data(:,[1,3]))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%Nokia grid

% % full_azi=-90:1:90;
% % ful_ele=90:-1:-90;
full_azi=-62:1:62;
ful_ele=38:-1:-26;

[full_meshX,full_meshY]=meshgrid(full_azi,ful_ele);
full_array_azi=reshape(full_meshX',[],1);
full_array_ele=reshape(full_meshY',[],1);

full_azi_ele=horzcat(full_array_azi,full_array_ele);

% % azi=vertcat(-90,-60,-45,-30,-15,0,15,30,45,60,90);
% % ele=vertcat(90,36,21,6,-9,-24,-90);
azi=vertcat(-62,-60,-45,-30,-15,0,15,30,45,60,62);
ele=vertcat(38,36,21,6,-9,-24,-26);

max_azi=90;
min_ele=-90;

[meshX,meshY]=meshgrid(azi(1:end-1),ele(1:end-1));
array_azi=reshape(meshX',[],1);
array_ele=reshape(meshY',[],1);
array_azi_ele=horzcat(array_azi,array_ele);
array_azi_ele(:,3)=1:length(array_azi); %%%%%%%This is the segment number.

[num_ele,~]=size(full_azi_ele)
tic;
for i=1:1:num_ele
    %i/num_ele*100
    temp_azi_ele=full_azi_ele(i,:);
    [azi_idx1]=nearestpoint_app(app,temp_azi_ele(1),azi,'previous');
    [azi_idx2]=nearestpoint_app(app,temp_azi_ele(1),azi,'next');
    [ele_idx1]=nearestpoint_app(app,temp_azi_ele(2),ele,'previous');
    [ele_idx2]=nearestpoint_app(app,temp_azi_ele(2),ele,'next');

    if isnan(azi_idx1)
        azi_idx1=azi_idx2;
    end

    row1_idx=find(azi(azi_idx1)==array_azi_ele(:,1));
    rows2_idx=find(ele(ele_idx2)==array_azi_ele(:,2));
    if isempty(rows2_idx)
         rows2_idx=row1_idx(end);
    end
    int_idx=intersect(row1_idx,rows2_idx);

    if isempty(int_idx)
        'Empty int_idx'
        pause;
    end
    temp_segment=array_azi_ele(int_idx,3);
    seg_idx=find(array_data(:,1)==temp_segment);
    if isempty(seg_idx)
        'Empty seg_idx'
        pause;
    end
    full_azi_ele(i,3)=array_data(seg_idx,2);
%     full_azi_ele(i,:)
%     horzcat(azi(azi_idx1),azi(azi_idx2),ele(ele_idx1),ele(ele_idx2))
end
toc;  %%%%%%%%%%%9 seconds --> 1.8 seconds






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Plot the new heatmaps
array_azi=full_azi_ele(:,1);
array_ele=full_azi_ele(:,2);
array_eirp=full_azi_ele(:,3);
fig_label='Nokia1'
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

