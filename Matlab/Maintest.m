%% Main test file

close all
clear
clc

% Pou��vame toolbox LTFAT na vykreslenie spektrogramov
% 
% Toolbox je vo�ne dostupn� z https://ltfat.github.io/
%
% Pre spr�vne fungovanie bal��ku je potrebn� ho ma� v adres�ri so skriptom
% alebo prida� pomocou addpath. Samotn� spustenie bal��ku zais�uje pr�kaz
% ltfatstart;
addpath('ltfat')
ltfatstart;

% Nacitanie vysledkov a signalov
load('data/results.mat')
load('data/DRsignals.mat')
load('data/CPsignals.mat')

% load('resultsmean.mat')
% ak nie je este resultsmean vytvoreny 
resultsmean=comparealgo(results);

% Vsetky potrebne subory su nacitane, pomocou CommandWindow volame funkcie
% soundspectro alebo resgraph podla toho co chceme zobrazit. Vstupy su v
% napovedach funkcii