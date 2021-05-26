function [signalswithzero, signalorigin, gap]= gapmaker(inputmatrix,Fs,w,gaplength,Ft)

% Inputs
    % inputmatrix - matica signalov,kazdy stlpec predsdtavuje jeden signal
    % Fs - vzorkovacia frekvencia
    % w - dlzka okna
    % gaplength - dlzka diery v ms
    % Ft - Parsevallov frame
% Outputs
    % signalswithzero -matica skratenych signalov s vlozenou dierou
    % signalorigin - matica skratenych signalov neposkodenych
    % gap - suradnice diery gap(1) - zlava; gap(2) - zprava

fullmatrix=inputmatrix;
nozeros=round(gaplength*0.001*Fs);
fullmatrix(3*w+1:3*w+nozeros,:)=0;

gap=[w+1,w+nozeros]; % Vektor s miestom StartMissing a EndMissing

elements=2*w+nozeros;
L=framelength(Ft,elements);

signalswithzero=fullmatrix(2*w+1:2*w+L,:); % signaly do algoritmu
signalorigin=inputmatrix(2*w+1:2*w+L,:); % signál bez poškodenia na porovnanie
end