%{
    Generate latex tables with the Teport info
%}

clc
clear all
close all

n = input('Enter a case: ');

switch n
    case 1
        disp('Parkin + Insercion')
        
        % Aparcamiento
        orbit_parkin = load('Reports/Report_PO_Trajectory.dat');
        orbit_injection = load('Reports/Report_InjectionOrbit_Trajectory.dat');
        orbit_injection(1:823,:) = [];
        h = figure();
            hold on; axis equal
            view([-30,15])
            plot3(orbit_parkin(:,1),orbit_parkin(:,2),orbit_parkin(:,3),'LineWidth',1.5,'DisplayName','Aparcamiento') 
            plot3(orbit_injection(:,1),orbit_injection(:,2),orbit_injection(:,3),'LineWidth',1.5,'DisplayName','Inyeccion') 
            scatter3(0, 0, 0, 500, [0,153,51]/255,'filled','DisplayName','Tierra') 
            box on; grid on;
            legend('Interpreter', 'Latex', 'Location', 'best')
            title('\textit{\textbf{Trayectoria hiperbolica}}',...
                  'Interpreter','latex', 'FontSize', 14)          
            Save_as_PDF(h, 'Orbita_Park_Inject')
    case 2
        disp('Heliocentrica')
        
        orbit = table2array(readtable('Report_HE_Orbit.csv', 'HeaderLines',1));
        orbit(824:end,:) = [];
        s = 696340;
        h = figure();
            hold on
            plot3(orbit(:,1),orbit(:,2),orbit(:,3),'k','LineWidth',1,'DisplayName','Trayectoria') 
            scatter3(orbit(1,1),orbit(1,2),orbit(1,3), 75, [0,153,51]/255,'filled','DisplayName','Tierra (dia 1)') 
            scatter3(orbit(end,1),orbit(end,2),orbit(end,3), 100, [204,102,0]/255,'filled','DisplayName','Jupiter SOI (dia 815)') 
            scatter3(0, 0, 0, 150, [255, 224, 102]/255,'filled','DisplayName','Sol') 

            box on; grid on;
            legend('Interpreter', 'Latex')
            title('\textit{\textbf{Trayectoria heliocentrica}}',...
                  'Interpreter','latex', 'FontSize', 14)          
            Save_as_PDF(h, 'Trayectoria_HE')
        
    case 3
        disp('positive one')
    otherwise
        disp('other value')
end

% Tabla resultados impulso heliocentica
%{
varNames = {'$\Delta V$ Hohmann [km]', '$\Delta V_x$ Impulso [Hz]', '$\Delta V_y$ Impulso [Hz]', '$\Delta V_z$ Impulso [Hz]'};
T = readtable('Report_HE.csv', 'HeaderLines',1);

for i = 1:size(T,2)
    T{1,i} = round(T{1,i},3);
end
T.Properties.VariableNames = varNames;

table2latex(T, 'Report_HE',...
    'Resultados del impulso para la transferencia heliocéntrica',...
    'Report_HE')
%}

% Orbita heliocentrica
%{




% Trayectoria de salida
orbit = table2array(readtable('Report_Earth_SOI.csv', 'HeaderLines',1));
orbit(1:895,:) = [];
s = 696340;
h = figure();
    hold on
    plot3(orbit(:,1),orbit(:,2),orbit(:,3),'k','LineWidth',1,'DisplayName','Trayectoria') 
%    scatter3(orbit(1,1),orbit(1,2),orbit(1,3), 75, [0,153,51]/255,'filled','DisplayName','Tierra (dia 1)') 
%    scatter3(orbit(end,1),orbit(end,2),orbit(end,3), 100, [204,102,0]/255,'filled','DisplayName','Jupiter SOI (dia 815)') 
%    scatter3(0, 0, 0, 150, [255, 224, 102]/255,'filled','DisplayName','Sol') 
    
    box on; grid on;
    legend('Interpreter', 'Latex')
    title('\textit{\textbf{Trayectoria heliocentrica}}',...
          'Interpreter','latex', 'FontSize', 14)          
    Save_as_PDF(h, 'Trayectoria_HE')
%}