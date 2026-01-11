clc;
for k = 1:10
    [x, true_label, fs, snr] = gen_amc_dataset();
    feat = extract_features_iq_EW_full(x, fs, false);

    [~, scores] = predict(trained_model, feat);

    % normalize
    scores = scores - max(scores);
    p = exp(scores); 
    p = p / sum(p);

    [cls, conf] = confidence_gate(scores, [], snr, trained_model.ClassNames);

    fprintf("True=%s  Pred=%s  Conf=%.2f  SNR=%.1f  p_max=%.2f\n", ...
        true_label, cls, conf, snr, max(p));
end
