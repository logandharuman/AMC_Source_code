clc;
close all;

load('trained_model.mat','trained_model','mu','sigma')

% Build unseen test set (RAW FEATURES)
[Xt,Yt,Snr] = build_feature_dataset(1000);
Yt = categorical(Yt);

% ============================
% NORMALIZE USING TRAIN STATS
% ============================
Xt = (Xt - mu) ./ sigma;

% Predict
Yp = predict(trained_model, Xt);
Yp = categorical(Yp);

% Confusion matrix
figure;
confusionchart(Yt, Yp);
title("AMC Confusion Matrix (Classifier Only)");

% Accuracy vs SNR
snr_bins = [-5 0 5 10];
acc = zeros(length(snr_bins)-1,1);

for k = 1:length(acc)
    idx = Snr>=snr_bins(k) & Snr<snr_bins(k+1);
    acc(k) = mean(Yp(idx)==Yt(idx));
end

figure;
plot(snr_bins(1:end-1)+2.5, acc, '-o');
xlabel("SNR (dB)");
ylabel("Accuracy");
grid on;
title("Classifier Accuracy vs SNR");
