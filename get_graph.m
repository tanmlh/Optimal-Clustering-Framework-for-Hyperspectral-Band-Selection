%{ 
    Author:    Fahong Zhang
    Reference: L. Zelnik-Manor and P. Perona, ¡°Self-tuning spectral clustering,¡± in 990
               Proc. 17th Adv. Neural Inf. Process. Syst. (NIPS), Vancouver, BC, 991
               Canada, Dec. 2004, pp. 1601¨C1608.
    Function:  Conduct the global optimal clustering framework with given CBIV
    Input:     X: input data set, with size L * N
    Output:    S: similarity matrix, with size L * L
%}

function S = get_graph(X)
    [L, ~] = size(X);
    S = sqrt(L2_distance(X', X'));
    sorted_S = sort(S, 2);
    sigma = zeros(L, 1);
    sigma(1:L) = sorted_S(1:L, 7);
    for i = 1 : L
        for j = 1 : L
            S(i, j) = exp(- S(i, j) * S(i, j) / (sigma(i) * sigma(j)));
        end
    end
end

% compute squared Euclidean distance
% ||A-B||^2 = ||A||^2 + ||B||^2 - 2*A'*B
function d = L2_distance(a,b)
% a,b: two matrices. each column is a data
% d:   distance matrix of a and b
    if (size(a,1) == 1)
      a = [a; zeros(1,size(a,2))]; 
      b = [b; zeros(1,size(b,2))]; 
    end

    aa=sum(a.*a); bb=sum(b.*b); ab=a'*b; 
    d = repmat(aa',[1 size(bb,2)]) + repmat(bb,[size(aa,2) 1]) - 2*ab;

    d = real(d);
    d = max(d,0);
end