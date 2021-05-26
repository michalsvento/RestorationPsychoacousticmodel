function signaltodistortion = SDR(reference,reconstructed,gap)
% Input
    % reference- signal pred poskodenim
    % reconstructed - zrekonstruovany signal
    % gap - oblast diery, matica 2x1 [zaciatok, koniec]
    %shortened=;
% Output
    %signaltodistortion - SDR v dB
l2normreference=norm(reference(gap(1):gap(2)));
substractrecons=reference(gap(1):gap(2))-reconstructed(gap(1):gap(2));
l2normreconstruct=norm(substractrecons);

signaltodistortion= 20*log10(l2normreference/l2normreconstruct);

% Zobrazenie SDR po poslednej iterácii
fprintf('SDR výsledného signálu %1.3f \n',signaltodistortion);


end

