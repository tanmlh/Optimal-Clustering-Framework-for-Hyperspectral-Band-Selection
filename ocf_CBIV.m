%{ 
    Author:    Fahong Zhang
    Reference: Q. Wang, F. Zhang, and X. Li, ¡°Optimal Clustering Framework 
               for Hyperspectral Band Selection,¡± IEEE Transactions on Geoscience 
               and Remote Sensing (T-GRS), DOI: 10.1109/TGRS.2018.2828161, 2018.
    Function:  Conduct the global optimal clustering framework with given CBIV
    Input:     CBIV: the critical band indexes vector
               para: conveyed from function gocf
    Output:    band_set: a C*1 vector, the ids of the selected bands
%}
function [ band_set ] = ocf_CBIV(CBIV, para)
    CBIV = CBIV(:); CBIV = CBIV';
    X = para.X;
    [L, ~] = size(X);
    [~, C] = size(CBIV);
    cluster_count = zeros(C, 1);
    band_cluster = size(L, 1);
    cur_index = 1;
    band_cluster(1) = 1;
    for i = 2 : L
        if i > CBIV(cur_index)
            cur_index = cur_index + 1;
        end
        band_cluster(i) = cur_index;
        cluster_count(cur_index) = cluster_count(cur_index) + 1;
    end
    
    band_set = clu_rnk_bnd_sel(band_cluster(:), para.bnds_rnk(:)); 
end

