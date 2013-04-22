function mig_graphs(switcher,varargin)

%% Farben definieren

switch switcher
    %% Input data plots
    
    
    
    case 'SingleLine'
        %% Frequency Plot
        % mig_graphs('SingleLine',abs(fdata(1:length(faxis)))/max(abs(fdata(1:length(faxis)))),faxis,'Frequencz [Hz]','Normalized Amplitude','freq.png')
        % Migration result
        % mig_graphs('SingleLine',abs(migdata(1:length(faxis)))/max(abs(migdata(1:length(faxis)))),faxis,'Frequencz [Hz]','Normalized Amplitude','freq_mig.png')
        % max amplitude of each CMP in migrated section
        % mig_graphs('SingleLine',max(abs(mig(:,:)),((1:ns)-1)*dcmp,'CMP','Maximum Amplitude','migamp.png')
        figure
        plot(varargin{2},varargin{1},'k');
        xlabel(varargin{3},'Fontsize',24);
        ylabel(varargin{4},'Fontsize',24);
        %title('Frequency analysis','Fontsize',24)
        
        
        
        
        
    case 'CompLine'
        % mig_graphs('CompLine',name1,input1,name2,input2,axis,xaxis,yaxis,output)
        % Input signal normalized
        % Input1: mig_graphs('CompLine','Filtered data',filtdata(:,51,1)/max(filtdata(:,51,1)),'Original data',data(:,51,1)/max(data(:,51,1)),((1:nt)-1)*dcmp,'Zeit [s]','Normalisierte Amplitude','waveletnorm')
        % Input signal not normalized
        % Input2: mig_graphs('CompLine','Filtered data',filtdata(:,51,1),'Original data',data(:,51,1),((1:nt)-1)*dcmp,'Zeit [s]','Amplitude','waveletorig')
        % Frequency Comparison
        % Input3: mig_graphs('CompLine','Original data',abs(fdata(1:length(faxis)))/max(abs(fdata(1:length(faxis)))),((1:nt)-1)*dcmp,'Migrated data',abs(migdata(1:length(faxis)))/max(abs(migdata(1:length(faxis)))),faxis,'Frequency [Hz]','Normalized Amplitude','freq_comp')
        %% SNR
        % Plot trace 51 normalized
        % Input4: mig_graphs('CompLine','SNR Input',filtdata(:,51,1)/max(filtdata(:,51,1)),'SNR Migriert',mig(:,51)/max(mig(:,51)),((1:nt)-1)*dt,'Zeit [s]','Normalized Amplitude','SNRnorm')
        % Plot trace 51 not normalized
        % Input4: mig_graphs('CompLine','SNR Input',filtdata(:,51,1),'SNR Migriert',mig(:,51),((1:nt)-1)*dt,'Zeit [s]','Amplitude','SNRreal')
        %% Ergebnis Plots
        % Input signal normalized
        % Input4: mig_graphs('CompLine','Original Data',data(:,51,1)/max(data(:,51,1)),'Filtered Data',filtdata(:,51,1)/max(filtdata(:,51,1)),((1:nt)-1)*dt,'Zeit [s]','Normalized Amplitude','inoutNorm')
        % Input signal not normalized
        % Input4: mig_graphs('CompLine','Original Data',data(:,51,1),'Filtered Data',filtdata(:,51,1),((1:nt)-1)*dt,'Zeit [s]','Amplitude','inout')
        % Comparison results normalized
        % Input4: mig_graphs('CompLine','Original Data',data(:,51,1)/max(data(:,51,1)),'Migrated Data',mig(:,51,1)/max(mig(:,51,1)),((1:nt)-1)*dt,'Zeit [s]','Normalized Amplitude','waveletNorm')
        % Comparison results not normalized
        % Input4: mig_graphs('CompLine','Original Data',data(:,51,1),'Migrated Data',mig(:,51,1),((1:nt)-1)*dt,'Zeit [s]','Amplitude','wavelet')
        figure
        hold on
        plot(varagin{2},varagin{1},'r')
        plot(varagin{4},varagin{2},'k')
        ylabel(varargin{6},'Fontsize',24)
        xlabel(varargin{5},'Fontsize',24)
        legend(varargin{1},varargin{3},'Location','NorthWest')
        
    case 'OffsetLine'
        % Compare max amplitudes of each CMP in original data
        % Input1: mig_graphs('OffsetLine',data,((1:ns)-1)*dcmp,'ampsorig')
        % Compare max amplitudes of each CMP in original data
        % Input2: mig_graphs('OffsetLine',filtdata,((1:ns)-1)*dcmp,'ampsfilt')
        % Compare max amplitude in each CMP in COG
        % Input3: mig_graphs('OffsetLine',COG,((1:ns)-1)*dcmp,sprintf('ampsv%g',v))
        data = varagin{1};
        [nt,ns,nh] = size(data);
        farbe = rand(nh,3);
        farbe(:,1)=sort(farbe(:,1));
        farbe(:,2)=sort(farbe(:,2),'Descend');
        
        figure
        hold on
        for k=1:nh
            plot(varagin{2},max(abs(data(:,:,k)),[],1),'Color',farbe(k,:))
        end
        xlabel('CMP','Fontsize',24)
        ylabel('Maximum amplitude','Fontsize',24)
        legend('h = 0','h = 250','h = 500','h = 750','h = 1000','Location','best')
        
        
        
        
        
        
    case 'COG'
        %% CO-Gather for each velocity
        % mig_graphs('COG',COG(:,:),((1:ns*nh)-1)*dcmp,z,'Depth [km]',sprintf('COGv%g',v))
        figure
        imagesc(varargin{2},varargin{3},varargin{1},[-max(max(max(abs(varargin{1})))) +max(max(max(abs(varargin{1}))))])
        %title('Tiefenmigration','Fontsize',24)
        xlabel('CMP [km]','Fontsize',24)
        ylabel(varargin{4},'Fontsize',24)
        
        colormap([ones(101,1),(0:.01:1)',(0:.01:1)';(1:-.01:0)',(1:-.01:0)',ones(101,1)])    % polarized plot
        colorbar
        
        set(gca,'XTickLabel',{' 0 ','2 / 0','2 / 0','2 / 0','2 / 0',' 2 '})                  % reskaling x-axis
        
        
    case 'PolarPlot'
        %% Plot of the migration result
        % mig_graphs('PolarPlot',mig(:,:),((1:ns)-1)*dcmp/1000,z,'CMP [km]','Depth [km]',sprintf('vm%g',v))
        %% Plot of the migration result
        % mig_graphs('PolarPlot',mig(:,:),((1:ns)-1)*dcmp/1000,z/1000,'CMP [km]','Depth [km]',sprintf('sum_vm%g',v))
        figure
        imagesc(varargin{2},varargin{3},varargin{1},[-max(max(max(abs(varargin{1})))) +max(max(max(abs(varargin{1}))))])
        %title('Tiefenmigration','Fontsize',24)
        xlabel(varargin{4},'Fontsize',24)
        ylabel(varargin{5},'Fontsize',24)
        colormap([ones(101,1),(0:.01:1)',(0:.01:1)';(1:-.01:0)',(1:-.01:0)',ones(101,1)])
        colorbar
        
        
    otherwise
        warndlg('Please choose valid Graph option')
end
%%% Für alte traceplots müsste zurück interpoliert werden, da
%%% length(z) != length(t) und length(z) hängt von v ab, siehe
%%% t_depth=t_orig*v*0.5;
%%% zmax = max(t_depth);     % zmax nimmt mit steigendem v zu, aber
%%% z=0:dz:zmax;             % dz bleibt gleich !

set(gca,'Fontsize',24)
fileoutput=sprintf('%s/output/%s.png',pwd,varargin{end})
print('-dpng',fileoutput);
