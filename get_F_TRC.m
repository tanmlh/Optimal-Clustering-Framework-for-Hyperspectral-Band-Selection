%{ 
    Author:    Fahong Zhang
    Reference: Q. Wang, F. Zhang, and X. Li, ¡°Optimal Clustering Framework 
               for Hyperspectral Band Selection,¡± IEEE Transactions on Geoscience 
               and Remote Sensing (T-GRS), DOI: 10.1109/TGRS.2018.2828161, 2018.
    Function:  Get a map according to Eq. (16)
    Input:     Similarity matrix: S, with size L * L,
               ranking value of bands: rnk_val, with size L * 1
    Output:    A matrix F, with size L * L, F(i, j) = f_{trc}(X_i^j)
%}

function [F] = get_F_TRC(S, rnk_val)
    [~, L] = size(S);
    F = zeros(L, L);

    for i = 1 : L
        for j = i : L
            [~, p] = max(rnk_val(i:j));
            p = p + i - 1;
            for k = 1 : L
                if k < i || k > j
                    F(i, j) = F(i, j) + S(p, k);
                end
            end
        end
    end
 end
