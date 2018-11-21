%{ 
    Author:    Fahong Zhang
    Reference: Q. Wang, F. Zhang, and X. Li, ¡°Optimal Clustering Framework 
               for Hyperspectral Band Selection,¡± IEEE Transactions on Geoscience 
               and Remote Sensing (T-GRS), DOI: 10.1109/TGRS.2018.2828161, 2018.
    Function:  Get a map according to Eq. (14)
    Input:     Similarity matrix S, with size L * L
    Output:    A matrix F, with size L * L, F(i, j) = f_{na}(X_i^j)
%}

function [F] = get_F_NC(S)
    [~, L] = size(S);

    Sw = zeros([L, L]);
    Sb = zeros([L, L]);
    Pre = zeros(L, L);
    Post = zeros(L, L);
    Sum_S = zeros(L, 1);
    
    for i = 1 : L
        Sum_S(i) = sum(S(i, :));
    end
    Pre(:, 1) = S(:, 1);
    Post(:, L) = S(:, L);
    for i = 1 : L
        for j = 2 : L
            Pre(i, j) = Pre(i, j-1) + S(i, j);
        end
        for j = L-1 : -1 : 1
            Post(i, j) = Post(i, j+1) + S(i, j);
        end
    end
    for i = 1 : L
        for j = 1 : L
            for k = i : j
                f = 0;
                if i ~= 1
                    f = Pre(k, i-1);
                end
                b = 0;
                if j ~= L
                    b = Post(k, j+1);
                end
                
                Sw(i, j) = Sw(i, j) + Sum_S(k) - f - b - S(i, i);
                Sb(i, j) = Sb(i, j) + Sum_S(k);
            end
            
        end
    end
    F = Sw ./ Sb;
 end
