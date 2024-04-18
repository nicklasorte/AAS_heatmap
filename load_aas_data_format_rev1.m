function [output_data]=load_aas_data_format_rev1(app,temp_data_label,excel_filename,tf_rescrap_excel)


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
    cell_table=readtable(excel_filename)
    toc; %%%%%%%%%63 Seconds for readtable, 93 seconds for readcell

    cell_data=table2cell(cell_table);
    array_data=cell2mat(cell_data);
    output_data=array_data(:,[1,2,3,4,5,7,6]);



    %%%%%%%%%Azimuth, Elevation, 10,50,90 Max, Mean
    
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
