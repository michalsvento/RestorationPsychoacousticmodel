function [reconstructed,l1normxi,l2relative]= ChambollePock(inputsignal,NofITE,sigma,tau,Ft,gap,weights)

%% Chambolle-Pock algoritmus CPA
%% Algoritmus
% Input
    % inputsignal - poskodeny signal, ktory sa bude rekonstruvoat
    % NofITE - poèet iteracii
    % Sigma,Tau - parametre algoritmu
    % Ft - Parsevalovsky tesny frame
    % gap - vektor suradnic pociatku a konca diery
    % weights - vahovy vektor
    
% Output
    % reconstructed - zrekonstruovany signal po poslednej iteracii
    % l1normxi - vyvoj hodnoty l1 normy s poctom iteracii
    % l2relative - relativna zmena riesenia s poctom iteracii

coefvector=frana(Ft,inputsignal);
l1normxi=zeros(NofITE,1);   %L1norm ucel. fce- definicia vektora
l2relative=zeros(NofITE,1); %L1norm relativna zmena- definicia vektora
p=inputsignal; %koeficienty v èasovej oblasti
x=p;       %koeficienty v èasovej oblasti
q=coefvector; %koeficienty v frekvenènej oblasti

for i=1:NofITE
q=clip(q+sigma*frana(Ft,p),weights);          %krok 1 alfa=1
qsynth=frsyn(Ft,q);
qsynth=real(qsynth);   
xi=projection(x-tau*qsynth,inputsignal,gap);    %krok 2. xi=x(n+1)
p=2*xi-x;  

% l1 norma analyzy xi
xianalys=frana(Ft,xi);
l1normxi(i)=norm(xianalys,1);


%Relativna zmena s poctom iterácií
l2relative(i)=norm(xi-x)/norm(x);   %Q: xi-x alebo x-xi


x=xi;       %v dalsej iteracii na mieste x(n) uz musi byt x(n+1) teda'xi'
            %preto dve premenne pre x    
                                  
end

reconstructed=projection(x,inputsignal,gap); %zaistenie reliable vzoriek po poslednej Ite

%% Funkcie

%% Projekcia na mnozinu 
function projn = projection(input,reliable,gap)
    
    output=input;
    output(1:gap(1)-1)= reliable(1:gap(1)-1);        %Reliable po zaciatok "diery"   
    output(gap(2)+1: end)= reliable(gap(2)+1: end);    %Reliable od konca "diery"
    projn=output;
   
end

%% Clip
function Calfa=clip(x,weights)

    Calfa=sign(x).*min(weights,abs(x));

end

end
