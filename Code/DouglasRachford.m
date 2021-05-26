
function [reconstructed,normac,l2relative]=DouglasRachford(inputsignal,NofITE,gamma,Ft,gap,vectorweights)

%% Douglas-Rachford algorithm DRA
% Inputs
    % damaged - vstupny signal algoritmu
    % Ft - tightframe - parsevalovsky tesny frame
    % gap - matica 2x1 so suradnicami pociatku a konca poskodeneho useku
    % c - Startovaci bod c(0)
    % NofITE - pocet iteracii algoritmu
    % vectorweights - vector vah s velkostou frana
% Outputs
    % reconstructed - vysledok algoritmu
    % normac - priebeh konvergujucej 
    % l2relative - relativna zmena riesenia s poctom iteracii

%% Parametre staticke (nemeniace sa v argumente funkcie)
lambda=1;       %pevne definovane na 1   

%Inicializacia premenych v algoritme
normac=zeros(NofITE,1); %norma po kazdej iteracii,jeden stpec pre gamma
l2relative=zeros(NofITE,1); %L1norm relativna zmena- definicia vektora
c=frana(Ft,inputsignal);
c0=c;


%% Algoritmus
    
for i=1: NofITE
    ci= projection(c,inputsignal,gap,Ft);
    c= c + lambda*(soft(2*ci-c,gamma,vectorweights)-ci);
    
    %vypocitat l1 normu a zobrazit v zavislosti na iteracii
    normac(i)= norm(ci(:),1);

    %Relativna zmena s poctom iterácií
    l2relative(i)=norm(c-c0)/norm(c0);   %Q: xi-x alebo x-xi
    
    c0=c;    % koeficienty 
end

% posledna projekcia c - zaisteniu Reliable vzoriek na ich poziciach
projekciaci = projection(c,inputsignal,gap,Ft);

% idgt k získaniu rek. signálu pomocou frsyn
reconstructed=frsyn(Ft,projekciaci);
reconstructed=real(reconstructed);

%% FUNKCIE
%% Projekcia na mnozinu 
function cproj = projection(coeff,reference,gap,Ft)
    
    invers= frsyn(Ft,coeff);
    projn = invers;
    projn(1:gap(1)-1)= reference(1:gap(1)-1);     %Ref po zaciatok "diery"   
    projn(gap(2)+1: end)= reference(gap(2)+1: end); %Ref od konca "diery"
     
    substract=invers-projn;
    analysissubstr= frana(Ft,substract);
    cproj = coeff - analysissubstr;

end

%% Soft thresholding
function softprahovanie = soft(coeff,gamma,vectorweights)

   softprahovanie = sign(coeff).*max(abs(coeff)- gamma*vectorweights,0);
   
end

end
