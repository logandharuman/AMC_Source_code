function [X,Y,SNR] = build_feature_dataset(Nsamples)

X = [];
Y = [];
SNR = [];

for k = 1:Nsamples
    [x,label,fs,snr] = gen_amc_dataset();
    feat = extract_features_iq_EW_full(x,fs);

    X = [X; feat];
    Y = [Y; label];
    SNR = [SNR; snr];
end
end
