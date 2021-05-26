function vectorweights = weights(GaborCoefs,freqChannels,Fs,stringweights)

%WEIGHTS 
% INPUTS
    % GaborCoefs - pocet gaborovych koeficientov - vysledny vektor bude mat
    % rovnaku velkost
    % freqChannels - pocet frekvencnych kanalov
    % Fs - vzorkovacia frekvencia
    % stringweights - String podla vah, ktore chceme zvolit:
                % 'none' 
                % 'ath1'
                % 'ath2'
                % 'ath3'
                % 'a-weighted'
                % 'b-weighted'
                % 'c-weighted'


% OUTPUTS
    % vectorweights - vahovy vektor pozadovanej dlzky

tau=100;
df=Fs/freqChannels;
f=0:df:Fs/2;


t=3.64*(0.001*f).^(-0.8)-6.5.*exp(-0.6*((0.001.*f-3.3).^2))+0.001.*((0.001*f).^4);
t(t>tau)=tau;

if strcmp(stringweights,'none')
    wath=ones(1,freqChannels./2+1);
elseif strcmp(stringweights,'ath1')
    wath=1./(t-min(t)+1);
    wath=wath/max(wath);
elseif strcmp(stringweights,'ath2')
    wath=-t+tau;
    wath=wath/max(wath);
elseif strcmp(stringweights,'ath3')
    wath=0.00002*10.^((-t+tau)/20);
    wath=wath/max(wath);
elseif strcmp(stringweights,'a-weighted')
    r= (12194.^2.*f.^4)./((f.^2+720).*sqrt((f.^2+5243).*(f.^2+59697)).*(f.^2+12194.^2));
    wath=r./max(r);
elseif strcmp(stringweights,'b-weighted')
    r= ((12194.^2).*(f.^3))./((f.^2+720).*sqrt((f.^2+3950)).*(f.^2+12194.^2));
    wath=r./max(r);
elseif strcmp(stringweights,'c-weighted')
    r= ((12194.^2).*(f.^2))./((f.^2+720).*(f.^2+12194.^2));
    wath=r./max(r);
end



vweights=size(GaborCoefs);
NoChannels = numel(GaborCoefs)/freqChannels;
borders=[1,freqChannels];

wathflip=fliplr(wath);

wath=[wath(1:end-1) , wathflip(1: end-1)];

for i = 1 : NoChannels
    vweights(borders(1):borders(2))=wath;   
    borders=borders + freqChannels;
end

vectorweights=vweights';

end

