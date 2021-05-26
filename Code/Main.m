clear
close all
clc

%% LTFAT

% PouûÌvame toolbox LTFAT hlavne na anal˝zu a syntÈzu sign·lu pomocou 
% DiskrÈtnej Gaborovej transform·cie (DGT) a inverznej DGT (IDGT).
% Taktieû na vykreslenie spektrogramu.
% 
% Toolbox je voæne dostupn˝ z https://ltfat.github.io/
%
% Pre spr·vne fungovanie balÌËku je potrebnÈ ho maù v adres·ri so skriptom
% alebo pridaù pomocou addpath. SamotnÈ spustenie balÌËku zaisùuje prÌkaz
% ltfatstart;

addpath('ltfat')
ltfatstart;

%% PEMO-Q

% kniznica na spustenie audioqual.p pre vypocet ODG

addpath(genpath('PemoQ'))

%% Paramatre

params=struct(  'w',zeros(1),...
                'a',zeros(1),...
                'M',zeros(1),...
                'NofITE',zeros(1),...
                'tau', zeros(1),...
                'sigma',zeros(1),...
                'gamma',zeros(1));

%% TFA Gaborova transformacia

%    Parametre :
%       - tvar okna (napr. 'gauss','hann'...),
%       - dÂûka okna w,
%       - posun okien a, najlepöie nejak˝ zlomok w, napr. w/2, w/4,
%       - dÂûka FFT pre kaûdÈ okno M.

params.w = 8192;
params.a = params.w/4;
params.M = 8192;

F=frame('dgt',{'hann',params.w},params.a,params.M);
Ft=frametight(F);


%% NaËÌtanie sign·lov
% Realne signaly 
RS=load('EBU_SQAM.mat');
realsigs = { 
        'a08_violin',...
        'a16_clarinet',...
        'a18_bassoon',...
        'a25_harp',...
        'a35_glockenspiel',...
        'a41_celesta',...
        'a42_accordion',...
        'a58_guitar_sarasate',...
        'a60_piano_schubert',...
        'a66_wind_ensemble_stravinsky' };
 realsignals=zeros(RS.fs,numel(realsigs));
for q=1:10
    realsignals(1:RS.fs*1.5,q)=RS.(realsigs{q})(RS.fs+1:2.5*RS.fs);
end 
% Syntezovane signaly
synthsigs=synthsignals(numel(realsignals(:,1)),RS.fs,400);
matrixofsignals=[synthsigs realsignals];
[~,Nofsignals]=size(matrixofsignals);

% Normalizacia 

for s=1:15
    matrixofsignals(:,s)=matrixofsignals(:,s)./max(abs(matrixofsignals(:,s)));
end

% Vytvorenie fade in a fade out, aby bol plynuly nabeh a nepuklo to v
% zaciatku 
fadelength=6000;
fadein=linspace(0,1,fadelength)';
fadeout=flipud(fadein);
matrixofsignalsfade=matrixofsignals;
matrixofsignalsfade(1:fadelength,:)=matrixofsignals(1:fadelength,:).*fadein;
matrixofsignalsfade(end-fadelength+1:end,:)=matrixofsignals(end-fadelength+1:end,:).*fadeout;


matrixofsignalsfadeDR=matrixofsignalsfade;
matrixofsignalsfadeCP=matrixofsignalsfade;

%% V˝ber V·h
% Nazvy vahovych vektorov vo funkcii weights.m
wghtstr={
        'none',...
        'ath1',...
        'ath2',...
        'ath3',...
        'a-weighted',...
        'b-weighted',...
        'c-weighted',...
        };

%% V˝ber algoritmu

% Preddefinovanie premennych na ukladanie vysledkov
results=struct('sdrDR',zeros(Nofsignals,10),...
    'sdrCP',zeros(Nofsignals,10),...
    'odgDR',zeros(Nofsignals,10),...
    'odgCP',zeros(Nofsignals,10));


resultsDR = cell(numel(wghtstr),10);
resultsCP = cell(numel(wghtstr),10);

%Nastavenie DRA
params.gamma=0.1;

%Nastavenie CPA
params.sigma=0.5;
params.tau=0.5;

% Pocet iteracii rovnaky pri vsetkych algoritmoch 
params.NofITE=700;     
            
for o=1:7          % weights 1:7

% ulozenie nazvu vahovania
results(o).weights=wghtstr{o};  

% funkcie DouglasRachford a Chambolle pock su samotnym vystupom 
% rekonstrukcnych algoritmov  
% VYSTUP:
% vysledok signalu v casovo-amp oblasti,
% priebeh l-1 normy  ucel. funkcie vo vztahu k poctu iteracii,
% relativna zmena riesenia(l-2 norma)



    for i=1:10                     % Gaps 5:5:50
        gaplength=5*i;
        [shortsigzeros,shortsigorigin,gap]=gapmaker(matrixofsignals,RS.fs,params.w,gaplength,Ft);
        testanalysis=frana(Ft,shortsigorigin(:,1));
        weightvec=weights(testanalysis,params.M,RS.fs,wghtstr{o});
        for u=1:15                % Signals 1:15
        fprintf('Prebieha DR algoritmus pre %d. signal s dierou %d ms, v·hov˝ vektor: %s \n',u,gaplength,wghtstr{o})
        [DRvysledok,normCDR,diffDR]=DouglasRachford(shortsigzeros(:,u),params.NofITE,params.gamma,Ft,gap,weightvec);
        fprintf('Prebieha CP algoritmus pre %d. signal s dierou %d ms, v·hov˝ vektor: %s \n',u,gaplength,wghtstr{o})
        [CPvysledok,normXCP,diffCP]=ChambollePock(shortsigzeros(:,u),params.NofITE,params.sigma,params.tau,Ft,gap,weightvec);

        %% SNR a PEMO-Q
        results(o).sdrDR(u,i)=SDR(shortsigorigin(:,u),DRvysledok,gap);
        results(o).sdrCP(u,i)=SDR(shortsigorigin(:,u),CPvysledok,gap);
        [~,~,results(o).odgDR(u,i),~]=audioqual(shortsigorigin(:,u),DRvysledok,RS.fs);
        [~,~,results(o).odgCP(u,i),~]=audioqual(shortsigorigin(:,u),CPvysledok,RS.fs);
        
        % Prepisanie vysledku algoritmu do dlhsej vzorky na vypocutie s
        % fadeom
        matrixofsignalsfadeDR(2*params.w+1:5*params.w,u)=DRvysledok;
        matrixofsignalsfadeCP(2*params.w+1:5*params.w,u)=CPvysledok;
        end
        
        % Ulozenie vsetkych signalov pre prave jednu "dieru" a prave jeden
        % vektor
        resultsDR{o,i}=matrixofsignalsfadeDR;
        resultsCP{o,i}=matrixofsignalsfadeCP;
        
        % Prepisanie na povodne vzorky s fadom
        matrixofsignalsfadeDR=matrixofsignalsfade;
        matrixofsignalsfadeCP=matrixofsignalsfade;
    end

end

% odkomentovat/zakomentovat podla potreby ukladania 
save('results.mat','results','params');
save('DRsignals.mat','resultsDR','params');
save('CPsignals.mat','resultsCP','params');

fprintf('Algoritmy uspesne ukoncene.\n');
