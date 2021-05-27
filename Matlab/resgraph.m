function resgraph(signalNo,algorithmstring,results)

% Inputs
    %signalNo - poradove cislo signalu
    % algorithmstring - string nazvu algoritmu
                            % 'DRA' -pre Douglasov-Rachfordov alg.
                            % 'CPA' -pre Chambollov-Pockov alg.
                            
    % results - premenna results/results mean, ako vysledky ktore maju byt
    % vykreslene
    
% Fungovanie funkcie

% Po zadani vstupov sa zobrazia 2 grafy vlavo priebeh SDR v zavislosti na
% dlzke diery pre vsetky vahove vektory (celkovo 7 priebehov v grafe);
% vpravo sa zobrazi priebeh ODG na dlzke diery( takisto 7 priebehov), ako
% vstup sa mozu pouzit aj spriemerovane hodnoty, len nebude sediet nadpis,
% ktory je vytvoreny pre jednotlive signaly.

close all;
wghtstr={
        'z-weighted(none)',...
        'ath1',...
        'ath2',...
        'ath3',...
        'a-weighted',...
        'b-weighted',...
        'c-weighted',...
        };

all_marks = {'o','+','*','square','x','v','diamond'};

if strcmp(algorithmstring,'DRA')
    % SDR
    subplot(1,2,1)
    sgtitle('DRA syntetizované signály')
    for i=1:7
        grid on
        hold on 
        plot(5:5:50,results(i).sdrDR(signalNo,:),'Marker',all_marks{i})
    end
    xlim([5 50])
    xlabel('Diera (ms)')
    ylabel('SDR (dB)')
    legend(wghtstr,'Location','northeast')
    
    % ODG
    subplot(1,2,2)
    for i=1:7
        grid on
        hold on
        plot(5:5:50,results(i).odgDR(signalNo,:),'Marker',all_marks{i})
    end
    xlim([5 50])
    xlabel('Diera (ms)')
    ylabel('PEMO-Q ODG (-)')
    legend(wghtstr,'Location','southwest')
    %title(['ODG DRA, signál è.',num2str(signalNo)])
    
elseif strcmp(algorithmstring,'CPA')

    % SDR
    subplot(1,2,1)
    sgtitle('CPA syntetizované signály')
    for i=1:7
        grid on
        hold on
        plot(5:5:50,results(i).sdrCP(signalNo,:),'Marker',all_marks{i})
    end
    xlim([5 50])
    xlabel('Diera (ms)')
    ylabel('SDR (dB)')
    legend(wghtstr,'Location','northeast')
    
    % ODG
    subplot(1,2,2)
    for i=1:7
        grid on
        hold on
        plot(5:5:50,results(i).odgCP(signalNo,:),'Marker',all_marks{i})
    end
    xlim([5 50])
    xlabel('Diera (ms)')
    ylabel('PEMO-Q ODG (-)')
    legend(wghtstr,'Location','southwest')
    
end

end