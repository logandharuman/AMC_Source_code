clc;
clear;
close all;

load('trained_model.mat','trained_model','mu','sigma')


[x, true_label, fs, snr] = gen_amc_dataset();

[snr_est, present] = estimate_snr_and_presence(x,fs);

if ~present
    disp("NOISE ONLY");
    return;
end

feat = extract_features_iq_EW_full(x,fs);
feat_n = (feat - mu) ./ sigma;
[label, scores] = predict(trained_model, feat_n);

[class, conf] = confidence_gate( ...
    scores, feat_n, snr_est, trained_model.ClassNames);

label = string(label);

disp("True label: " + true_label)
disp("Predicted label: " + label)
fprintf("Confidence: %.3f\n", conf)
