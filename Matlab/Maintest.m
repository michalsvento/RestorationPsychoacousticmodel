%% Main test file

close all
clear
clc

% Pouívame toolbox LTFAT na vykreslenie spektrogramov
% 
% Toolbox je vo¾ne dostupnı z https://ltfat.github.io/
%
% Pre správne fungovanie balíèku je potrebné ho ma v adresári so skriptom
% alebo prida pomocou addpath. Samotné spustenie balíèku zaisuje príkaz
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