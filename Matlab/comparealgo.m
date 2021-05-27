function resultsmean=comparealgo(results)

%% Compare algorithms

% Tato funkcia vytvori strukturu priemernych hodnot parametrov SDR a ODG 
% pre oba algoritmy. Prvy riadok v results mean su signaly synteticke a
% druhy signaly realne, struktura ma rovnake clenenie ako results

close all
clc



% priemer syntetizovane signaly

% Preddefinovanie premennych na ukladanie vysledkov
resultsmean=struct('sdrDR',zeros(2,10),...
    'sdrCP',zeros(2,10),...
    'odgDR',zeros(2,10),...
    'odgCP',zeros(2,10));

for i=1:7
        resultsmean(i).sdrDR(1,:)= mean(results(i).sdrDR(1:5,:),1);
        resultsmean(i).sdrDR(2,:)= mean(results(i).sdrDR(6:15,:),1);
       
        resultsmean(i).odgDR(1,:)= mean(results(i).odgDR(1:5,:),1);
        resultsmean(i).odgDR(2,:)= mean(results(i).odgDR(6:15,:),1);
        
        resultsmean(i).sdrCP(1,:)= mean(results(i).sdrCP(1:5,:),1);
        resultsmean(i).sdrCP(2,:)= mean(results(i).sdrCP(6:15,:),1);
        
        resultsmean(i).odgCP(1,:)= mean(results(i).odgCP(1:5,:),1);
        resultsmean(i).odgCP(2,:)= mean(results(i).odgCP(6:15,:),1);
end

% Zakomentovat/odkomentovat pre pripadne ukladanie vysledkov
save('data/resultsmean.mat','resultsmean');

end