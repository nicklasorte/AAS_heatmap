function aas_heatmap_plot_rev1(app,fig_label,azi_ele_eirp_array)


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
surf(X,Y,Z,'EdgeColor','none')
xticks(min(uni_azi):45:max(uni_azi))
yticks(min(uni_el):45:max(uni_el))
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
end