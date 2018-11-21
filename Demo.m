%{ 
    Author:      Fahong Zhang
    Reference:   Q. Wang, F. Zhang, and X. Li, ¡°Optimal Clustering Framework 
                 for Hyperspectral Band Selection,¡± IEEE Transactions on Geoscience 
                 and Remote Sensing (T-GRS), DOI: 10.1109/TGRS.2018.2828161, 2018.
    Function:    A demo of using OCF to conduct TRC-OC-FDPC, NC-OC-MVPCA and 
                 NC-OC-IE. 
    Instruction: This file shows how to use OCF to do band selection,
                 Indian Pines data set is used as an example.
%}

% Load data
A = double(importdata('Indian_pines_corrected.mat'));
X = permute(A, [3, 1, 2]);

% Here X can be linearly normalized to [0, 1], or just keep unchanged.
X = X(:, :);


% Number of bands
k = 14;

%% An example to conduct TRC-OC-FDPC:

% Achieve the ranking values of band via E-FDPC algorithm
[L, ~] = size(X);
D = E_FDPC_get_D(X');
[~, bnds_rnk_FDPC] = E_FDPC(D, L);

% Construct a similarity graph
S_FG = get_graph(X);

% Get the map f in Eq. (16)
F_TRC_FDPC = get_F_TRC(S_FG, bnds_rnk_FDPC);

% Set the parameters of OCF, to indicate the objective function is TRC
para_TRC_FDPC.bnds_rnk = bnds_rnk_FDPC;
para_TRC_FDPC.F = F_TRC_FDPC;
para_TRC_FDPC.is_maximize = 0; % TRC should be minimized
para_TRC_FDPC.X = X; 
para_TRC_FDPC.operator_name = 'max'; % use 'max' operator for Eq. (8)

% Selection
band_set = ocf(para_TRC_FDPC, k);

sort(band_set)

%% An example to conduct NC-OC-MVPCA:

% Achieve the ranking values of band via MVPCA algorithm
[para_NC_PCA.bnds_rnk, ~ ] = MVPCA(X);

% Construct a similarity graph
S_FG = get_graph(X);

% Get the map f in Eq. (16)
F_NC_FG = get_F_NC(S_FG);

% Set the parameters of OCF, to indicate the objective function is NC
para_NC_PCA.F = F_NC_FG;
para_NC_PCA.is_maximize = 1; % NC should be maximized
para_NC_PCA.X = X; 
para_NC_PCA.operator_name = 'sum'; % use 'sum' operator for Eq. (8)

% Selection
band_set = ocf(para_NC_PCA, k);

sort(band_set)

%% An example to conduct NC-OC-IE:

% Achieve the ranking values of band via MVPCA algorithm
[para_NC_IE.bnds_rnk, ~] = Entrop(X);

% Construct a similarity graph
S_FG = get_graph(X);

% Set the parameters of OCF, to indicate the objective function is NC
para_NC_IE.F = F_NC_FG; 
para_NC_IE.is_maximize = 1; % NC should be maximized
para_NC_IE.X = X; 
para_NC_IE.operator_name = 'sum'; % use 'sum' operator for Eq. (8)

% Selection
band_set = ocf(para_NC_IE, k);

sort(band_set)