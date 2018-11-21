%{ 
    Author:    Fahong Zhang
    Reference: Q. Wang, F. Zhang, and X. Li, ¡°Optimal Clustering Framework 
               for Hyperspectral Band Selection,¡± IEEE Transactions on Geoscience 
               and Remote Sensing (T-GRS), DOI: 10.1109/TGRS.2018.2828161, 2018.
    Function:  Conduct the global optimal clustering framework
    Input:     para.X: the data set with size L * N, 
                       all the elmemnts are linearly normalized to [0, 1]
               para.F: the map f in Eq. (2), needed to be preprocessed
               para.is_maximize: indicate the objective function 
                                 shold be maximize or minimize
               para.operator_name: indicate the binary operator in Eq. (8), 
                                 can be 'sum', 'max' or 'min'
               para.bnds_rnk: the ranking values of bands, needed to be
                              preprocessed
               C: number of the selected bands

    Output:    bnds_id: a C*1 vector, the ids of the selected bands
%}
function [bands_ind, CBIV] = ocf(para, C)
    F = para.F;
    is_maximize = para.is_maximize;
    operator_name = para.operator_name;
    
    [L, ~] = size(F);
    Q = zeros(L, C);
    M = zeros(L, C);

    %% Dynamic Programming
    for i = 1 : L
        M(i, 1) = F(1, i);
    end
    for k = 2 : C
        for i = k : L
            if is_maximize == 1
                M(i, k) = -inf;
            else
                M(i, k) = inf;
            end
            for j = (k-1) : i - 1
                if is_maximize
                    if M(i, k) < metric(M(j, k-1), F(j + 1, i), operator_name)
                        M(i, k) = metric(M(j, k-1), F(j + 1, i), operator_name);
                        Q(i, k) = j;
                    end
                else 
                    if M(i, k) > metric(M(j, k-1), F(j + 1, i), operator_name)
                        M(i, k) = metric(M(j, k-1), F(j + 1, i), operator_name);
                        Q(i, k) = j;
                    end
                end
            end
        end
    end

    p = L; k = C;
    %% Achieve the critical band index vector
    CBIV = zeros(1, C);
    while true
        if Q(p, k) == 0
            break
        end
        CBIV(k-1) = Q(p, k);
        p = Q(p, k);
        k = k - 1;
    end
    CBIV(C) = L;
    
    %% Get representative bands by RCS
    bands_ind = ocf_CBIV(CBIV, para);
end

%% Binary operator in E-OCF
function val = metric(d, f, operator_name)
    switch operator_name
        case 'sum'
            val = d + f;
        case 'max'
            val = max(d, f);
        case 'min'
            val = min(d, f);
    end
end