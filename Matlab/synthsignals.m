function matrixofsignals = synthsignals(length,Fs,f)

% MATLAB Signal processing toolbox required

% Inputs
    % length - dlzka signalu (rovnaka ako u realnych signalov)
    % Fs - vzorkovacia frekvencia
    % f - frekvencia fundamentu (1. zakladnej harmonickej)

% Outputs 

% Matrixofsignal - matica o rozmere length x pocet signalov
%                - kazdy riadok predstavuje jeden signal o dlzke length  

dt=1/Fs;       
t=(0:dt:dt*length-dt);
omega=2*pi*f;

%% Signals

sinus3 = sin(omega*t)+0.5*sin(omega*t/2)+0.25*sin(omega*t/4);
sinus3 = sinus3./max(sinus3);

sinusodd=sin(omega*t);
for n= 3:2:15
   sinusodd=sinusodd+1/n*sin(omega*n*t) ;
end

sinusrandom(1:numel(sinus3))=0;
rng('default');
coefs= randi([1 30],1,10);
for n = coefs
    sinusrandom=sinusrandom+1/(n^2)*sin(omega*n*t) ;
end

sqr50 = square(omega*t);


saw = sawtooth (omega*t);

matrixofsignals=[sinus3 ; sinusodd; sinusrandom; sqr50 ;saw]';

end
