%{ 
    Author:    Fahong Zhang
    Reference: S. Jia, G. Tang, J. Zhu, and Q. Li, ¡°A novel ranking-based
               clustering approach for hyperspectral band selection,¡± 
               IEEE Transactions on Geoscience and Remote Sensing, 
               vol. 54, no. 1,pp. 88¨C102, 2016.
    Function:  Rank all the bands
    Input:     D: dis-similarity matrix
               k: number of the selected bands
    Output:    band_set: the selected band indexes
               I: a L*1 vector, I(i) is the band with the ith largest rank value
               gamma: the ranking values of bands
%}

function [band_set, I, gamma] = E_FDPC(D, k)
    [L, ~] = size(D);
    Ds = sort(D(:));
    d_ini = Ds(floor(L*(L-1)*0.02) + L);
    d_c = d_ini / exp(k / L);
    rho = zeros(L, 1);
    for i = 1 : L
        for j = 1 : L
            if j == i
                continue;
            end
            rho(i) = rho(i) + exp(-(D(i, j) / d_c) * (D(i, j) / d_c));
        end
    end
    [~, I] = sort(rho, 'descend');
    delta = zeros(L, 1);
    delta(I(1)) = -1;
    for i = 2 : L
        delta(I(i)) = inf;
        for j = 1 : i-1
            if D(I(i), I(j)) < delta(I(i))
                delta(I(i)) = D(I(i), I(j));
            end
        end
    end
    delta(I(1)) = max(delta);
    rho_min = min(rho);
    rho_max = max(rho);
    delta_min = min(delta);
    delta_max = max(delta);

    rho = (rho - rho_min) / (rho_max - rho_min);
    delta = (delta - delta_min) / (delta_max - delta_min);
    gamma = rho .* (delta .* delta);
    [~, I] = sort(gamma, 'descend');
    band_set = I(1:k);
 end
    