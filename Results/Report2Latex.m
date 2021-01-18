%{
    Generate latex tables with the Teport info
%}

clc
clear all
close all

% Tabla resultados impulso heliocentica
varNames = {'$\Delta V$ Hohmann [km]', '$\Delta V_x$ Impulso [Hz]', '$\Delta V_y$ Impulso [Hz]', '$\Delta V_z$ Impulso [Hz]'};
T = readtable('Report_HE.csv', 'HeaderLines',1);

for i = 1:size(T,2)
    T{1,i} = round(T{1,i},3);
end
T.Properties.VariableNames = varNames;

table2latex(T, 'Report_HE',...
    'Resultados del impulso para la transferencia heliocéntrica',...
    'Report_HE')


% Orbita heliocentrica
orbit = table2array(readtable('Report_HE_Orbit.csv', 'HeaderLines',1));
orbit(824:end,:) = [];
h = figure();
    hold on
    plot3(orbit(:,1),orbit(:,2),orbit(:,3),'k','LineWidth',1,'DisplayName','Trayectoria') 
    scatter3(orbit(1,1),orbit(1,2),orbit(1,3), 75, [0,153,51]/255,'filled','DisplayName','Tierra (dia 1)') 
    scatter3(orbit(end,1),orbit(end,2),orbit(end,3), 100, [204,102,0]/255,'filled','DisplayName','Jupiter SOI (dia 815)') 
    scatter3(0, 0, 0, 150, [255, 224, 102]/255,'filled','DisplayName','Sol') 
    box on; grid on;
    legend('Interpreter', 'Latex')
    title('\textit{\textbf{Trayectoria heliocentrica: Tierra a Jupiter}}',...
          'Interpreter','latex', 'FontSize', 14)          
    Save_as_PDF(h, 'Trayectoria_HE')