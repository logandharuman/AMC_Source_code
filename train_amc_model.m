clc; clear; close all;

numSamples = 6000;
X = [];
Y = [];

for k = 1:numSamples
    [x, label, fs, snr] = gen_amc_dataset();

    feat = extract_features_iq_EW_full(x, fs);
    X = [X; feat];
    Y = [Y; label];
end

Y = categorical(Y);

% ===========================
% NORMALIZATION (RIGHT PLACE)
% ===========================
mu    = mean(X, 1);
sigma = std(X, 0, 1) + eps;

Xn = (X - mu) ./ sigma;

% ===========================
% TRAIN CLASSIFIER
% ===========================
trained_model = fitcecoc( ...
    Xn, Y, ...
    'Learners','linear', ...
    'Coding','onevsall', ...
    'ClassNames', categories(Y));

% ===========================
% SAVE EVERYTHING REQUIRED
% ===========================
save trained_model trained_model mu sigma
