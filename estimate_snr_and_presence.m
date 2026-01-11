function [snr_est, signal_present] = estimate_snr_and_presence(x, fs)

x = x(:).';

% Welch PSD
[pxx,~] = pwelch(x, hamming(256), 128, 512, fs);

noise_floor = median(pxx);
signal_power = mean(pxx);

snr_est = 10*log10(signal_power / (noise_floor+eps));

% Presence gate
signal_present = snr_est > -3;   % EW-reasonable
end
