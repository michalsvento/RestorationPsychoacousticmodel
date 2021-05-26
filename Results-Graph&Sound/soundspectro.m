function soundspectro(algorithmstring,signalidx,stringweights,gapinms,resultsDR,resultsCP,fs)

close all

% Inputs:
    % algorithmstring - nazov algoritmu 'DRA' , 'CPA'
    % signalidx - index signalu 1-15
    % stringweights - nazov vah     % 'none' 
                                    % 'ath1'
                                    % 'ath2'
                                    % 'ath3'
                                    % 'a-weighted'
                                    % 'b-weighted'
                                    % 'c-weighted'

    % resultsDR,resultsCP -korenove subory s datami signalov
    % fs - vzorkovacia frekvencia (ciselne zadat- 44100)
    % gapinms - dlzka diery v ms - zadaj v intervale 5:5:50

% Popis funkcie

% po zavolani sa zobrazi spektrogram a priebeh amplitudy zvoleneho signalu
% so zvolenym vahovym vektorom a zvolenou metodou, takisto sa prehra tento
% signal.

% Obdlznik v amplitudovom zobrazeni oznacuje miesto rekonstrukcie, kde sa
% signal opravil


if strcmp(stringweights,'none')
    wght=1;
elseif strcmp(stringweights,'ath1')
    wght=2;
elseif strcmp(stringweights,'ath2')
    wght=3;
elseif strcmp(stringweights,'ath3')
    wght=4;
elseif strcmp(stringweights,'a-weighted')
    wght=5;
elseif strcmp(stringweights,'b-weighted')
    wght=6;
elseif strcmp(stringweights,'c-weighted')
    wght=7;
end



%% spektrogram + priebeh

a = 256;
M = 1024;
w = 1024;
dynrange = 80; % krajsie vykreslenie spektrogramu

if strcmp(algorithmstring,'DRA')
    gaborcoefs=dgt(resultsDR{wght,gapinms/5}(:,signalidx),{'hann',w},a,M);

    figure
    sgtitle(['Signál è.',num2str(signalidx),', ',algorithmstring,', vektor váh: ',stringweights,', diera ',num2str(gapinms),'ms'])
    subplot(1,2,1)
    h=fill([24*w+1,24*w+round(0.001*gapinms*fs),24*w+round(0.001*gapinms*fs),24*w],[-1.1,-1.1,1.1,1.1],'cyan','LineStyle','none');
    h.FaceAlpha=0.3;
    hold on
    plot(resultsDR{wght,gapinms/5}(:,signalidx))
    xlim([0 66200])
    ylabel('Amplituda (-)')
    xlabel('Vzorky (-)')
    ylim([-1.1 1.1])



    subplot(1,2,2)
    plotdgt(gaborcoefs,a,fs,dynrange);
    ylim([0 Inf])
    xlabel('Èas (s)')
    ylabel('Frekvencia (Hz)')
    soundsc(resultsDR{wght,gapinms/5}(:,signalidx),fs)

elseif strcmp(algorithmstring,'CPA')
    gaborcoefs=dgt(resultsCP{wght,gapinms/5}(:,signalidx),{'hann',w},a,M);
    figure
    sgtitle(['Signál è.',num2str(signalidx),', ',algorithmstring,', vektor váh: ',stringweights,', diera ',num2str(gapinms),'ms'])
    subplot(1,2,1)
    h=fill([24*w+1,24*w+round(0.001*gapinms*fs),24*w+round(0.001*gapinms*fs),24*w],[-1.1,-1.1,1.1,1.1],'cyan','LineStyle','none');
    h.FaceAlpha=0.3;
    hold on
    plot(resultsDR{wght,gapinms/5}(:,signalidx))
    ylabel('Amplituda (-)')
    xlabel('Vzorky (-)')
    xlim([0 66200])
    ylim([-1.1 1.1])


    subplot(1,2,2)
    plotdgt(gaborcoefs,a,fs,dynrange);
    ylim([0 Inf])
    xlabel('Èas (s)')
    ylabel('Frekvencia (Hz)')


    soundsc(resultsCP{wght,gapinms/5}(:,signalidx),fs)
end


end