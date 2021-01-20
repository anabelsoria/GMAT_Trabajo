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
        
        % Export table
        varNames = {'$X$ [km]', '$Y$ [km]', '$Z$ [km]'};
        T = table(orbit_injection(1,1), orbit_injection(1,2), orbit_injection(1,3));

        for i = 1:size(T,2)
            T{1,i} = round(T{1,i},3);
        end
        T.Properties.VariableNames = varNames;

        table2latex(T, 'Tablas\Pto_Hiperb',...
            'Coordenada de maniobra hiperbolica',...
            'pto_h')
        
        
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
        disp('Calculo impulso orbita final')
        
        % Cargar datos: [x, y, z, vx, vy, vz]
        h_600 = load('Reports/Report_XV_Reach_Final_Orbit_h1.dat');
        x1 = h_600(1:3);    ux1 = x1/norm(x1);
        v1 = h_600(4:6);    nv1 = v1/norm(v1);
        
        h_1500 = load('Reports/Report_XV_Reach_Final_Orbit_h2.dat');
        x2 = h_1500(1:3);   ux2 = x2/norm(x2);
        v2 = h_1500(4:6);   nv2 = v2/norm(v2);
        
        % Vector h normal al plano de la orbita
        h1 = cross(ux1,nv1);% uh1 = h1/norm(h1);
        h2 = cross(ux2,nv2);% uh2 = h2/norm(h2);
        
        % vector unitario velocidad en el perigeo orbita final
        uv1 = cross(h1,ux1);
        uv2 = cross(h2,ux2);
        
        figure(1)
            hold on
            plot3([0,ux1(1)],[0,ux1(2)],[0,ux1(3)],'-o','DisplayName','r')
            plot3([ux1(1),nv1(1)],[ux1(2),nv1(2)],[ux1(3),nv1(3)],'-o','DisplayName','v')
            plot3([ux1(1),h1(1)],[ux1(2),h1(2)],[ux1(3),h1(3)],'-o','DisplayName','h')
            plot3([ux1(1),nv1(1)],[ux1(2),nv1(2)],[ux1(3),nv1(3)],'-o','DisplayName','v')
            grid on
            box on
            axis equal
            xlabel('x'); ylabel('y'); zlabel('z')
            legend()
        
        phi1 = acosd( dot(uv1,v1)/(norm(uv1)*norm(v1)) );
        
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