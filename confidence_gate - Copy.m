function [final_class, confidence] = confidence_gate( ...
    scores, conf_feat, snr_est, class_names)

% --- Normalize ECOC scores ---
scores = scores - max(scores);
p = exp(scores);
p = p / sum(p);

[p_max, idx] = max(p);
p_sorted = sort(p,'descend');
margin = p_sorted(1) - p_sorted(2);

confidence = p_max * margin;

% --- SNR-aware scaling ---
snr_gain = min(max((snr_est + 5)/15, 0.3), 1);
confidence = confidence * snr_gain;

% --- Decision ---
T = 0.15;   % start low, tune later

if confidence < T
    final_class = "UNKNOWN";
else
    final_class = string(class_names(idx));
end
end
