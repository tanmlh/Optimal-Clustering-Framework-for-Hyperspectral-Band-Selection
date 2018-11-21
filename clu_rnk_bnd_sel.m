%{ 
    Author:    Fahong Zhang
    Reference: Q. Wang, F. Zhang, and X. Li, ¡°Optimal Clustering Framework 
               for Hyperspectral Band Selection,¡± IEEE Transactions on Geoscience 
               and Remote Sensing (T-GRS), DOI: 10.1109/TGRS.2018.2828161, 2018.
    Input:     bnds_cls: a L*1 vector, contains the cluster id of each band,
               bnds_rnk: a L*1 vector, bnds_rnks(i) is the band with the ith largest rank value
    Output:    bnds_id: a C*1 vector, the ids of the selected bands
%}
function [ bnds_id ] = clu_rnk_bnd_sel( clu_res, bnds_rnk )
    C = max(clu_res);
    [L, ~] = size(clu_res);
    vis = zeros(C, 1);
    bnds_id = [];
    for i = 1 : L
        cur_cls_id = clu_res(bnds_rnk(i));
        if vis(cur_cls_id) == 0
            vis(cur_cls_id) = 1;
            bnds_id = [bnds_id bnds_rnk(i)];
        end
    end
end

