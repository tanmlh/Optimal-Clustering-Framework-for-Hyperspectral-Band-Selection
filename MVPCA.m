function [I, rnk_val] = MVPCA( X )
    [L, ~] = size(X);
    for i = 1 : L
        X(i, :) = X(i, :) - mean(X(i, :));
    end
    XXt = X * X';
    rnk_val = diag(XXt);
    [temp_rank, I] = sort(rnk_val, 'descend');
    for i = 1 : L
        rnk_val(I(i)) = temp_rank(i);
    end
end

