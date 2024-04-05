function [output_data]=import_mitre_aas_data_rev2(app,excel_filename,temp_data_label,tf_rescrap_excel)



%%%%%%%%%Find the 10th, 50, 90th, and Max (Median is somewhere else)

tic;
data_filename1=strcat(temp_data_label,'_array_azi_el_data.mat');
[var_exist_input]=persistent_var_exist_with_corruption(app,data_filename1);

if tf_rescrap_excel==1
    var_exist_input=0;
end

if var_exist_input==2
    retry_load=1;
    while(retry_load==1)
        try
            load(data_filename1,'output_data')
            pause(0.1)
            retry_load=0;
        catch
            retry_load=1;
            pause(1)
        end
    end
    pause(0.1)
else
    tic;
    cell_table=readtable(excel_filename);
    %%cell_data2=readcell(excel_filename);
    toc; %%%%%%%%%63 Seconds for readtable, 93 seconds for readcell

    tic;
    cell_data=table2cell(cell_table);
    toc;

 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    azi_idx=1;
    el_idx=2;
    array_azi=cell2mat(cell_data(:,azi_idx));
    size(array_azi)

    array_elv=cell2mat(cell_data(:,el_idx));
    size(array_elv)

    array_azi_el_gain=cell2mat(cell_data(:,[3:2:end]));
    array_azi_el_prop=cell2mat(cell_data(:,[4:2:end]));

    %%%%For each row, find the 10, 50, 90 and max.
    [num_rows,~]=size(array_azi_el_gain)
    array_percentile=horzcat(0.1,0.5,0.9,1)
    num_per=length(array_percentile);
    num_azi=length(array_azi);
    output_data=horzcat(array_azi,array_elv,NaN(num_azi,num_per));
    tic;
    for row_idx=1:1:num_rows
        row_idx/num_rows*100
        temp_per_idx=nearestpoint_app(app,array_percentile,array_azi_el_prop(row_idx,:));
        output_data(row_idx,[3:end])=array_azi_el_gain(row_idx,temp_per_idx);
    end
    toc; %%%%%%%%%%40 seconds when we give the updates

    %%%%%%%%%Azimuth, Elevation, 10,50,90 Max
    
    tic;
    retry_save=1;
    while(retry_save==1)
        try
            save(data_filename1,'output_data')
            pause(0.1)
            retry_save=0;
        catch
            retry_save=1;
            pause(1)
        end
    end
    pause(0.1)
    toc;

end


end