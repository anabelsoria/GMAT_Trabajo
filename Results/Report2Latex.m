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
    
    case 4
        disp('Maniobra cambio de inclinacion')
        
        % Cargar datos: [x, y, z, t]
        x_E_SOI = load('Reports/Report_X_SOI_Earth.dat');
        x_MCI = load('Reports/Report_X_MCI_Sun.dat');
        x_J_SOI = load('Reports/Report_X_MCI_Jupiter.dat');
        
        orbita_MCI_Sol = load('Reports/Report_SOIE_MCI_SOIJ_Sun.dat');
        %orbita_MCI_Sol = orbita_MCI_Sol(find(orbita_MCI_Sol(:,4)==x_E_SOI(end,end)):end,1:4);
        
        xE = orbita_MCI_Sol(1,:);
        xEsoi = orbita_MCI_Sol(orbita_MCI_Sol(:,4)==x_E_SOI(end,end),1:3);
        xMCI = orbita_MCI_Sol(orbita_MCI_Sol(:,4)==x_MCI(end,end),1:3);
        xJsoi = orbita_MCI_Sol(orbita_MCI_Sol(:,4)==x_J_SOI(end,end),1:3);
        xFinal = orbita_MCI_Sol(end,1:3);
        
        h = figure();
            hold on
            plot3(orbita_MCI_Sol(:,1),orbita_MCI_Sol(:,2),orbita_MCI_Sol(:,3),'k','LineWidth',1,'DisplayName','Trayectoria')
            
            scatter3(0, 0, 0, 150, [255, 224, 102]/255,'filled','DisplayName','Sol') 
            
            scatter3(xE(1,1),xE(1,2),xE(1,3), 40, [0,153,51]/255,'filled','DisplayName','Tierra') 
            scatter3(xEsoi(1,1),xEsoi(1,2),xEsoi(1,3),1e2,'+','LineWidth',2, ...
            'MarkerEdgeColor',[0,153,51]/255,'DisplayName','Salida SOI Tierra') 
        
            scatter3(xMCI(1,1),xMCI(1,2),xMCI(1,3),50,[.5 0 .5],'filled','DisplayName','Maniobra') 
            
            scatter3(xJsoi(1,1),xJsoi(1,2),xJsoi(1,3),1e2,'+','LineWidth',2,...
                'MarkerEdgeColor',[204,102,0]/255,'DisplayName','Entrada SOI Jupiter')
            scatter3(xFinal(1,1),xFinal(1,2),xFinal(1,3), 40, [204,102,0]/255,'filled','DisplayName','Perigeo orbita final') 
            legend()
            
            box on; grid on;
            legend('Interpreter', 'Latex')
            title('\textbf{\textit{Trayectoria} [km]}',...
                  'Interpreter','latex', 'FontSize', 14)          
            Save_as_PDF(h, 'Figuras/MCI')
            
            
    case 5
        disp('Maniobra cambio de inclinacion')
        
        opcion = 'OF_e-06_hp-600';
        
        % Cargar datos: [x, y, z, t]
        x_E_SOI = load(['Reports/O_Final/' opcion '_X_SOI_Earth.dat']);
        x_MCI = load(['Reports/O_Final/' opcion '_X_MCI_Sun.dat']);
        x_J_SOI = load(['Reports/O_Final/' opcion '_X_MCI_Jupiter.dat']);
        
        % vx, vy, vz [Jup], x [sol], x [Jup] 
        v_Final = load(['Reports/O_Final/' opcion '_V_Hiper_Perig.dat']);
        
        orbita_MCI_Jupiter = load(['Reports/O_Final/' opcion '_Trayectoria.dat']);
        
        idx_JSOI = find(orbita_MCI_Jupiter(:,4) == x_J_SOI(end,end));
        orbita_MCI_Jupiter(1:idx_JSOI,:) = [];
        
        idx_FO = find(orbita_MCI_Jupiter(:,1) == v_Final(end));
        
        orbita_JSOI = orbita_MCI_Jupiter(idx_FO-15:idx_FO,1:3);
        orbita_FO = orbita_MCI_Jupiter(idx_FO:end,1:3);

        h = figure();
        hold on; axis equal; box on; grid on;
        plot3(orbita_JSOI(:,1),orbita_JSOI(:,2),orbita_JSOI(:,3),'LineWidth',1.5,'DisplayName','Trayectoria entrada')
        plot3(orbita_FO(:,1),orbita_FO(:,2),orbita_FO(:,3),'k','LineWidth',1.5,'DisplayName','Trayectoria Final')
        scatter3(0,0,0, 10000, [204,78,1]/255,'filled','DisplayName','Jupiter') 
        box on; grid on; axis equal
        
        legend('Interpreter', 'Latex')
        title('\textbf{\textit{Orbita final: e = 0.6, hp = 600} [km]}',...
              'Interpreter','latex', 'FontSize', 14)          
        Save_as_PDF(h, 'Figuras/OF_e-06_hp-600')
        
        
    case 6
        disp('Fly-By')
        
        opcion = 'FlyBy_hp-1500';
        
        orbita = load(['Reports/O_Final/' opcion '_Trayectoria.dat']);
        v_Final = load(['Reports/O_Final/' opcion '_V_Hiper_Perig.dat']);
        
        idx_FO = find(orbita(:,1) == v_Final(end));
        orbita_ent = orbita(idx_FO-50:idx_FO,:);
        orbita_FB = orbita(idx_FO:end,:);
        
        
        h = figure();
            hold on; axis equal; box on; grid on;
            plot3(orbita_ent(:,1),orbita_ent(:,2),orbita_ent(:,3),'LineWidth',1.5,'DisplayName','Trayectoria entrada')
            plot3(orbita_FB(:,1),orbita_FB(:,2),orbita_FB(:,3),'k','LineWidth',1.5,'DisplayName','Fly By')
            scatter3(0,0,0, 100, [204,78,1]/255,'filled','DisplayName','Jupiter') 
            legend('Interpreter', 'Latex')
            title('\textbf{\textit{Fly By: hp = 1500} [km]}',...
                  'Interpreter','latex', 'FontSize', 14)          
            Save_as_PDF(h, 'Figuras/FlyBy_hp-1500')


    case 7
        disp('Evolucion altura')
        
        rJ = 71492;
        
        altura = load(['Reports/Evolucion_Altura/Evolucion_Altura_h-600_e-06.dat']) - rJ;
        tiempo = linspace(0,2*24,length(altura));
        
        [max_, max_idx] = max(altura);
        [min_, min_idx] = min(altura);

        h = figure();
            hold on
            plot(tiempo,altura','LineWidth',1.5,'DisplayName','Altura')
            plot([0,50], [max_,max_],'k','LineWidth',1,'DisplayName',['Apogeo = ' num2str(round(max_))])
            plot([0,50], [min_,min_],'r','LineWidth',1,'DisplayName',['Perigeo = ' num2str(round(min_))])
            box on; grid on;
            legend('Interpreter','latex')
            xlabel('\textit{tiempo} [horas]','Interpreter','latex')
            ylabel('\textit{Altura} [km]','Interpreter','latex')
            title('\textit{\textbf{Evolucion altura: h = 600, e = 0.6}}',...
                  'Interpreter','latex', 'FontSize', 14)          
            Save_as_PDF(h, 'Figuras\Evolucion_Altura_R-600_e-06')
            
            
        altura = load(['Reports/Evolucion_Altura/Evolucion_Altura_h-1500_e-06.dat']) - rJ;
        tiempo = linspace(0,2*24,length(altura));
        
        [max_, max_idx] = max(altura);
        [min_, min_idx] = min(altura);

        h = figure();
            hold on
            plot(tiempo,altura','LineWidth',1.5,'DisplayName','Altura')
            plot([0,50], [max_,max_],'k','LineWidth',1,'DisplayName',['Apogeo = ' num2str(round(max_))])
            plot([0,50], [min_,min_],'r','LineWidth',1,'DisplayName',['Perigeo = ' num2str(round(min_))])
            box on; grid on;
            legend('Interpreter','latex')
            xlabel('\textit{tiempo} [horas]','Interpreter','latex')
            ylabel('\textit{Altura} [km]','Interpreter','latex')
            title('\textit{\textbf{Evolucion altura: h = 1500, e = 0.6}}',...
                  'Interpreter','latex', 'FontSize', 14)          
            Save_as_PDF(h, 'Figuras\Evolucion_Altura_R-1500_e-06')

            
    case 8
        disp('Accesos')
        
        % Aparcamiento
        accesos = readtable('Reports/ContactosTierra.csv', 'HeaderLines',1);
        accesos = accesos(2:end-2,end);
        resumen = summary(accesos);
        
        datos = table2array(accesos);
        h = figure();
            plot(datos,'LineWidth',1.5,'DisplayName','h = 1500, e = 0.6')
            xlabel('\textit{tiempo} [dias]','Interpreter','latex')
            ylabel('\textit{tiempo de acceso} [s]','Interpreter','latex')
            title('\textit{\textbf{Tiempo de acceso diario durante un a\~ no}}',...
                  'Interpreter','latex', 'FontSize', 14)          
            legend('Interpreter','latex')
            Save_as_PDF(h, 'Figuras/Accesos')
            
        % Export table
        varNames = {'$h_p$ [km]', '$e$', '$Minimo$ [s]', '$Maximo$ [s]', '$Media$ [s]'};
        T = table(1500, 0.6, resumen.Var9.Min, resumen.Var9.Median, resumen.Var9.Max);

        T.Properties.VariableNames = varNames;

        table2latex(T, 'Tablas\Accesos',...
            'Accesos',...
            'accesos')
        
        
        %{
        h = histogram(datos,20); % Histogram
        N = max(h.Values); % Maximum bin count
        mu3 = mean(datos); % Data mean
        sigma3 = std(datos); % Data standard deviation

        h = figure();
            plot([mu3 mu3],[0 N],'r','LineWidth',2) % Mean
            X = repmat(mu3+(1:2)*sigma3,2,1);
            Y = repmat([0;N],1,2);
            plot(X,Y,'Color',[255 153 51]./255,'LineWidth',2) % Standard deviations
            legend('Data','Mean','Stds')
            hold off
                    outliers = (datos - mu3) > 2*sigma3;
        datosm = datos; % Copy c3 to c3m
        %datosm(outliers) = NaN; % Add NaN values
        %}
            

        

            
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