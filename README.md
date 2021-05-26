# RestorationPsychoacousticmodel

Táto knižnica je doplnkovým zdrojom pre bakalársku prácu Michala Šventa **Restaurování chybějících vzorků zvukového signálu s použitím psychoakustického modelu**. Hlavným dôvodom je sprístupnenie súborov s reštaurovanými signálmi  `resultsDR.mat` a  `resultsCP.mat`, ktoré sú výstupom algoritmov a do prílohy by sa nezmestili.

Zložka [Code](Code) obsahuje:
* `Douglas-Rachford.m` - realizácia Douglasovho-Rachfordovho algoritmu (DRA)
* `EBU-SQAM.mat` - výber reálnych vzoriek z normy EBU.
*  `gapmaker.m` - skript na vytvorenie poškodeného úseku a skrátenie signálu pred vstupom do algoritmu
*  `ChambollePock.m` - realizácia Chambolle-Pockovho algoritmu (CPA)
*  `Main.m` - hlavný súbor na spustenie algoritmov s variáciou podmienok
*  `SDR.m` - výpočet SDR pre skrátený úsek
*  `synthsignals.m` - vytvorenie matice umelých signálov
*  `weights.m` - vytvorenie vektora váh

Zložka [Results-Graph&Sound](Results-Graph&Sound) obsahuje:
*  `Maintest.m` - skript na načítanie výsledkov a spustenie ltfat. Po spustení je možné pomocou Command Window volať funkcie `resgraph.m`  a `soundspectro.m` pre zvolenú možnosť.
*  `soundspectro.m` - funkcia vykreslenie priebehu a spektrogramu vybraného signálu a prehratie zvolenej vzorky
*  `resgraph.m` - funkcia zobrazenie priebehu SDR a PEMO-Q ODG voči dĺžke diery pre vybraný signál.
*  `comparealgo.mat` - výpočet priemerných hodnôt pre 
*  `results.mat` - výsledky SDR a ODG pre všetky variácie parametrov - každý stĺpec predstavuje jednu možnosť diery, každý riadok predstavuje jeden signál
*  `resultsmean.mat` - spriemerované výsledky z `results`, osobitne pre syntetické signály (1.riadok), osobitne pre reálne signály (2.riadok).
*  `resultsDR.mat` - signály získané DRA, každý stĺpec predstavuje jednu dieru, každý riadok jeden váhový vektor. Vnútri každej bunky, predstavuje každý riadok jeden signál.
*  `resultsCP.mat` - rovnaký význam ako u `resultsDR.mat`
