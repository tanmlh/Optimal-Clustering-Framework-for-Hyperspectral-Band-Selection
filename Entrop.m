function [I, rak_val] = Entrop(X)
    G = 256;
    [L, N] = size(X);
    rak_val = zeros(L, 1);
    minX = min(X(:));
    maxX = max(X(:));
    edge = linspace(minX, maxX, G);
    for i = 1 : L
        histX = hist(X(i, :), edge) / N;
        rak_val(i) = - histX * log(histX + eps)';
    end
    [temp_rank, I] = sort(rak_val, 'descend');
    for i = 1 : L
        rak_val(I(i)) = temp_rank(i);
    end    
end
